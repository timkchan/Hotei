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
using System.Web.ModelBinding;

namespace HoteiApi.Controllers
{
    public class UserActivitiesController
    {
        private HoteiApiContext db = new HoteiApiContext();


        public IQueryable<UserActivity> getAll()
        {
            return db.UserActivities;
        }

        public List<int> GetAllUsers()
        {

            var allusers = (from UserActivity in db.UserActivities
                            group UserActivity by UserActivity.UserId into g
                            select g.Key).ToList();

            return allusers;
        }
        
        public bool checkDbEmpty()
        {
            if (db.UserActivities.Any())
                return true;

            return false;
        }

        public List<string> GetAllActivities()
        {
            var allactivities = (from UserActivity in db.UserActivities
                                 group UserActivity by UserActivity.Activity into g
                                 select g.Key).ToList();

            return allactivities;
        }

        public UserActivityList GetUsersActivityList(int userId)
        {
            UserActivityList user = new UserActivityList(userId);

            var UserInfo = from UserActivity in db.UserActivities
                           where UserActivity.UserId == userId
                           select UserActivity;

            foreach (var x in UserInfo)
            {
                Activities entry = new Activities(x.Activity, x.Rating);
                user.Activities.Add(entry);
            }

            if (!user.Activities.Any())
            {
                throw new Exception("User Id not found");
            }

            return user;
        }

        public void UpdateUserActivity(UserActivity userActivity)
        {
            UserActivity row = db.UserActivities.Find(userActivity.UserId, userActivity.Activity);

            if (row == null)
                db.UserActivities.Add(userActivity);
            else
            {
                //Positive = 1
                //Negative = -1
                //Neutral = 0

                //bound the lower rating to 1
                if (row.Rating == 1 && userActivity.Rating == -1)
                {
                    row.Rating = 1;
                }
                //bound upper rating to 10
                else if (row.Rating == 10 && userActivity.Rating == 1)
                {
                    row.Rating = 10;
                }
                else
                {
                    row.Rating = row.Rating + userActivity.Rating;
                }
            }
                

            db.SaveChanges();
        }

        public void BulkUpdateUserActivity(UserActivityList userlist)
        {
            foreach (var i in userlist.Activities)
            {
                UserActivity row = db.UserActivities.Find(userlist.UserId, i.Activity);

                if (row == null)
                    db.UserActivities.Add(new UserActivity { UserId = userlist.UserId, Activity = i.Activity, Rating = i.Rating });
                else
                    row.Rating = (i.Rating + row.Rating) / 2;

                db.SaveChanges();

            }

        }

    }
}