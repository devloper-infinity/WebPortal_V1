using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.IT
{
    public partial class TIcketQueue : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllTickets()
        {
            int LoginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable dt1 = new bllAsset().GetAllTicketDepartmentwise(LoginEmp);
            List<Dictionary<string, object>> rows = BuildTicketRows(dt1, LoginEmp, false);
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        private static List<Dictionary<string, object>> BuildTicketRows(DataTable dt, int LoginEmp, bool onlyMyQueue)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt == null) return rows;

            string[] possibleAssignedColumns = new string[] { "AssignTo", "AssignedTo", "AssignToId", "AssignedToId", "AssignedEmpId", "AssignedEmployeeId", "OwnerId", "TechnicianId", "AssigneeId", "AssignToEmpId" };
            string[] possibleAssignedNameColumns = new string[] { "AssignToName", "AssignedToName", "AssignedEmployee", "OwnerName", "TechnicianName", "AssigneeName" };

            foreach (DataRow dr in dt.Rows)
            {
                int assignedTo = 0;
                foreach (string col in possibleAssignedColumns)
                {
                    if (dt.Columns.Contains(col))
                    {
                        int.TryParse(Convert.ToString(dr[col]), out assignedTo);
                        if (assignedTo > 0) break;
                    }
                }

                string assignedName = "";
                foreach (string col in possibleAssignedNameColumns)
                {
                    if (dt.Columns.Contains(col))
                    {
                        assignedName = Convert.ToString(dr[col]);
                        if (!String.IsNullOrWhiteSpace(assignedName)) break;
                    }
                }

                bool isAssigned = assignedTo > 0 || !String.IsNullOrWhiteSpace(assignedName);
                bool isAssignedToMe = assignedTo > 0 && assignedTo == LoginEmp;
                bool canTakeAction = !isAssigned || isAssignedToMe;

                if (onlyMyQueue && !isAssignedToMe) continue;

                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col];
                }
                row["LoginEmp"] = LoginEmp;
                row["AssignedToUserId"] = assignedTo;
                row["AssignedToUserName"] = assignedName;
                row["IsAssigned"] = isAssigned;
                row["IsAssignedToMe"] = isAssignedToMe;
                row["CanTakeAction"] = canTakeAction;
                rows.Add(row);
            }
            return rows;
        }

        [WebMethod]
        public static string GetEmpsByDept()
        {
            DataTable dt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            DataTable dt1 = new bllMaster().GetEmpsByDept(Convert.ToInt32(dt.Rows[0]["Department"]));

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int AssignTicketToSelf(int TicketID)
        {
            int LoginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            return new bllAsset().InsertTicketAssignTo(LoginEmp, LoginEmp, TicketID);
        }

        [WebMethod]
        public static string GetMyQueue()
        {
            int LoginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable dt1 = new bllAsset().GetAllTicketDepartmentwise(LoginEmp);
            List<Dictionary<string, object>> rows = BuildTicketRows(dt1, LoginEmp, true);
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int InsertTicketAssignTo(int AssignTo, int TicketID)
        {
            int ReturnValue = 0;

            ReturnValue = new bllAsset().InsertTicketAssignTo(AssignTo, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), TicketID);

            return ReturnValue;
        }
    }
}