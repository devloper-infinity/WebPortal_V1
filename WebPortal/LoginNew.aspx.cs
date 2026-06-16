using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;
using WebPortal.App_Code.EL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal
{
    public partial class LoginNew : System.Web.UI.Page
    {
        bllLogin bllLogin = new bllLogin();
        bllMaster bllMaster = new bllMaster();
        string Password = "";
        public string localIP;

        private string UserIDKey
        {
            get
            {
                if (ViewState["UserIDKey"] == null)
                    ViewState["UserIDKey"] = Guid.NewGuid().ToString();
                return (string)ViewState["UserIDKey"];
            }
            set
            {
                ViewState["UserIDKey"] = value;
            }
        }

        private string PwdKey
        {
            get
            {
                if (ViewState["PwdKey"] == null)
                    ViewState["PwdKey"] = Guid.NewGuid().ToString();
                return (string)ViewState["PwdKey"];
            }
            set
            {
                ViewState["PwdKey"] = value;
            }
        }

        private string returnUrl
        {
            get
            {
                if (ViewState["returnUrl"] == null)
                    ViewState["returnUrl"] = "";
                return (string)ViewState["returnUrl"];
            }
            set
            {
                ViewState["returnUrl"] = value;
            }
        }

        private void Page_PreRender(object sender, System.EventArgs e)
        {
            if (IsPostBack)
            {
                UserIDKey = null;
                PwdKey = null;
                MakeFieldNamesSecret();
            }
        }

        private void MakeFieldNamesSecret()
        {
            //txtPassword.ID = PwdKey;
            //txtUserName.ID = UserIDKey;
            ConnectToSecretFields();
        }

        private void ConnectToSecretFields()
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                returnUrl = Request.QueryString["ReturnUrl"];
            }
            catch { }

            int CompanyID = 0;
            string CurrentLogin = string.Empty;
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                int KYC = bllLogin.CheckExistanceofKYC();
                if (KYC == 0)
                {
                    Response.Redirect("~/Admin/EmployeeKYC.aspx");
                }

                int HRQU = bllLogin.CheckHRQuesionnaire();
                if (HRQU == 0)
                {
                    Response.Redirect("~/Admin/HRQuestionPaper.aspx");
                }

                int poshteststatus = new bllMaster().GetPostTestStatus();
                if (poshteststatus == 1)
                {
                    Response.Redirect("~/Admin/POSHVideo.aspx");
                }

                string UptoTime = "";
                string empID = Convert.ToString(HttpContext.Current.User.Identity.Name.ToString());
                DataTable dtLogin = bllMaster.GetAllEmployeeDetailsByIDsForProductivity(Convert.ToString(HttpContext.Current.User.Identity.Name.ToString()));
                if (dtLogin != null)
                {
                    if (dtLogin.Rows.Count > 0)
                    {
                        CurrentLogin = Convert.ToString(dtLogin.Rows[0]["CurrentLogin"]);
                        UptoTime = Convert.ToString(dtLogin.Rows[0]["UptoTime"]);
                        CompanyID = Convert.ToInt32(dtLogin.Rows[0]["Company"]);
                    }
                }
                string[] times = UptoTime.Split(':');
                string uptoHours = times[0];
                //if (uptoHours == "")
                //    uptoHours = "0";
                string User_Code = bllMaster.GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                /*Comment for Gregg Demo - 2026-03-20 06:56:27.393*/

                //DataTable dt = bllmaster.GetAllEmployeeDetailsByIDsForProductivity(empID);
                //DataTable dt = bllMaster.GetExistingLogin(User_Code, DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy"));
                //if (dt != null)
                //{
                //    try
                //    {
                //        if (dt.Rows.Count > 0)
                //        {
                //            if (Convert.ToInt32(uptoHours) > 16)
                //                Response.Redirect("~/Admin/DailyLogin.aspx");
                //        }
                //    }
                //    catch { Response.Redirect("~/Admin/DailyLogin.aspx"); }
                //}
                //if (CurrentLogin == "")
                //{
                //    Response.Redirect("~/Admin/DailyLogin.aspx");
                //}
                //if (string.IsNullOrEmpty(returnUrl))
                {

                    string restFlag = Convert.ToString(Session["resetFlg"]);

                    if (restFlag == "False" || restFlag == "false")
                    {
                        if (HttpContext.Current.User.IsInRole("Admin"))
                        {
                            if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235)
                            {
                                Session["User"] = "Admin";
                                Response.Redirect("~/Admin/DashboardEmployee.aspx");
                            }
                            else
                            {
                                if (CompanyID == 6)
                                    Response.Redirect("~/US/Dashboard.aspx");
                                else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8938 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8082 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7036 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 12)
                                {
                                    if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235)
                                        Response.Redirect("~/Admin/DashboardEmployee.aspx");
                                    else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 209)
                                        Response.Redirect("~/Accounts/Dashboard.aspx");
                                    else
                                        Response.Redirect("~/Admin/DashboardEmployee.aspx");
                                }
                                else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 209)
                                    Response.Redirect("~/Accounts/Dashboard.aspx");
                                else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7910 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 394 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9852)
                                    Response.Redirect("~/IT/InvoiceVerification.aspx");
                                else
                                    Response.Redirect("~/Admin/DashboardEmployee.aspx");
                                //Session["User"] = "Admin";
                                //Response.Redirect("~/Admin/Dashboard.aspx");
                            }
                        }
                    }
                    else
                    {
                        if (CompanyID == 6)
                            Response.Redirect("~/US/Dashboard.aspx");
                        if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7197)
                            Response.Redirect("~/Admin/CustomizedDashboard.aspx");
                        if (HttpContext.Current.User.IsInRole("Admin"))
                        {
                            int VaccineInfo = bllLogin.CheckVaccneInfoExistance();
                            int AVUpload = bllLogin.CheckAVSnapExistance();
                            if (VaccineInfo == 0)
                            {
                                Response.Redirect("~/Admin/VaccinationDisabled.aspx");
                            }
                            if (AVUpload == 0 && Convert.ToInt32(DateTime.Now.ToString("dd")) >= 15)
                                Response.Redirect("~/Admin/AVMasterDisabled.aspx?EmpID=" + HttpContext.Current.User.Identity.Name.ToString());
                            else
                            {
                                if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8938 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8082 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7036 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 12 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 5 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8128)
                                {
                                    if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235)
                                        Response.Redirect("~/Admin/DashboardEmployee.aspx");
                                    else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 209)
                                        Response.Redirect("~/Accounts/Dashboard.aspx");
                                    else
                                        Response.Redirect("~/Admin/DashboardEmployee.aspx");
                                }
                                else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 209)
                                    Response.Redirect("~/Accounts/Dashboard.aspx");
                                else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7910 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 394 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9852)
                                    Response.Redirect("~/IT/InvoiceVerification.aspx");

                                else
                                    Response.Redirect("~/Admin/DashboardEmployee.aspx");
                            }
                        }
                        if (HttpContext.Current.User.IsInRole("US Employee"))
                            Response.Redirect("~/Admin/USDashboard.aspx");
                        if (HttpContext.Current.User.IsInRole("Client"))
                            Response.Redirect("~/OST/ClientDashboard.aspx");
                        if (HttpContext.Current.User.IsInRole("Abstractor"))
                            Response.Redirect("~/OST/AbstractorDashboard.aspx");
                        if (HttpContext.Current.User.IsInRole("Vendor"))
                            Response.Redirect("~/Vendor/VendorDashboard.aspx");
                        if (HttpContext.Current.User.IsInRole("US Employee"))
                            Response.Redirect("~/OST/USDashboard.aspx");
                        else
                        {
                            FormsAuthentication.SignOut();
                            Response.Redirect("~/Logout.aspx");
                        }
                    }
                }
                //Response.Redirect(returnUrl);
            }

            if (!IsPostBack)
            {
            //    if (Request.Cookies["userid"] != null)

            //        txtUserName.Text = Request.Cookies["userid"].Value;

            //    if (Request.Cookies["pwd"] != null)

            //        txtPassword.Attributes.Add("value", Request.Cookies["pwd"].Value);
            //    if (Request.Cookies["userid"] != null && Request.Cookies["pwd"] != null)
            //        chkRemember.Checked = true;

            //    MakeFieldNamesSecret();

            //    StringBuilder scriptLoader = new StringBuilder();
            //    scriptLoader.Append("<script type='text/javascript'>");
            //    scriptLoader.Append("var txtBox=document.getElementById('");
            //    scriptLoader.Append(UserIDKey + "');");
            //    scriptLoader.Append("if (txtBox!=null ) txtBox.focus();");
            //    scriptLoader.Append("</script>");
            //    this.ClientScript.RegisterStartupScript(this.GetType(), "onLoadCall", scriptLoader.ToString());
            }
            else
            {
                ConnectToSecretFields();
            }

            //txtUserName.Focus();

        }

        public int GetEmployeePseudoname(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPsedonameforattendance");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Code);
            int ReturnValue = Convert.ToInt32(SQLHelper.ExecuteScalarCmd(cmd));
            return ReturnValue;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string userID = Request.Form[UserIDKey];
                string pwd = Request.Form[PwdKey];

                string url = Request.Url.ToString();
                bool IsTrue1 = false;// url.Contains("49.248.16.147");
                if (url.Contains("49.248.16.147") || url.Contains("103.139.68.132"))
                    IsTrue1 = true;

                string IPAddr = GetLocalIPaddress_Actual();

                Session["UserName"] = Request.Form[UserIDKey];

                //if (chkRemember.Checked == true)
                //{
                //    Response.Cookies["userid"].Value = userID;
                //    Response.Cookies["pwd"].Value = pwd;
                //    Response.Cookies["userid"].Expires = DateTime.Now.AddMinutes(30);
                //    Response.Cookies["pwd"].Expires = DateTime.Now.AddMinutes(30);
                //}

                //else
                //{
                //    Response.Cookies["userid"].Expires = DateTime.Now.AddMinutes(-1);

                //    Response.Cookies["pwd"].Expires = DateTime.Now.AddMinutes(-1);
                //}

                //********** Block User Login **********//
                DataTable dt = bllMaster.BlockUserLogin(userID);
                int pseudoname = GetEmployeePseudoname(userID);
                string encPassword = bllLogin.Encrypt(pwd);

                int ReturnValue = 0;
                //if (userID == "BCS" && userID == "JNG" && userID == "CHM" && userID == "HCM" && userID == "AGL" && userID == "NEH" && userID == "HTB")
                //{
                //    ReturnValue = bllLogin.ValidateUser(Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(encPassword));
                //}
                //else
                //{
                //    ReturnValue = bllLogin.ValidateUser(Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(pwd));
                //}
                int ReturnValue2 = bllLogin.ValidateUser(Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(encPassword));
                if (ReturnValue2 == 0)
                {
                    ReturnValue = bllLogin.ValidateUser(Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(pwd));
                }
                else
                {
                    ReturnValue = ReturnValue2;
                }
                if (ReturnValue == -1)
                {
                    ////dvError.Style.Add("display", "block");
                    ////dvError.Attributes.Add("class", "alert alert-danger alert-dismissible");
                    ////dvError.InnerHtml = "Sorry, <b>Username</b> is not recognized!";
                }
                else if (ReturnValue == 0)
                {
                    ////dvError.Style.Add("display", "block");
                    ////dvError.Attributes.Add("class", "alert alert-danger alert-dismissible");
                    ////dvError.InnerText = "The password you entered is incorrect.";
                }

                else if (dt.Rows.Count > 0)
                {
                    //dvError.Style.Add("display", "block");
                    //dvError.Attributes.Add("class", "alert alert-warning alert-dismissible");
                    //dvError.InnerText = "<b>Your login has been blocked. <br/>Please contact your reporting manager.</b>";
                }
                else if (pseudoname == 0)
                {
                    //dvError.Style.Add("display", "block");
                    //dvError.Attributes.Add("class", "alert alert-warning alert-dismissible");
                    //dvError.InnerText = "<b>Your pseudoname is not configured in ERP. <br/>Please contact your reporting manager.</b>";
                }

                else
                {
                    bllLogin.InsertErpLogHistory(userID, "Login", GetLocalIPaddress(), "User");
                    bool IsTrue = false;
                    try
                    {
                        IsTrue = pwd.ToUpper().Contains("INFINITY");
                    }
                    catch { }

                    if (IsTrue == true)
                    {

                        Response.Redirect("ResetPassword.aspx?UserId=" + userID.ToUpper());
                    }

                    FormsAuthenticationTicket Authticket = null;
                    DataTable usr = bllLogin.GetUserById(ReturnValue, Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(encPassword));
                    if (usr.Rows.Count <= 0)
                        usr = bllLogin.GetUserById(ReturnValue, Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(pwd));

                    Authticket = new FormsAuthenticationTicket(
                                                            1,
                                                            Convert.ToString(usr.Rows[0]["EmployeeId"]), //UID
                                                            DateTime.Now,
                                                            DateTime.Now.AddMinutes(30),
                                                            true, //Remember Me
                                                            Convert.ToString(usr.Rows[0]["Role"]), //ROLE
                                                            FormsAuthentication.FormsCookiePath);
                    string hash = FormsAuthentication.Encrypt(Authticket);
                    HttpCookie Authcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);
                    if (Authticket.IsPersistent) Authcookie.Expires = Authticket.Expiration;
                    Response.Cookies.Add(Authcookie);

                    //Password = Request.Form[PwdKey].ToUpper();


                    if (returnUrl == null)
                    {
                        Response.Redirect("~/LoginNew.aspx", true);
                    }
                    else
                    {
                        Response.Redirect("~/LoginNew.aspx", true);
                        //Response.Redirect("~/Login.aspx?ReturnUrl=" + returnUrl, true);
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        public string GetLocalIPaddress_Actual()
        {
            localIP = "";
            string strIP = String.Empty;
            try
            {
                string lhostname = string.Empty;
                try
                {
                    lhostname = Dns.GetHostName();
                    IPHostEntry iphost;
                    IPAddress[] ip;
                    iphost = Dns.GetHostEntry(lhostname);
                    ip = iphost.AddressList;
                    if (Convert.ToString(ip[0]).Trim().Contains("192"))
                    {
                        localIP = ip[0].ToString();
                    }
                    else
                    {
                        localIP = ip[1].ToString();
                    }


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
                catch
                {
                    return strIP;
                }
            }
            catch
            {
                return strIP;
            }
        }

        public string GetLocalIPaddress()
        {
            localIP = "";
            string strIP = String.Empty;
            try
            {
                string lhostname = string.Empty;
                try
                {
                    lhostname = Dns.GetHostName();
                    IPHostEntry iphost;
                    IPAddress[] ip;
                    iphost = Dns.GetHostEntry(lhostname);
                    ip = iphost.AddressList;
                    if (Convert.ToString(ip[0]).Trim().Contains("192"))
                    {
                        localIP = ip[0].ToString();
                    }
                    else
                    {
                        localIP = ip[1].ToString();
                    }


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

                    return localIP + "||" + strIP;
                }
                catch
                {
                    return localIP + "||" + strIP;
                }
            }
            catch
            {
                return localIP + "||" + strIP; ;
            }
        }


        [System.Web.Services.WebMethod]
        public static object ValidateUser(string username, string password, bool rememberMe)
        {
            Login obj = new Login();
            bllLogin bllLogin = new bllLogin();
            bllMaster bllMaster = new bllMaster();

            try
            {
                string userID = username;
                string pwd = password;

                // Encrypt password
                string encPassword = bllLogin.Encrypt(pwd);

                // Block User Check
                DataTable dt = bllMaster.BlockUserLogin(userID);

                int pseudoname = obj.GetEmployeePseudoname(userID);

                int ReturnValue2 = bllLogin.ValidateUser(Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(encPassword));
                int ReturnValue = (ReturnValue2 == 0)
                    ? bllLogin.ValidateUser(Filter.SQLInjectionFilter(userID), Filter.SQLInjectionFilter(pwd))
                    : ReturnValue2;

                // ❌ Username not found
                if (ReturnValue == -1)
                {
                    return new { status = "error", message = "The username entered is not recognized. Please verify and try again." };
                }

                // ❌ Wrong password
                if (ReturnValue == 0)
                {
                    return new { status = "error", message = "Incorrect password. Please try again." };
                }

                // ❌ Blocked user
                if (dt.Rows.Count > 0)
                {
                    return new { status = "error", message = "Your login has been temporarily blocked. Please contact your reporting manager for assistance." };
                }

                // ❌ Pseudoname missing
                if (pseudoname == 0)
                {
                    return new { status = "error", message = "Your pseudonym has not been configured. Kindly reach out to the HR Team." };
                }

                // ✅ SUCCESS LOGIN
                bllLogin.InsertErpLogHistory(userID, "Login", obj.GetLocalIPaddress(), "User");

                bool isReset = pwd.ToUpper().Contains("INFINITY");

                if (isReset)
                {
                    return new { status = "redirect", url = "ResetPassword.aspx?UserId=" + userID.ToUpper() };
                }

                DataTable usr = bllLogin.GetUserById(ReturnValue, userID, encPassword);
                if (usr.Rows.Count <= 0)
                    usr = bllLogin.GetUserById(ReturnValue, userID, pwd);

                // Create Auth Ticket
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                    1,
                    Convert.ToString(usr.Rows[0]["EmployeeId"]),
                    DateTime.Now,
                    DateTime.Now.AddMinutes(30),
                    rememberMe,
                    Convert.ToString(usr.Rows[0]["Role"]),
                    FormsAuthentication.FormsCookiePath
                );

                string hash = FormsAuthentication.Encrypt(ticket);
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);

                if (ticket.IsPersistent)
                    authCookie.Expires = ticket.Expiration;

                HttpContext.Current.Response.Cookies.Add(authCookie);

                // ✅ FINAL REDIRECT (KEEP YOUR EXISTING FLOW SIMPLE)
                return new { status = "success", url = "../Admin/DashboardEmployee.aspx" };
            }
            catch (Exception ex)
            {
                return new { status = "error", message = "Server error" };
            }
        }
    }
}