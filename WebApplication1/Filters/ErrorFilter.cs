using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
using System.Net;

namespace PodrziMe.Filters
{
    public class ErrorFilter :ExceptionFilterAttribute
    {
        public override void OnException(ExceptionContext context)
        {
            if (context.Exception is DbUpdateException dbUpdateEx)
            {
                if (dbUpdateEx.InnerException is SqlException sqlEx)
                {
                    if (sqlEx.Number == 2627 || sqlEx.Number == 2601) // Unique constraint violation
                    {
                        context.Result = new JsonResult(new
                        {
                            code = sqlEx.Number, // send the error number
                            message = "Korisničko ime već postoji. Molimo odaberite drugo."
                        })
                        {
                            StatusCode = (int)HttpStatusCode.BadRequest
                        };
                        context.ExceptionHandled = true;
                        return;
                    }
                }
            }


        }

    }
}
