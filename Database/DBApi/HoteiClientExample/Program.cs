using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RestSharp;
using HoteiClientExample.Models;

namespace HoteiClientExample
{
    class Program
    {
        static void Main(string[] args)
        {
            //////////////////////////////////////////////////////////////

            Console.Write("Starting New User Profile Example \r\n" );

            UserActivityList ual = new UserActivityList(23);
            ual.Activities.Add(new Activities("football", 1.0));
            ual.Activities.Add(new Activities("reading", 1.0));

            var client = new RestClient("http://localhost:63498/");

            var request = new RestRequest("generateNewUserProfile", Method.POST);
            request.AddJsonBody(ual);
            request.AddHeader("Content-Type", "application/json");

            IRestResponse response = client.Execute(request);
            var content = response.Content;

           
            Console.Write(content);

            Console.Write("Ending New User Profile Example\r\n");

            //////////////////////////////////////////////////////////////

            Console.Write("Start Current User Performs Activity\r\n");

            UserActivity ua = new UserActivity(123, "football", 2);
            request = new RestRequest("UserPerformActivity", Method.POST);
            request.AddJsonBody(ua);
            request.AddHeader("Content-Type", "application/json");

            response = client.Execute(request);
            content = response.Content;

            Console.Write(content);

            Console.Write("End Current User Performs Activity\r\n");

            //////////////////////////////////////////////////////////////
            Console.ReadKey();

        }
    }
}
