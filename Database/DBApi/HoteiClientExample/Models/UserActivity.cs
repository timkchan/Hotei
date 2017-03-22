using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HoteiClientExample.Models
{
    public class UserActivity
    {
        public int UserId;
        public String Activity;
        public double Rating;

        public UserActivity(int uid , String A, double R) {

            UserId = uid;
            Activity = A;
            Rating = R;
        }

    }

    public class UserActivityList
    {

        public int UserId;
        public List<Activities> Activities = new List<Activities>();

        public UserActivityList(int Id)
        {
            UserId = Id;
        }


    }

    public class Activities
    {
        public String Activity;
        public double Rating;

        public Activities(String A, double R)
        {
            Activity = A;
            Rating = R;
        }
    }
}
