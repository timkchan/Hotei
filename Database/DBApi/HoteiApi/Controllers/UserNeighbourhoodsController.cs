using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using HoteiApi.Models;

namespace HoteiApi.Controllers
{
    public class UserNeighbourhoodsController
    {
        private HoteiApiContext db = new HoteiApiContext();

        public UserNeighbourhood GetUserNeighbourhood(int userId)
        {
            UserNeighbourhood userNeighbourhood = db.UserNeighbourhoods.Find(userId);
            if (userNeighbourhood == null)
            {
                throw new MissingMemberException();
            }
            return userNeighbourhood;
        }

        public void AddUserNeighbourhood(int userId, List<int> neighbours, List<double> similarity)
        {
            UserNeighbourhood row = db.UserNeighbourhoods.Find(userId);

            if (row == null)
            {
                UserNeighbourhood un = new UserNeighbourhood { userId = userId, neighbours = string.Join(";", neighbours), similiarity = string.Join(";", similarity) };
                db.UserNeighbourhoods.Add(un);
            }
            else
                row.neighbours = string.Join(";", neighbours);
                row.similiarity = string.Join(";",similarity);
            db.SaveChanges();
        }

    }
}