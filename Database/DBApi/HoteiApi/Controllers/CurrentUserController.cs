using HoteiApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HoteiApi.Controllers
{
    public class CurrentUserController : ApiController
    {
        private UserActivitiesController uac = new UserActivitiesController();
        private UserNeighbourhoodsController unc = new UserNeighbourhoodsController();


        ///<summary>
        ///testing purposes
        /// </summary>
        [Route("GetAllData")]
        [HttpGet]
        public IHttpActionResult getAll()
        {
            return Ok(uac.getAll());
        }
        
        /// <summary>
        /// When a user performs an activity, this either updates their rating for that activity or add it as a new activity.
        /// </summary>
        [Route("UserPerformActivity")]
        [HttpPost]
        public IHttpActionResult PostUserActivity(UserActivity activity)
        {
            try
            {
                checkUAModelState(activity);
            }
            catch (Exception e)
            {
                return BadRequest("Activity Input is invalid.");
            }

            uac.UpdateUserActivity(activity);
            return Ok();
        }

        /// <summary>
        /// Get a recommendation for a specific user
        /// </summary>

        [Route("GetUserRecommendation")]
        [HttpGet]
        public IHttpActionResult GetRecommendation(int userID, int numRec)
        {
            var prediction_u_i = new List<Activities>();
            UserActivityList userprofile = new UserActivityList();

            try
            {
                userprofile = uac.GetUsersActivityList(userID);
                predictUserPreference(userID, userprofile, ref prediction_u_i);
            }
            catch(MissingMemberException) {}
            catch(Exception e){return BadRequest(e.Message);}

            userprofile.Activities.ForEach(x => prediction_u_i.Add(new Activities(x.Activity, x.Rating)));
            prediction_u_i.OrderBy(x => x.Rating);

            // Add context filer here;

            //Random Wheel Selection
            var numRecommendations = Math.Min(numRec,prediction_u_i.Count);
            var recommendation = new List<string>();

            for(var i = 0; i<numRecommendations; i++)
            {
                recommendation.Add(prediction_u_i[routletteSelect(prediction_u_i)].Activity);
            }

            return Ok(recommendation.Distinct());
        }

        private void checkUAModelState(UserActivity activity)
        {

            if (activity.Activity == null || activity.Activity == "" || activity.Rating == 0)
                throw new Exception();

        }
        private void predictUserPreference(int userID, UserActivityList userprofile,ref List<Activities> prediction_u_i)
        {

            UserNeighbourhood neighbours = unc.GetUserNeighbourhood(userID);

            var similarity = neighbours.similiarity.Split(';').Select(double.Parse).ToList();
            var neighbour = neighbours.neighbours.Split(';').Select(int.Parse).ToList();

            List<string> allActivities = uac.GetAllActivities();

            double averageUserProfile = userprofile.Activities.Sum(x => x.Rating) / userprofile.Activities.Count;
            userprofile.Activities.ForEach(x => allActivities.Remove(x.Activity));

            foreach (var activity in allActivities)
            {
                double top = 0;
                double bottom = 0;
                double rating = 0.0;

                for (var i = 0; i < neighbour.Count; i++)
                {
                    if (neighbour[i] != userID)
                    {
                        var neighbourProfile = uac.GetUsersActivityList(neighbour[i]);
                        double avgNProfile = neighbourProfile.Activities.Sum(x => x.Rating) / neighbourProfile.Activities.Count;
                        double ratingItemNeighbour = 0.0;
                        if (neighbourProfile.Activities.Exists(x => x.Activity == activity))
                            ratingItemNeighbour = neighbourProfile.Activities.First(x => x.Activity == activity).Rating;

                        top = top + (similarity[i] * (ratingItemNeighbour - avgNProfile));
                        bottom = bottom + Math.Abs(similarity[i]);
                    }
                }
                if (bottom == 0)
                    rating = averageUserProfile;
                else
                    rating = averageUserProfile + (top / bottom);

                prediction_u_i.Add(new Activities(activity, rating));
            }

        }
        private int routletteSelect(List<Activities> prediction_u_i)
        {
            double weight = prediction_u_i.Sum(x => x.Rating);
            Random rand = new Random();
            double value = weight * rand.NextDouble();

            for (var i = 0; i< prediction_u_i.Count; i++) {
                value -= prediction_u_i[i].Rating;
                if (value <= 0)
                    return i;
            }
            return prediction_u_i.Count - 1;
        }


    }
}
