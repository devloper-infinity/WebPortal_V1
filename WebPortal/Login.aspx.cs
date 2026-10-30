using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;
using WebPortal.App_Code.EL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Hosting;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.Class;


namespace WebPortal
{
    public partial class Login : System.Web.UI.Page
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
            txtPassword.ID = PwdKey;
            txtUserName.ID = UserIDKey;
            ConnectToSecretFields();
        }

        private void ConnectToSecretFields()
        {

        }

        public static DataTable GetAllEmployeeDetailsByIDsForProductivity(string Ids)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployeeDetailsByCodes_Productivity_1]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Ids);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
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
               

                int poshteststatus = new bllMaster().GetPostTestStatus();
                if (poshteststatus == 0)
                {
                    Response.Redirect("~/Admin/POSHVideo.aspx");
                }


                int KYC = bllLogin.CheckExistanceofKYC();
                if (KYC == 0)
                {
                    Response.Redirect("~/Admin/EmployeeKYC.aspx");
                }

                //int HRQU = bllLogin.CheckHRQuesionnaire();
                //if (HRQU == 0)
                //{
                //    Response.Redirect("~/Admin/HRQuestionPaper.aspx");
                //}

               
                string UptoTime = "";
                string empID = Convert.ToString(HttpContext.Current.User.Identity.Name.ToString());
                DataTable dtLogin = GetAllEmployeeDetailsByIDsForProductivity(Convert.ToString(HttpContext.Current.User.Identity.Name.ToString()));
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

               // DataTable dt = GetAllEmployeeDetailsByIDsForProductivity(empID);
                DataTable dt = new bllMaster().GetExistingLogin(User_Code, DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy"));
                if (dt != null)
                {
                    try
                    {
                        if (dt.Rows.Count > 0)
                        {
                            if (Convert.ToInt32(uptoHours) > 16)
                                Response.Redirect("~/Admin/DailyLogin.aspx");
                        }
                    }
                    catch { Response.Redirect("~/Admin/DailyLogin.aspx"); }
                }
                if (CurrentLogin == "")
                {
                    Response.Redirect("~/Admin/DailyLogin.aspx");
                }
                //if (string.IsNullOrEmpty(returnUrl))
                //{

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
                //}
                //Response.Redirect(returnUrl);
            }

            if (!IsPostBack)
            {
                if (Request.Cookies["userid"] != null)

                    txtUserName.Text = Request.Cookies["userid"].Value;

                if (Request.Cookies["pwd"] != null)

                    txtPassword.Attributes.Add("value", Request.Cookies["pwd"].Value);
                if (Request.Cookies["userid"] != null && Request.Cookies["pwd"] != null)
                    chkRemember.Checked = true;

                MakeFieldNamesSecret();

                StringBuilder scriptLoader = new StringBuilder();
                scriptLoader.Append("<script type='text/javascript'>");
                scriptLoader.Append("var txtBox=document.getElementById('");
                scriptLoader.Append(UserIDKey + "');");
                scriptLoader.Append("if (txtBox!=null ) txtBox.focus();");
                scriptLoader.Append("</script>");
                this.ClientScript.RegisterStartupScript(this.GetType(), "onLoadCall", scriptLoader.ToString());
            }
            else
            {
                ConnectToSecretFields();
            }

            txtUserName.Focus();

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
            // MFA is completed through the session-enabled page methods below.
            // Never allow the legacy postback handler to issue an authentication ticket.
            if (Request.HttpMethod.Equals("POST", StringComparison.OrdinalIgnoreCase))
            {
                dvError.Style.Add("display", "block");
                dvError.Attributes["class"] = "alert alert-danger alert-dismissible";
                dvError.InnerText = "Secure sign-in requires JavaScript. Please enable it and try again.";
                return;
            }

            try
            {
                string userID = Request.Form[UserIDKey];
                string pwd = Request.Form[PwdKey];

                string url = Request.Url.ToString();
                bool IsTrue1 = false;// url.Contains("49.248.16.147");
                if (url.Contains("49.248.16.147") || url.Contains("103.139.68.132"))
                    IsTrue1 = true;

                string IPAddr = GetLocalIPaddress_Actual();


                //if (IsTrue1 == true) // && (IPAddr == "182.74.132.122" || IPAddr == "49.248.16.146" || IPAddr == "49.248.147.146" || IPAddr == "182.72.214.98" || IPAddr == "98.190.253.156" || IPAddr == "14.140.120.14" || IPAddr == "123.252.194.170" || IPAddr == "113.193.189.58" || IPAddr == "119.82.126.34" || IPAddr == "49.248.75.46" || IPAddr == "223.30.150.178" || IPAddr == "223.30.150.174" || IPAddr == "49.204.92.82" || IPAddr == "182.74.150.238" || IPAddr == "49.248.141.178" || IPAddr == "75.134.236.177" || IPAddr == "172.126.164.81" || IPAddr == "122.169.52.100" || IPAddr == "61.8.141.107" || IPAddr == "171.50.215.61"))
                //{
                //    //allow;
                //    //if (IPAddr == "182.74.132.122" || IPAddr == "49.248.16.146" || IPAddr == "49.248.147.146" || IPAddr == "182.72.214.98" || IPAddr == "98.190.253.156" || IPAddr == "14.140.120.14" || IPAddr == "123.252.194.170" || IPAddr == "113.193.189.58" || IPAddr == "119.82.126.34" || IPAddr == "49.248.75.46" || IPAddr == "223.30.150.178" || IPAddr == "223.30.150.174" || IPAddr == "49.204.92.82" || IPAddr == "182.74.150.238" || IPAddr == "49.248.141.178" || IPAddr == "75.134.236.177" || IPAddr == "172.126.164.81" || IPAddr == "122.169.52.100" || IPAddr == "61.8.141.107" || IPAddr == "171.50.215.61" || IPAddr == "103.112.4.106")
                //    //{
                //    //}

                //    DataTable dtIP = bllLogin.GetEligibleIps();
                //    for (int i = 0; i < dtIP.Rows.Count; i++)
                //    {
                //        IPAddr = Convert.ToString(dtIP.Rows[i]["IP"]);
                //    }
                //}

                //else if (IsTrue1 == true && IPAddr.Contains("192.168"))
                //{
                //    //Block
                //    bllLogin.InsertErpLogHistory(userID, "Login", GetLocalIPaddress(), "Unauthorised User");
                //    Response.Redirect("Access.aspx");
                //}

                //else if (IsTrue1 == false && IPAddr.Contains("192.168"))
                //{
                //    //Allow login from local server
                //}

                //else
                //{
                //    if (IPAddr != "::1")
                //    {
                //        //Block
                //        bllLogin.InsertErpLogHistory(userID, "Login", GetLocalIPaddress(), "Unauthorised User");
                //        Response.Redirect("Access.aspx");
                //    }
                //}

                Session["UserName"] = Request.Form[UserIDKey];

                if (chkRemember.Checked == true)
                {
                    Response.Cookies["userid"].Value = userID;
                    Response.Cookies["pwd"].Value = pwd;
                    Response.Cookies["userid"].Expires = DateTime.Now.AddMinutes(30);
                    Response.Cookies["pwd"].Expires = DateTime.Now.AddMinutes(30);
                }

                else
                {
                    Response.Cookies["userid"].Expires = DateTime.Now.AddMinutes(-1);

                    Response.Cookies["pwd"].Expires = DateTime.Now.AddMinutes(-1);
                }

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
                    dvError.Style.Add("display", "block");
                    dvError.Attributes.Add("class", "alert alert-danger alert-dismissible");
                    dvError.InnerHtml = "Sorry, <b>Username</b> is not recognized!";
                }
                else if (ReturnValue == 0)
                {
                    dvError.Style.Add("display", "block");
                    dvError.Attributes.Add("class", "alert alert-danger alert-dismissible");
                    dvError.InnerText = "The password you entered is incorrect.";
                }

                else if (dt.Rows.Count > 0)
                {
                    dvError.Style.Add("display", "block");
                    dvError.Attributes.Add("class", "alert alert-warning alert-dismissible");
                    dvError.InnerText = "<b>Your login has been blocked. <br/>Please contact your reporting manager.</b>";
                }
                else if (pseudoname == 0)
                {
                    dvError.Style.Add("display", "block");
                    dvError.Attributes.Add("class", "alert alert-warning alert-dismissible");
                    dvError.InnerText = "<b>Your pseudoname is not configured in ERP. <br/>Please contact your reporting manager.</b>";
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
                                                            chkRemember.Checked, //Remember Me
                                                            Convert.ToString(usr.Rows[0]["Role"]), //ROLE
                                                            FormsAuthentication.FormsCookiePath);
                    string hash = FormsAuthentication.Encrypt(Authticket);
                    HttpCookie Authcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);
                    if (Authticket.IsPersistent) Authcookie.Expires = Authticket.Expiration;
                    Response.Cookies.Add(Authcookie);

                    //Password = Request.Form[PwdKey].ToUpper();


                    if (returnUrl == null)
                    {
                        Response.Redirect("~/Login.aspx", true);
                    }
                    else
                    {
                        Response.Redirect("~/Login.aspx", true);
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

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object ValidateMfaLogin(string username, string password, bool rememberMe)
        {
            return MfaLoginService.ValidateCredentials(username, password, rememberMe);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object SelectMfaMethod(string method)
        {
            return MfaLoginService.SelectMethod(method);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object VerifyMfa(string code)
        {
            return MfaLoginService.Verify(code);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object ResendMfaEmail()
        {
            return MfaLoginService.ResendEmail();
        }
    }

    public static class MfaLoginService
    {
        public static object ValidateCredentials(string username, string password, bool rememberMe)
        {
            try
            {
                string user = (username ?? "").Trim().ToUpperInvariant();
                string pwd = password ?? "";
                if (user.Length == 0 || pwd.Length == 0) return Error("Please enter username and password.");

                bllLogin login = new bllLogin();
                bllMaster master = new bllMaster();
                string encrypted = login.Encrypt(pwd);
                int result = login.ValidateUser(Filter.SQLInjectionFilter(user), Filter.SQLInjectionFilter(encrypted));
                if (result == 0) result = login.ValidateUser(Filter.SQLInjectionFilter(user), Filter.SQLInjectionFilter(pwd));
                if (result == -1) return Error("The username entered is not recognized.");
                if (result == 0) return Error("Incorrect password. Please try again.");
                if (master.BlockUserLogin(user).Rows.Count > 0) return Error("Your login has been blocked. Please contact your reporting manager.");
                if (new Login().GetEmployeePseudoname(user) == 0) return Error("Your pseudonym is not configured. Please contact your reporting manager.");
                if (pwd.ToUpperInvariant().Contains("INFINITY")) return new { status = "redirect", url = "ResetPassword.aspx?UserId=" + user };

                DataTable account = login.GetUserById(result, user, encrypted);
                if (account.Rows.Count == 0) account = login.GetUserById(result, user, pwd);
                if (account.Rows.Count == 0) return Error("Unable to load your account details.");

                long employeeId = Convert.ToInt64(account.Rows[0]["EmployeeId"]);
                HttpContext.Current.Session["MfaEmployeeId"] = employeeId;
                HttpContext.Current.Session["MfaUserName"] = user;
                HttpContext.Current.Session["MfaRole"] = Convert.ToString(account.Rows[0]["Role"]);
                HttpContext.Current.Session["MfaRememberMe"] = rememberMe;
                HttpContext.Current.Session["MfaPendingUntil"] = DateTime.UtcNow.AddMinutes(10);
                HttpContext.Current.Session["MfaAttempts"] = 0;

                bool mfaEnabled;
                if (!bool.TryParse(ConfigurationManager.AppSettings["MfaEnabled"], out mfaEnabled) || !mfaEnabled)
                    return CompleteLogin();

                EnsureTable();

                DataRow setting = GetSetting(employeeId);
                if (setting == null) return new { status = "mfa_selection" };
                string method = Convert.ToString(setting["MfaMethod"]);
                HttpContext.Current.Session["MfaMethod"] = method;
                if (method == "Email") return SendEmailOtp(user);
                return new { status = "authenticator_verify" };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("MFA credential validation failed: {0}", ex);
                return Error("Server error. Please try again.");
            }
        }

        public static object SelectMethod(string method)
        {
            if (!HasPendingLogin()) return Expired();
            if (method == "Email") { Session("MfaMethod", "Email"); return SendEmailOtp(Convert.ToString(Session("MfaUserName"))); }
            if (method != "Authenticator") return Error("Please select a valid MFA method.");
            string secret = GenerateBase32Secret();
            Session("MfaMethod", "Authenticator"); Session("MfaSetupSecret", secret);
            string user = Convert.ToString(Session("MfaUserName"));
            string uri = "otpauth://totp/Infinity%20ERP:" + HttpUtility.UrlEncode(user) + "?secret=" + secret + "&issuer=Infinity%20ERP&digits=6&period=30";
            return new { status = "authenticator_setup", secret = secret, uri = uri };
        }

        public static object Verify(string code)
        {
            if (!HasPendingLogin()) return Expired();
            code = (code ?? "").Trim();
            if (!System.Text.RegularExpressions.Regex.IsMatch(code, "^[0-9]{6}$")) return Error("Enter a valid 6-digit code.");
            int attempts = Convert.ToInt32(Session("MfaAttempts") ?? 0) + 1; Session("MfaAttempts", attempts);
            if (attempts > 5) { ClearPending(); return Error("Too many attempts. Please sign in again."); }

            long employeeId = Convert.ToInt64(Session("MfaEmployeeId"));
            string method = Convert.ToString(Session("MfaMethod"));
            bool valid = false;
            if (method == "Email")
            {
                DateTime expiry; DateTime.TryParse(Convert.ToString(Session("MfaOtpExpires")), out expiry);
                valid = DateTime.UtcNow <= expiry && FixedEquals(code, Convert.ToString(Session("MfaEmailOtp")));
            }
            else if (method == "Authenticator")
            {
                string secret = Convert.ToString(Session("MfaSetupSecret"));
                bool setup = secret.Length > 0;
                if (!setup) { DataRow row = GetSetting(employeeId); secret = row == null ? "" : Unprotect(Convert.ToString(row["AuthenticatorSecret"])); }
                valid = VerifyTotp(secret, code);
                if (valid && setup) SaveSetting(employeeId, "Authenticator", secret);
            }
            if (!valid) return Error("Invalid or expired verification code.");
            if (method == "Email") SaveSetting(employeeId, "Email", null);
            return CompleteLogin();
        }

        public static object ResendEmail()
        {
            if (!HasPendingLogin() || Convert.ToString(Session("MfaMethod")) != "Email") return Expired();
            DateTime sent; DateTime.TryParse(Convert.ToString(Session("MfaOtpLastSent")), out sent);
            if (sent != DateTime.MinValue && DateTime.UtcNow < sent.AddSeconds(30)) return Error("Please wait before requesting another OTP.");
            return SendEmailOtp(Convert.ToString(Session("MfaUserName")));
        }

        private static object CompleteLogin()
        {
            long id = Convert.ToInt64(Session("MfaEmployeeId")); string user = Convert.ToString(Session("MfaUserName"));
            string role = Convert.ToString(Session("MfaRole")); bool remember = Convert.ToBoolean(Session("MfaRememberMe"));
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, id.ToString(), DateTime.Now, DateTime.Now.AddMinutes(30), remember, role, FormsAuthentication.FormsCookiePath);
            HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(ticket));
            cookie.HttpOnly = true; cookie.Secure = HttpContext.Current.Request.IsSecureConnection; cookie.SameSite = SameSiteMode.Lax;
            if (remember) cookie.Expires = ticket.Expiration; HttpContext.Current.Response.Cookies.Add(cookie);
            new bllLogin().InsertErpLogHistory(user, "Login", new Login().GetLocalIPaddress(), "User"); ClearPending();
            return new { status = "success", url = "Admin/DashboardEmployee.aspx" };
        }

        private static object SendEmailOtp(string user)
        {
            string email;
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT OfficialEmailID FROM EmployeeInfo WHERE Code=@Code", con))
            { cmd.Parameters.Add("@Code", SqlDbType.VarChar, 50).Value = user; con.Open(); email = Convert.ToString(cmd.ExecuteScalar()).Trim(); }
            if (email.Length == 0) return Error("Your official email address is not updated in the system. Please verify it with the HR department.");
            string otp = GenerateOtp(); Session("MfaEmailOtp", otp); Session("MfaOtpExpires", DateTime.UtcNow.AddMinutes(5)); Session("MfaOtpLastSent", DateTime.UtcNow); Session("MfaAttempts", 0);
            string password = new bllMaster().GetPassword("ackdata");
            HostingEnvironment.QueueBackgroundWorkItem(async token =>
            {
                try
                {
                    using (MailMessage mail = new MailMessage()) using (SmtpClient client = new SmtpClient("smtp.office365.com", 587))
                    {
                        mail.From = new MailAddress("ack@infinity-data.com", "Infinity ERP Security", Encoding.UTF8); mail.To.Add(email);
                        mail.Subject = "Infinity ERP login verification code"; mail.IsBodyHtml = true;
                        mail.Body = SelfLeavesEmailTemplate.Apply("<p>Your login verification code is:</p><p style='font-size:30px;font-weight:bold;letter-spacing:7px'>" + HttpUtility.HtmlEncode(otp) + "</p><p>This code expires in 5 minutes. Do not share it.</p>", "Login verification", true);
                        client.Credentials = new NetworkCredential("ack@infinity-data.com", password); client.EnableSsl = true; await client.SendMailAsync(mail);
                    }
                }
                catch (Exception ex) { System.Diagnostics.Trace.TraceError("MFA OTP email failed: {0}", ex); }
            });
            return new { status = "email_verify", email = MaskEmail(email) };
        }

        private static void EnsureTable()
        {
            const string sql = @"IF OBJECT_ID('dbo.EmployeeMfaSetting','U') IS NULL BEGIN CREATE TABLE dbo.EmployeeMfaSetting(EmployeeID bigint NOT NULL PRIMARY KEY,MfaMethod varchar(20) NOT NULL,AuthenticatorSecret varchar(500) NULL,IsEnabled bit NOT NULL CONSTRAINT DF_EmployeeMfaSetting_IsEnabled DEFAULT(1),CreatedOn datetime2 NOT NULL CONSTRAINT DF_EmployeeMfaSetting_CreatedOn DEFAULT(SYSUTCDATETIME()),UpdatedOn datetime2 NOT NULL CONSTRAINT DF_EmployeeMfaSetting_UpdatedOn DEFAULT(SYSUTCDATETIME()),CONSTRAINT FK_EmployeeMfaSetting_EmployeeInfo FOREIGN KEY(EmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID),CONSTRAINT CK_EmployeeMfaSetting_Method CHECK(MfaMethod IN('Authenticator','Email'))); END";
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString)) using (SqlCommand cmd = new SqlCommand(sql, con)) { con.Open(); cmd.ExecuteNonQuery(); }
        }

        private static DataRow GetSetting(long id)
        {
            DataTable table = new DataTable(); using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString)) using (SqlCommand cmd = new SqlCommand("SELECT MfaMethod,AuthenticatorSecret FROM dbo.EmployeeMfaSetting WHERE EmployeeID=@ID AND IsEnabled=1", con)) using (SqlDataAdapter adapter = new SqlDataAdapter(cmd)) { cmd.Parameters.Add("@ID", SqlDbType.BigInt).Value = id; adapter.Fill(table); }
            return table.Rows.Count == 0 ? null : table.Rows[0];
        }

        private static void SaveSetting(long id, string method, string secret)
        {
            const string sql = @"MERGE dbo.EmployeeMfaSetting AS T USING(SELECT @ID EmployeeID) AS S ON T.EmployeeID=S.EmployeeID WHEN MATCHED THEN UPDATE SET MfaMethod=@Method,AuthenticatorSecret=@Secret,IsEnabled=1,UpdatedOn=SYSUTCDATETIME() WHEN NOT MATCHED THEN INSERT(EmployeeID,MfaMethod,AuthenticatorSecret) VALUES(@ID,@Method,@Secret);";
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString)) using (SqlCommand cmd = new SqlCommand(sql, con)) { cmd.Parameters.Add("@ID", SqlDbType.BigInt).Value = id; cmd.Parameters.Add("@Method", SqlDbType.VarChar, 20).Value = method; cmd.Parameters.Add("@Secret", SqlDbType.VarChar, 500).Value = secret == null ? (object)DBNull.Value : Protect(secret); con.Open(); cmd.ExecuteNonQuery(); }
        }

        private static bool HasPendingLogin() { DateTime until; return Session("MfaEmployeeId") != null && DateTime.TryParse(Convert.ToString(Session("MfaPendingUntil")), out until) && DateTime.UtcNow <= until; }
        private static object Session(string key) { return HttpContext.Current.Session[key]; }
        private static void Session(string key, object value) { HttpContext.Current.Session[key] = value; }
        private static object Error(string message) { return new { status = "error", message = message }; }
        private static object Expired() { return new { status = "expired", message = "Your sign-in session expired. Please sign in again." }; }
        private static void ClearPending() { foreach (string key in new[] { "MfaEmployeeId", "MfaUserName", "MfaRole", "MfaRememberMe", "MfaPendingUntil", "MfaAttempts", "MfaMethod", "MfaSetupSecret", "MfaEmailOtp", "MfaOtpExpires", "MfaOtpLastSent" }) HttpContext.Current.Session.Remove(key); }
        private static string GenerateOtp() { byte[] data = new byte[4]; using (RandomNumberGenerator rng = RandomNumberGenerator.Create()) rng.GetBytes(data); return (BitConverter.ToUInt32(data, 0) % 1000000).ToString("D6"); }
        private static string GenerateBase32Secret() { byte[] data = new byte[20]; using (RandomNumberGenerator rng = RandomNumberGenerator.Create()) rng.GetBytes(data); return Base32Encode(data); }
        private static string Base32Encode(byte[] data) { const string a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"; StringBuilder result = new StringBuilder(); int buffer = 0, bits = 0; foreach (byte b in data) { buffer = (buffer << 8) | b; bits += 8; while (bits >= 5) { result.Append(a[(buffer >> (bits - 5)) & 31]); bits -= 5; } } if (bits > 0) result.Append(a[(buffer << (5 - bits)) & 31]); return result.ToString(); }
        private static byte[] Base32Decode(string value) { const string a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"; List<byte> result = new List<byte>(); int buffer = 0, bits = 0; foreach (char c in (value ?? "").ToUpperInvariant().Replace(" ", "").TrimEnd('=')) { int i = a.IndexOf(c); if (i < 0) continue; buffer = (buffer << 5) | i; bits += 5; if (bits >= 8) { result.Add((byte)((buffer >> (bits - 8)) & 255)); bits -= 8; } } return result.ToArray(); }
        private static bool VerifyTotp(string secret, string code) { if (secret.Length == 0) return false; long step = DateTimeOffset.UtcNow.ToUnixTimeSeconds() / 30; for (long i = -1; i <= 1; i++) if (FixedEquals(BuildTotp(secret, step + i), code)) return true; return false; }
        private static string BuildTotp(string secret, long step) { byte[] counter = BitConverter.GetBytes(IPAddress.HostToNetworkOrder(step)); byte[] hash; using (HMACSHA1 hmac = new HMACSHA1(Base32Decode(secret))) hash = hmac.ComputeHash(counter); int o = hash[hash.Length - 1] & 15; int binary = ((hash[o] & 127) << 24) | ((hash[o + 1] & 255) << 16) | ((hash[o + 2] & 255) << 8) | (hash[o + 3] & 255); return (binary % 1000000).ToString("D6"); }
        private static bool FixedEquals(string a, string b) { if (a == null || b == null || a.Length != b.Length) return false; int diff = 0; for (int i = 0; i < a.Length; i++) diff |= a[i] ^ b[i]; return diff == 0; }
        private static string MaskEmail(string email) { int at = email.IndexOf('@'); return at <= 1 ? "****" + (at >= 0 ? email.Substring(at) : "") : email.Substring(0, 1) + new string('*', Math.Min(5, at - 1)) + email.Substring(at); }
        private static string Protect(string secret) { return Convert.ToBase64String(MachineKey.Protect(Encoding.UTF8.GetBytes(secret), "InfinityERP-MFA")); }
        private static string Unprotect(string value) { byte[] clear = MachineKey.Unprotect(Convert.FromBase64String(value), "InfinityERP-MFA"); return clear == null ? "" : Encoding.UTF8.GetString(clear); }
    }
}
