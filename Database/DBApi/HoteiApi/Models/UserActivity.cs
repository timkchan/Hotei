using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace HoteiApi.Models
{
    public class UserActivity
    {
        [Column(Order = 0), Key, Required]
        public int UserId { get; set; }
        [Column(Order = 1), Key, Required]
        public String Activity { get; set; }
        public double Rating { get; set; }
    }

    public class UserActivityList
    {

        public int UserId;
        public List<Activities> Activities = new List<Activities>();

        public UserActivityList() { }
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