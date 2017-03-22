using HoteiApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HoteiApi.Controllers
{
    public class NewUserController : ApiController
    {

        //TODO: Add facebook profile builder

        private UserActivitiesController uac = new UserActivitiesController();

        /// <summary>
        /// Build a profile for a new user, takes in activities list and facebook profile auth code (not yet implemented)
        /// </summary>

        [Route("generateNewUserProfile")]
        [HttpPost]
        public IHttpActionResult PostUserActivity(UserActivityList activities)
        {
            try
            {
                checkUACModelState(activities);
            }
            catch (Exception e)
            {
                return BadRequest("Activities List is invalid.");
            }

            uac.BulkUpdateUserActivity(activities);
            return Ok();
        }

        private void checkUACModelState(UserActivityList activities)
        {

            if (activities.UserId == null)
                throw new Exception();

            if (activities.Activities == null)
                throw new Exception();

            foreach (var i in activities.Activities)
            {
                if (i.Activity == "" || i.Activity == null || i.Rating == 0 || i.Rating == null)
                    throw new Exception();
            }
        }

    }
}
