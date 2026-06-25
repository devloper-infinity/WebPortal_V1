using System;
using System.IO;
using System.Net;
using System.Data;
using System.Reflection;
using System.Collections;
using System.Web.Services;
using System.Data.SqlClient;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web;
using System.Linq;
using System.Text.RegularExpressions;
using System.Globalization;

namespace WebPortal.Admin
{
    public partial class DailyProductivity : System.Web.UI.Page
    {
        static SqlConnection con = new SqlConnection("Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192");
        static string UserCode;
        static int UserDomain;
        static DataTable dtProd = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertTempProductivity(string Code, int Applicable, string ClientOrderDate, string Date, string ProjectId, string ProcessID, string ProductId, string Production, string Target, string ProductionType, string TimeSpent, string Remark)
        {
            int ReturnValue = 0;

            if (Applicable == 1)
            {
                Hashtable htdaily = new Hashtable();
                htdaily["Code"] = Code;
                htdaily["Date"] = Convert.ToDateTime(Date).ToString("dd-MMM-yyyy");
                htdaily["ClientOrderDate"] = Convert.ToDateTime(ClientOrderDate).ToString("dd-MMM-yyyy");
                htdaily["Project"] = ProjectId;
                htdaily["Process"] = ProcessID;
                htdaily["Target"] = Target;
                htdaily["Product"] = ProductId;
                htdaily["Prduction"] = Production;
                htdaily["ProductionType"] = ProductionType;
                htdaily["TimeSpent"] = TimeSpent;
                htdaily["Remark"] = Remark;
                htdaily["AddedBy"] = HttpContext.Current.User.Identity.Name.ToString();
                htdaily["InIP"] = GetUserIP();
                htdaily["ProductID"] = ProductId;

                ReturnValue = new bllMaster().InsertDailyProductivitySearching(htdaily);
            }
            else
            {
                ReturnValue = -10;
            }

            return ReturnValue;
        }

        [WebMethod]
        public static int InsertProductivity(string Code)
        {
            int ReturnValue = 0;

            ReturnValue = new bllMaster().InsertDailyProdcutvityInTempDailyProductivityTable(Code);

            return ReturnValue;
        }

        [WebMethod]
        public static int ApproveRejectProductivity(string Indexes, int DomainID, string Codes, string Dates, string ClienODates, string TrackIDs, string Projects, string TrackProcess, string Process, string Productions, string TimeSpent, string TragetIDs)
        {
            int ReturnValue = 0;

            try
            {
                int[] str_Index = Indexes.Substring(2).Split(',').Select(int.Parse).ToArray();
                string[] str_TrackID = TrackIDs.Substring(2).Split(',');
                string[] str_Code = Codes.Substring(2).Split(',');
                string[] str_Date = Dates.Substring(2).Split(',');
                string[] str_CDate = ClienODates.Substring(2).Split(',');
                string[] str_Projects = Projects.Substring(2).Split(',');
                string[] str_TrackProcess = TrackProcess.Substring(2).Split(',');
                string[] str_Process = Process.Substring(2).Split(',');
                string[] str_Traget = TragetIDs.Substring(2).Split(',');
                string[] str_Prod = Productions.Substring(2).Split(',');
                string[] str_TimeSpent = TimeSpent.Substring(2).Split(',');

                foreach (int ind in str_Index)
                {
                    string ProjectID = new bllMaster().ValidateProject(Convert.ToString(str_Projects[ind]));
                    string ProcessID = new bllMaster().ValidateProcess(ProjectID, Convert.ToString(str_TrackProcess[ind]));
                    string ProductType = new bllMaster().ValidateProductType(ProjectID, ProcessID, Convert.ToString(str_Process[ind]));

                    if (ProcessID != "0")
                    {
                        if (DomainID == 9 && ProductType == "0")
                        {
                            ReturnValue = -1;
                            return ReturnValue;
                        }
                        else
                        {
                            if (Convert.ToString(str_Process[ind]) != "")
                            {

                            }
                            else
                            {
                                ReturnValue = -2;
                                return ReturnValue;
                            }

                            if (Convert.ToString(str_TimeSpent[ind]) != "")
                            {

                            }
                            else
                            {
                                ReturnValue = -3;
                                return ReturnValue;
                            }

                            if (Convert.ToString(str_Traget[ind]) != "")
                            {

                            }
                            else
                            {
                                ReturnValue = -4;
                                return ReturnValue;
                            }

                            #region Hashtable

                            Hashtable htParam = new Hashtable();
                            htParam.Add("TrackingProductionID", str_TrackID[ind]);
                            htParam.Add("Code", Convert.ToString(str_Code[ind]));
                            htParam.Add("Date", Convert.ToString(str_Date[ind]));
                            htParam.Add("ClientOrderDate", Convert.ToString(str_CDate[ind]));
                            htParam.Add("Project", Convert.ToInt32(ProjectID));
                            htParam.Add("Process", Convert.ToInt32(ProcessID));
                            htParam.Add("ProductType", ProductType);
                            htParam.Add("Target", Convert.ToString(str_Traget[ind]));
                            htParam.Add("Production", Convert.ToString(str_Prod[ind]));
                            htParam.Add("TimeSpent", Convert.ToString(str_TimeSpent[ind]));
                            htParam.Add("ProductionType", "Live");
                            htParam.Add("Remark", "Auto Productivity in Online Traking sheet");
                            htParam.Add("InIP", GetUserIP());
                            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                            #endregion

                            ReturnValue = new bllMaster().InsertDailyProdcutvityFor_OnlineTracking(htParam);
                        }
                    }
                    else
                    {
                        ReturnValue = -5;
                    }
                }
            }
            catch (Exception ex)
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlCommand cmd1 = new SqlCommand("AddExeceptionMessage", con);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.AddWithValue("@Message", ex.Message);
                cmd1.CommandTimeout = 0;
                cmd1.ExecuteNonQuery();
                con.Close();
            }

