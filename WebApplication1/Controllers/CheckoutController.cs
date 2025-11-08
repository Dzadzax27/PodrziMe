using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CheckoutController : ControllerBase
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly string _clientId;
        private readonly string _secret;
        private readonly string _paypalUrl;

        public CheckoutController(IConfiguration configuration, IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
            _clientId = configuration["PaypalSettings:ClientId"] ?? throw new ArgumentNullException("PaypalSettings:ClientId");
            _secret = configuration["PaypalSettings:Secret"] ?? throw new ArgumentNullException("PaypalSettings:Secret");
            _paypalUrl = configuration["PaypalSettings:Url"] ?? "https://api.sandbox.paypal.com";
        }

        // Create order - frontend posts amount (in decimal) and currency
        [HttpPost("create-order")]
        public async Task<IActionResult> CreateOrder([FromBody] CreateOrderRequest request)
        {
            if (request == null || request.Amount <= 0) return BadRequest("Invalid request");

            var token = await GetAccessToken();
            if (string.IsNullOrEmpty(token)) return StatusCode(500, "Unable to get PayPal access token");

            var client = _httpClientFactory.CreateClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var orderRequest = new
            {
                intent = "CAPTURE",
                purchase_units = new[]
                {
                    new {
                        amount = new {
                            currency_code = request.Currency ?? "USD",
                            value = request.Amount.ToString("F2")
                        },
                        description = request.Description ?? "Purchase"
                    }
                },
                application_context = new
                {
                    brand_name = request.MerchantName ?? "PodrziMe",
                    landing_page = "NO_PREFERENCE",
                    user_action = "PAY_NOW",
                    return_url = request.ReturnUrl ?? "https://example.com/return",
                    cancel_url = request.CancelUrl ?? "https://example.com/cancel"
                }
            };

            var json = JsonSerializer.Serialize(orderRequest);
            var httpContent = new StringContent(json, Encoding.UTF8, "application/json");

            var createOrderUrl = $"{_paypalUrl}/v2/checkout/orders";
            var response = await client.PostAsync(createOrderUrl, httpContent);

            var respStr = await response.Content.ReadAsStringAsync();
            if (!response.IsSuccessStatusCode)
            {
                // log respStr in real app
                return StatusCode((int)response.StatusCode, respStr);
            }

            using var doc = JsonDocument.Parse(respStr);
            var root = doc.RootElement;
            var id = root.GetProperty("id").GetString();
            string? approveUrl = null;

            if (root.TryGetProperty("links", out var links))
            {
                foreach (var l in links.EnumerateArray())
                {
                    if (l.GetProperty("rel").GetString() == "approve")
                    {
                        approveUrl = l.GetProperty("href").GetString();
                        break;
                    }
                }
            }

            return Ok(new { orderId = id, approveUrl });
        }

        // Capture order - frontend will call this after user approves payment (redirect/callback)
        [HttpPost("capture-order")]
        public async Task<IActionResult> CaptureOrder([FromBody] CaptureOrderRequest req)
        {
            if (req == null || string.IsNullOrEmpty(req.OrderId)) return BadRequest("orderId required");

            var token = await GetAccessToken();
            if (string.IsNullOrEmpty(token)) return StatusCode(500, "Unable to get PayPal access token");

            var client = _httpClientFactory.CreateClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var captureUrl = $"{_paypalUrl}/v2/checkout/orders/{req.OrderId}/capture";

            var response = await client.PostAsync(
                captureUrl,
                new StringContent("{}", Encoding.UTF8, "application/json")
            );

            var respStr = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
            {
                return StatusCode((int)response.StatusCode, respStr);
            }

            return Ok(JsonSerializer.Deserialize<JsonElement>(respStr));
        }


        // -- PRIVATE HELPERS --

        private async Task<string?> GetAccessToken()
        {
            var client = _httpClientFactory.CreateClient();
            var credentials = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{_clientId}:{_secret}"));

            using var req = new HttpRequestMessage(HttpMethod.Post, $"{_paypalUrl}/v1/oauth2/token");
            req.Headers.Authorization = new AuthenticationHeaderValue("Basic", credentials);
            req.Content = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("grant_type", "client_credentials") });

            var resp = await client.SendAsync(req);
            var body = await resp.Content.ReadAsStringAsync();
            if (!resp.IsSuccessStatusCode) return null;

            using var doc = JsonDocument.Parse(body);
            if (doc.RootElement.TryGetProperty("access_token", out var t))
                return t.GetString();

            return null;
        }
    }

    // DTOs
    public record CreateOrderRequest(decimal Amount, string? Currency = "USD")
    {
        public string? Description { get; init; }
        public string? ReturnUrl { get; init; }
        public string? CancelUrl { get; init; }
        public string? MerchantName { get; init; }
    }

    public record CaptureOrderRequest(string OrderId);
}
