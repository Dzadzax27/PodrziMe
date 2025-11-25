using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class MessageService
    {
        public async Task SendHelloWorldAsync()
        {
        //    var factory = new ConnectionFactory { HostName = "localhost" };

        //    using var connection = await factory.CreateConnectionAsync();
        //    using var channel = await connection.CreateChannelAsync();

        //    await channel.QueueDeclareAsync(
        //        queue: "podrziMe_queue",
        //        durable: false,
        //        exclusive: false,
        //        autoDelete: false,
        //        arguments: null
        //    );

        //    const string message = "Hello World!";
        //    var body = Encoding.UTF8.GetBytes(message);

        //    await channel.BasicPublishAsync(
        //        exchange: string.Empty,
        //        routingKey: "podrziMe_queue",
        //        body: body
        //    );
        //
        }
    }
}
