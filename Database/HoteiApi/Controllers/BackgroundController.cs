using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using HoteiApi.Models;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.Statistics;
namespace HoteiApi.Controllers
{
    public class BackgroundController : ApiController
    {
        UserNeighbourhoodsController unc = new UserNeighbourhoodsController();

        //This needs to be admin protected nick

        private UserActivitiesController uac = new UserActivitiesController();

        [Route("CheckDBNotEmpty")]
        [HttpGet]
        public IHttpActionResult CheckDBNotEmpty()
        {
            if (uac.checkDbEmpty())
                return Ok();

            return BadRequest();
        }


        [Route("RunBackgroundProcess")]
        [HttpPost]
        public IHttpActionResult RunBackgroundProcess()
        {

            Dictionary<int, int> userIndexMap = new Dictionary<int, int>();
            List<int> userList = uac.GetAllUsers();
            List<string> activityList = uac.GetAllActivities();

            //declare the utility matrix 
            double[][] utilityMatrix = BuildUtilityMatrix(ref userIndexMap, userList, activityList);

            //PCA model builder
            PCAModelBuilder(ref utilityMatrix);

            //////run neighbourhood model;
            runNeighbourhoodModel(utilityMatrix, userIndexMap);

            return Ok();
        }

        private void PCAModelBuilder(ref double[][] utilityMatrix)
        {
            var M = Matrix<double>.Build.DenseOfColumnArrays(utilityMatrix).Transpose();
            var M_adj = Matrix<double>.Build.DenseOfMatrix(M);

            for (var r = 0; r < M.RowCount; r++)
            {
                for (var c = 0; c < M.ColumnCount; c++)
                {
                    if (M[r, c] == 0)
                        M_adj[r, c] = M.Column(c).Average();
                }

                M_adj.SetRow(r, M_adj.Row(r).Subtract(M.Row(r).Average()));
            }

            var decomposedM = M_adj.Svd();
            var S = decomposedM.W.PointwiseSqrt();
            var U = decomposedM.U;

            utilityMatrix = (U * S).ToRowArrays();
        }

        private void runNeighbourhoodModel(double[][] utilityMatrix, Dictionary<int, int> userIndexMap)
        {
            var correlation = Correlation.PearsonMatrix(utilityMatrix);
            int k = (int)Math.Floor(Math.Sqrt(userIndexMap.Count - 1));
            for (var i = 0; i < userIndexMap.Count; i++)
            {
                var current_user = correlation.Column(i);
                List<int> neighbours = new List<int>();
                List<double> similarity = new List<double>();
                //set the cross corrs = -1 so they are not considered neighbours
                current_user[i] = -1;
                //add the top k neighbours to the neibourhood table
                for (var n = 0; n < k; n++)
                {
                    int top = current_user.MaximumIndex();
                    similarity.Add(current_user[top]);
                    neighbours.Add(userIndexMap[top]);
                    current_user[top] = -1;
                }
                unc.AddUserNeighbourhood(userIndexMap[i], neighbours, similarity);
            }

        }

        private double[][] BuildUtilityMatrix(ref Dictionary<int, int> userIndexMap, List<int> userList, List<string> activityList)
        {
            Dictionary<string, int> ActivityIndexMap = new Dictionary<string, int>();
            //declare the utility matrix 
            double[][] utilityMatrix = new double[userList.Count][];

            int iterator = 0;
            //fill utility matrix from entries in DB
            foreach (var i in activityList)
            {
                ActivityIndexMap.Add(i, iterator);
                iterator++;
            }
            iterator = 0;
            foreach (var i in userList)
            {
                userIndexMap.Add(iterator, i);
                UserActivityList ual = uac.GetUsersActivityList(i);
                utilityMatrix[iterator] = new double[activityList.Count];
                foreach (var activity in ual.Activities)
                {
                    int activityIndex = ActivityIndexMap[activity.Activity];
                    utilityMatrix[iterator][activityIndex] = activity.Rating;
                }
                iterator++;
            }

            return utilityMatrix;
        }

    }
}
