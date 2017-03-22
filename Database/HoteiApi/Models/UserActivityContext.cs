using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace HoteiApi.Models
{
    public class UserActivityContext
    {
        public int UserId { get; set; }
        public String Activity { get; set; }
        public double Rating { get; set; }
    }
}