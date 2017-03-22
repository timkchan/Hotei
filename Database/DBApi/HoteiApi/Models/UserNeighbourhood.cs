using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace HoteiApi.Models
{
    public class UserNeighbourhood
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]

        public int userId { get; set; }
        public string neighbours { get; set; }
        public string similiarity { get; set; }

    }

}