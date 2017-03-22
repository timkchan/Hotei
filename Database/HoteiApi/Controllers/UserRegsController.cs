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
    public class UserRegsController : ApiController
    {
        private HoteiApiContext db = new HoteiApiContext();

        public class returnUser
        {
            public int status { get; set; }
            public int code { get; set; } 
        }
        //STATUS = 0 : Login not success, STATUS = 1 : Login Success
        //CODE = 0 : Indicates nothing is wrong
        // CODE = 1 : Display user id or password is not correct
        // CODE = 2 : Display user already exists try another

        [Route("getUserProfile")]
        [HttpGet]
        public IHttpActionResult getUserProfile(int userId, string password, bool register)
        {
            UserReg user = db.UserRegs.Find(userId);
            returnUser ru;

            //this user id does not exist and user wants to login 
            if(user == null && register == false)
            {
                ru = new returnUser { status = 0, code = 1 };
                return Ok(ru);
            }// user id exist but user is trying to register
            else if ( user != null && register == true)
            {
                ru = new returnUser { status = 0, code = 2};
                return Ok(ru);
            }// user id exists and user is trying to login
            else if (user != null && register == false)
            {
                //check the user's password
                if(user.Password == password)
                {
                    ru = new returnUser { status = 1, code = 0};
                    return Ok(ru);
                }
                else
                {
                    ru = new returnUser { status = 0, code = 1 };
                    return Ok(ru);
                }
            }
            else if (user == null && register == true)
            {
                //register the user
                UserReg newUser = new UserReg { UserId = userId, Password = password };
                db.UserRegs.Add(newUser);
                try
                {
                    db.SaveChanges();
                }
                catch
                {
                    return BadRequest("Error registering new user");
                }
                ru = new returnUser { status = 0, code = 0 };
                return Ok(ru);
            }
            else
            {
                return BadRequest("Error registering new user");
            }

        }

    }
}