            return ReturnValue;
        }

        [WebMethod]
        public static int DeleteTempDailyProductivity(int TempDailyProductivity)
        {
            int ReturnValue = new bllMaster().DeleteTempDailyProductivity(TempDailyProductivity);

            return ReturnValue;
        }

        private static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }

        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }

        [WebMethod]
        public static List<Project> GetProjects(string EmpID)
        {
            DataTable dtProjects = new bllMaster().GetAllProjectByUserRights(EmpID);
            List<Project> prj = new List<Project>();
            prj = ConvertDataTable<Project>(dtProjects);
            return prj;
        }

        [WebMethod]
        public static List<Process> GetProcess(int ProjectID)
        {
            DataTable dtProcess = new bllMaster().getProcess(ProjectID);
            List<Process> prc = new List<Process>();
            prc = ConvertDataTable<Process>(dtProcess);
            return prc;
        }

        [WebMethod]
        public static List<ProductTypes> GetProductType(string ProjectName)
        {
            DataTable dtProd = new bllOST().GetAllProductRelatedToProject(ProjectName);
            List<ProductTypes> prod = new List<ProductTypes>();
            prod = ConvertDataTable<ProductTypes>(dtProd);
            return prod;
        }

        [WebMethod]
        public static string GetTarget(string ProjectId, string ProcessId)
        {
            // string Code = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            string target = "";
            DataTable dt = new bllMaster().getTargetUserWise(UserCode, ProjectId, ProcessId);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    if (Convert.ToString(dt.Rows[0]["Target"]) != "")
                    {
                        target = Convert.ToString(dt.Rows[0]["Target"]);
                    }
                }
            }
            return target;
        }

        [WebMethod]
        public static string GetTarget_Search(string ProjectId, string ProcessId, string Product)
        {
            string Code = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            string target = "";
            DataTable dt = new bllMaster().getTargetUserWise_Productivity(Code, ProjectId, ProcessId, Product);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    if (Convert.ToString(dt.Rows[0]["Target"]) != "")
                    {
                        target = Convert.ToString(dt.Rows[0]["Target"]);
                    }
                }
            }
            return target;
        }

        public static string GetUserIP()
        {
            string strIP = String.Empty;
            HttpRequest httpReq = HttpContext.Current.Request;

            //test for non-standard proxy server designations of client's IP
            if (httpReq.ServerVariables["HTTP_CLIENT_IP"] != null)
            {
                strIP = httpReq.ServerVariables["HTTP_CLIENT_IP"].ToString();
            }
            else if (httpReq.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
            {
                strIP = httpReq.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            //test for host address reported by the server
            else if
            (
                //if exists
                (httpReq.UserHostAddress.Length != 0)
                &&
                //and if not localhost IPV6 or localhost name
                ((httpReq.UserHostAddress != "::1") || (httpReq.UserHostAddress != "localhost"))
            )
            {
                strIP = httpReq.UserHostAddress;
            }
            //finally, if all else fails, get the IP from a web scrape of another server
            else
            {
                WebRequest request = WebRequest.Create("http://checkip.dyndns.org/");
                using (WebResponse response = request.GetResponse())
                using (StreamReader sr = new StreamReader(response.GetResponseStream()))
                {
                    strIP = sr.ReadToEnd();
                }
                //scrape ip from the html
                int i1 = strIP.IndexOf("Address: ") + 9;
                int i2 = strIP.LastIndexOf("</body>");
                strIP = strIP.Substring(i1, i2 - i1);
            }
            return strIP;
        }

        [WebMethod]
        public static string GetTempProductivity()
        {
            DataTable dt1 = new bllMaster().getTempDailyProductvity(Convert.ToInt32(HttpContext.Current.User.Identity.Name));// Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
        public static string GetProdInformation()
        {
            string serverUtcNow = DateTime.UtcNow.ToString("o", CultureInfo.InvariantCulture);
            DataTable dt1 = new bllMaster().GetAllEmployeeDetailsByIDsForProductivity(HttpContext.Current.User.Identity.Name.ToString());
            UserCode = Convert.ToString(dt1.Rows[0]["Code"]);
            UserDomain = Convert.ToInt32(dt1.Rows[0]["Domain"]);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                row.Add("_ServerUtc", serverUtcNow);
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetActualAndUptoTime(string Code)
        {
            DataTable dt1 = new bllMaster().CalculateUptoTimeForProductivity(Code);
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
        public static string GetDailyProductivity()
        {
            DataTable dt1 = new bllMaster().GetDailyProductvity(UserCode);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            if (dt1.Rows.Count > 0)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAutoProductivity(string Date, int DomainID)
        {
            DataTable dtAuto = new DataTable();
            DataSet ds = new DataSet();
            dtProd = new DataTable();

            Date = Convert.ToDateTime(Date).ToString("dd-MMM-yyyy");

            if (DomainID == 0)
                ds = new bllMaster().getTrackingProductionByUserWise(Date, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            else
                ds = new bllMaster().GetTrackingProductionByUserWise_DomainWise(Date, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), DomainID);

            dtProd = ds.Tables[0];
            dtAuto = ds.Tables[1];

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            foreach (DataRow dr in dtAuto.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dtAuto.Columns)
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
        public static string GetProcessMissingOrders()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            if (dtProd != null)
            {
                foreach (DataRow dr in dtProd.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtProd.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAutoProductivity_Domainwise(string Date, int DomainID)
        {
            DataTable dtAuto = new DataTable();
            Date = Convert.ToDateTime(Date).ToString("dd-MMM-yyyy");
            DataSet ds = new bllMaster().GetTrackingProductionByUserWise_DomainWise(Convert.ToDateTime(Date).ToString("dd-MMM-yyyy"), int.Parse(HttpContext.Current.User.Identity.Name.ToString()), DomainID);

            dtProd = ds.Tables[0];
            dtAuto = ds.Tables[1];

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            foreach (DataRow dr in dtAuto.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dtAuto.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        public string CalculateRemainingTime(string Code)
        {
            string message = "";

            DataTable dt = new bllMaster().CheckproductivityAcutalHoursIsEqualtimespent(Code);

            string Date1 = Convert.ToString(dt.Rows[0]["Date"]);
            string timeSpent = Convert.ToString(dt.Rows[0]["ActualTimeSpent"]).Replace(".", ":");
            string WorkingHours = Convert.ToString(dt.Rows[0]["WorkingHours"]).Replace(".", ":");
            string RemaingHours = Convert.ToString(Convert.ToDateTime(WorkingHours) - Convert.ToDateTime(timeSpent)).Replace(":", ".");
            RemaingHours = RemaingHours.Substring(0, 5);

            return message;
        }
    }
}
