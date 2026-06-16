using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Admin
{
    public partial class CreateProfileOLD : System.Web.UI.Page
    {
        static string AppID = "";
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static string OldBankAcc = "";
        static string OldBankIFSC = "";


        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\BankAccDetails\");
            AppID = Convert.ToString(Request.QueryString["AppID"]);

            try
            {
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["accountattachment"].FileName);
            }
            catch { }
        }

        #region Get Data

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
        public static List<WebPortal.App_Code.Class.Requisition> GetAllRequisitions()
        {
            DataTable dtRec = new bllRequisition().GetAllRequisition("OpenRemark");
            List<WebPortal.App_Code.Class.Requisition> Rec = new List<WebPortal.App_Code.Class.Requisition>();
            Rec = ConvertDataTable<WebPortal.App_Code.Class.Requisition>(dtRec);
            return Rec;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.Branch> GetBranches()
        {
            DataTable dtBranch = null;
            dtBranch = new bllMaster().GetAllBranches();
            List<WebPortal.App_Code.Class.Branch> Bra = new List<WebPortal.App_Code.Class.Branch>();
            Bra = ConvertDataTable<WebPortal.App_Code.Class.Branch>(dtBranch);
            return Bra;
        }

        [WebMethod]
        public static List<Department> GetDepartment()
        {
            DataTable dtdept = new bllMaster().GetAllDepartment();

            List<Department> depart = new List<Department>();
            depart = ConvertDataTable<Department>(dtdept);
            return depart;
        }

        [WebMethod]
        public static List<Designation> GetDesignation()
        {
            DataTable dtdesg = new bllMaster().GetAllDesignation();

            List<Designation> desg = new List<Designation>();
            desg = ConvertDataTable<Designation>(dtdesg);
            return desg;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.ProjectManager> GetProjectManagers()
        {
            DataTable dtPM = new bllMaster().GetAllProjectManager();
            List<WebPortal.App_Code.Class.ProjectManager> PM = new List<WebPortal.App_Code.Class.ProjectManager>();
            PM = ConvertDataTable<WebPortal.App_Code.Class.ProjectManager>(dtPM);
            return PM;

        }

        [WebMethod]
        public static List<Shift> GetShift()
        {
            DataTable dtShift = new bllMaster().GetAllShift();

            List<Shift> shifts = new List<Shift>();
            shifts = ConvertDataTable<Shift>(dtShift);
            return shifts;
        }

        [WebMethod]
        public static List<WeeklyHoliday> GetWeeklyHolidays()
        {
            DataTable dtwh = new bllMaster().GetAllWeeklyHoliday();

            List<WeeklyHoliday> wh = new List<WeeklyHoliday>();
            wh = ConvertDataTable<WeeklyHoliday>(dtwh);
            return wh;
        }

        [WebMethod]
        public static List<Project> GetProjects()
        {
            DataTable dtProjects = new bllMaster().GetAllProject();

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
        public static List<Domain> GetAllDomains()
        {
            DataTable dtdomain = new bllMaster().GetAllDomain();
            List<Domain> domains = new List<Domain>();
            domains = ConvertDataTable<Domain>(dtdomain);
            return domains;
        }

        [WebMethod]
        public static List<Subdomain> GetSubdomains()
        {
            DataTable dtdomain = new bllMaster().GetSubdomains();
            List<Subdomain> domains = new List<Subdomain>();
            domains = ConvertDataTable<Subdomain>(dtdomain);
            return domains;
        }

        [WebMethod]
        public static List<Bank> GetBankNames()
        {
            DataTable dtBank = new bllMaster().GetAllBankMasterDetails();
            List<Bank> banks = new List<Bank>();
            banks = ConvertDataTable<Bank>(dtBank);
            return banks;
        }

        [WebMethod]
        public static string GenerateCode(string firstname, string middlename, string lastname, string EmployeeType)
        {
            return new CodeGeneration().GenerateCode_New(firstname, middlename, lastname, EmployeeType);
        }

        [WebMethod]
        public static string getCutoffTime(string Shift)
        {
            return new CodeGeneration().getCutoffTime(Shift);
        }

        [WebMethod]
        public static List<WeeklyHoliday> GetWeeklyHolidaysByShift(int Hours)
        {
            DataTable dtwh = new bllMaster().GetWeeklyHolidayByHours(Hours);
            List<WeeklyHoliday> wh = new List<WeeklyHoliday>();
            wh = ConvertDataTable<WeeklyHoliday>(dtwh);
            return wh;
        }

        [WebMethod]
        public static string GetEmployeeDetailsByCode(string Code)
        {
            DataTable dt1 = new bllMaster().GetAllEmployeeDetailsOnViewProfile(Code);

            OldBankAcc = Convert.ToString(dt1.Rows[0]["BankAccNo"]);
            OldBankIFSC = Convert.ToString(dt1.Rows[0]["IFSCCode"]);

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

        #endregion

        [WebMethod]
        public static int InsertProfile(string Code, string Title, string FirstName, string MiddleName, string LastName, string Gender, string PresentAddress, string PermanentAddress, string EmailID, string Qualification, string Contact, string ResTelNo, string DateOfBirth, string BloodGroup, int RequisitionID, string PAN,
            string JoiningDate, string Salary, int Branch, string BranchName, int Departmnets, string DepartmentName, int Designation, string DesignationName, string AppointmentDate, int Project, string ProjectName,
            string Process, int ProjectManager, string ProjectManagerName, int Shift, string ShiftName, string CutOffTime, int WorkingHours, string WorkingHoursText, string EmployeeRemark, bool isAgreement, int Period, string AgreementDate, string ExpiryDate,
            string OfficialEmailID, string BankName, string BankAccNo, string IFSCCode, string aadharNo, string UAN, string ESICNo, string PFNo, int WeeklyHoliday, string WeeklyHolidayName, string EmployeeType,
            int Domain, string Subdomain, string TaskProductive, string Policy, string DomainName, string JobType)
        {
            int returnvalue = 0;

            #region Parameters

            Hashtable htParam = new Hashtable();
            htParam.Add("AppID", AppID);
            htParam.Add("Code", Code);
            htParam.Add("Title", Title);
            htParam.Add("FirstName", FirstName);
            htParam.Add("MiddleName", MiddleName);
            htParam.Add("lastName", LastName);
            htParam.Add("Name", FirstName.ToUpper().ToString() + ' ' + MiddleName.ToUpper().ToString() + ' ' + LastName.ToUpper().ToString());
            htParam.Add("Gender", Gender);
            htParam.Add("GenderOld", Gender == "Male" ? "M" : "F");
            htParam.Add("PresentAddress", PresentAddress);
            htParam.Add("PermanentAddress", PermanentAddress);
            htParam.Add("EmailID", EmailID);
            htParam.Add("Qualification", Qualification);
            htParam.Add("CellNo", Contact);
            htParam.Add("ResTelNo", ResTelNo);
            htParam.Add("DateOfBirth", Convert.ToDateTime(DateOfBirth).ToString("dd-MMM-yyyy"));
            htParam.Add("BloodGroup", BloodGroup);
            htParam.Add("RequisitionID", RequisitionID);
            htParam.Add("PAN", PAN);
            htParam.Add("JoiningDate", Convert.ToDateTime(JoiningDate).ToString("dd-MMM-yyyy"));
            htParam.Add("Salary", int.Parse(Salary));
            htParam.Add("Company", 1);
            htParam.Add("WorkingBranch", Branch);
            htParam.Add("WorkingBranchName", BranchName);
            htParam.Add("Designation", Designation);
            htParam.Add("DesignationName", DesignationName);
            htParam.Add("Department", Departmnets);
            htParam.Add("DepartmentName", DepartmentName);
            htParam.Add("AppointmentDate", AppointmentDate);
            htParam.Add("Project", Project);
            htParam.Add("ProjectName", ProjectName);
            htParam.Add("ProcessName", Process);
            htParam.Add("ProjectManager", ProjectManager);
            htParam.Add("ProjectManagerName", ProjectManagerName);
            htParam.Add("PMCode", ProjectManagerName.Substring(0, 3));
            htParam.Add("Shift", Shift);
            htParam.Add("ShiftOld", ShiftName);
            htParam.Add("CutOffTime", CutOffTime);
            htParam.Add("WorkingHours", WorkingHours);
            htParam.Add("WorkingHoursOld", WorkingHoursText + ":00");
            htParam.Add("EmployeeRemark", EmployeeRemark);
            htParam.Add("IsAgreement", isAgreement);
            htParam.Add("Period", Period);
            htParam.Add("DateOfAgreement", AgreementDate);
            htParam.Add("AgreementExpiraryDate", ExpiryDate);
            htParam.Add("OfficialEmailID", OfficialEmailID);
            htParam.Add("BankName", BankName);
            htParam.Add("BankIFSC", IFSCCode);
            htParam.Add("BankAccNo", BankAccNo);
            htParam.Add("AadharNo", aadharNo);
            htParam.Add("UAN", UAN);
            htParam.Add("ESICNo", ESICNo);
            htParam.Add("PFNo", PFNo);
            htParam.Add("WeeklyHoliday", WeeklyHoliday);
            htParam.Add("WeeklyHolidayName", WeeklyHolidayName);
            htParam.Add("EmployeeType", EmployeeType);
            htParam.Add("Domain", Domain);
            htParam.Add("DomainName", DomainName);
            htParam.Add("SubDomain", Subdomain);
            htParam.Add("DailyTaskProductivity", TaskProductive);
            htParam.Add("UWExp", "");
            htParam.Add("IncMonth", "");
            htParam.Add("IncYear", 0);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (AppID != "" && AppID != null)
                htParam.Add("SalaryJustification", Convert.ToString(new bllMaster().GetFinalRemarkForSalary(Convert.ToInt32(AppID))));
            else
                htParam.Add("SalaryJustification", "");

            htParam.Add("IsVerificationRequired", false);
            htParam.Add("Status", "");
            htParam.Add("IsPolicy", Policy == "" ? false : true);
            htParam.Add("JobType", JobType);

            #endregion

            #region Attachment

            if (NewFileName != "")
            {
                string CodeDate = Code + "_" + DateTime.Now.ToString("ddMMyyyyHHMMSS");
                FolderPath = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + CodeDate;
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                File.Copy(NewFileName, FolderPath + "\\" + GUIDFile);
                htParam.Add("Attachment", FolderPath + "\\" + GUIDFile);
            }
            else
            {
                htParam.Add("Attachment", "");
            }

            if (BankName != "" && IFSCCode != "")
            {
                new bllMaster().InsertBankAccountNo(htParam);
            }

            returnvalue = new bllMaster().InsertEmployeeInfo(htParam);

            if (AppID != "" && AppID != null && returnvalue > 0)
            {
                new bllRequisition().UpdateApplicantFlag(Convert.ToInt32(AppID));

                new bllMaster().InsertEmployeeInfo_Old(htParam);

                if (Convert.ToString(htParam["WorkingBranchName"]) == "Solapur" || Convert.ToString(htParam["WorkingBranchName"]) == "SolapurInf")
                    ProfileCreationMail(htParam, "Create Profile Solapur", Convert.ToString(htParam["Code"]));
                else
                    ProfileCreationMail(htParam, "Create Profile", Convert.ToString(htParam["Code"]));
                ProfileCreationMail_ToCM(htParam, Convert.ToString(htParam["Code"]));
            }

            return returnvalue;

            #endregion
        }

        [WebMethod]
        public static int UpdateEmployeeInfo(string Code, string Title, string FirstName, string MiddleName, string LastName, string Gender, string PresentAddress, string PermanentAddress, string EmailID, string Qualification, string Contact, string ResTelNo, string DateOfBirth, string BloodGroup, int RequisitionID, string PAN,
            string JoiningDate, string Salary, int Branch, string BranchName, int Departmnets, string DepartmentName, int Designation, string DesignationName, string AppointmentDate, int Project, string ProjectName,
            string Process, int ProjectManager, string ProjectManagerName, int Shift, string ShiftName, string CutOffTime, int WorkingHours, string WorkingHoursText, string EmployeeRemark, bool isAgreement, int Period, string AgreementDate, string ExpiryDate,
            string OfficialEmailID, string BankName, string BankAccNo, string IFSCCode, string aadharNo, string UAN, string ESICNo, string PFNo, int WeeklyHoliday, string WeeklyHolidayName, string EmployeeType,
            int Domain, string Subdomain, string TaskProductive, string Policy, string DomainName, string ReBankAccNo, string ReIFSCCode, string JobType)
        {
            int ReturnValue = 0;

            #region Parameters

            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Title", Title);
            htParam.Add("FirstName", FirstName);
            htParam.Add("MiddleName", MiddleName);
            htParam.Add("lastName", LastName);
            htParam.Add("Name", FirstName.ToUpper().ToString() + ' ' + MiddleName.ToUpper().ToString() + ' ' + LastName.ToUpper().ToString());
            htParam.Add("Gender", Gender);
            htParam.Add("GenderOld", Gender == "Male" ? "M" : "F");
            htParam.Add("PresentAddress", PresentAddress);
            htParam.Add("PermanentAddress", PermanentAddress);
            htParam.Add("EmailID", EmailID);
            htParam.Add("Qualification", Qualification);
            htParam.Add("CellNo", Contact);
            htParam.Add("ResTelNo", ResTelNo);
            htParam.Add("DateOfBirth", Convert.ToDateTime(DateOfBirth).ToString("dd-MMM-yyyy"));
            htParam.Add("BloodGroup", BloodGroup);
            htParam.Add("PAN", PAN);
            htParam.Add("JoiningDate", Convert.ToDateTime(JoiningDate).ToString("dd-MMM-yyyy"));
            htParam.Add("Salary", int.Parse(Salary));
            htParam.Add("Company", 1);
            htParam.Add("CompanyName", "Infinity Data Technologies Pvt. Ltd.");
            htParam.Add("RequisitionID", RequisitionID);
            htParam.Add("WorkingBranch", Branch);
            htParam.Add("WorkingBranchName", BranchName);
            htParam.Add("Designation", Designation);
            htParam.Add("DesignationName", DesignationName);
            htParam.Add("Department", Departmnets);
            htParam.Add("DepartmentName", DepartmentName);
            htParam.Add("AppointmentDate", AppointmentDate);
            if (Project > 0)
            {
                htParam.Add("Project", Project);
                htParam.Add("ProjectName", ProjectName);
            }
            else
            {
                htParam.Add("Project", 0);
                htParam.Add("ProjectName", "N/A");
            }

            htParam.Add("ProcessName", Process);
            htParam.Add("ProjectManager", ProjectManager);
            htParam.Add("ProjectManagerName", ProjectManagerName);
            htParam.Add("PMCode", ProjectManagerName.Substring(0, 3));
            htParam.Add("Shift", Shift);

            try
            {
                htParam["ShiftOld"] = ShiftName.Substring(0, 3);
            }
            catch
            {
                htParam["ShiftOld"] = ShiftName;
            }

            htParam.Add("CutOffTime", CutOffTime);
            htParam.Add("WorkingHours", WorkingHours);
            htParam.Add("WorkingHoursOld", WorkingHoursText + ":00");
            htParam.Add("EmployeeRemark", EmployeeRemark);
            htParam.Add("IsAgreement", isAgreement);
            htParam.Add("Period", Period);
            htParam.Add("DateOfAgreement", AgreementDate);
            htParam.Add("AgreementExpiraryDate", ExpiryDate);
            htParam.Add("OfficialEmailID", OfficialEmailID);
            htParam.Add("BankName", BankName);
            htParam.Add("BankIFSC", IFSCCode);
            htParam.Add("BankAccNo", BankAccNo);
            htParam.Add("AadharNo", aadharNo);
            htParam.Add("UAN", UAN);
            htParam.Add("ESICNo", ESICNo);
            htParam.Add("PFNo", PFNo);
            htParam.Add("WeeklyHoliday", WeeklyHoliday);
            htParam.Add("WeeklyHolidayName", WeeklyHolidayName);
            htParam.Add("EmployeeType", EmployeeType);
            htParam.Add("Domain", Domain);
            htParam.Add("DomainName", DomainName);
            htParam.Add("SubDomain", Subdomain);
            htParam.Add("DailyTaskProductivity", TaskProductive);
            htParam.Add("UWExp", "");
            htParam.Add("IncMonth", "");
            htParam.Add("IncYear", 0);
            htParam.Add("IsPolicy", Policy == "Yes" ? true : false);
            htParam.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("JobType", JobType);

            #endregion

            ReturnValue = new bllMaster().UpdateEmployeeInfo(htParam);

            if (ReturnValue > 0)
            {
                ReturnValue = new bllMaster().InsertEmployeeInfo_Old(htParam);
            }

            if (BankAccNo == ReBankAccNo && IFSCCode == ReIFSCCode)
            {
                if (NewFileName != "")
                {
                    string CodeDate = Code + "_" + DateTime.Now.ToString("ddMMyyyyHHMMSS");
                    FolderPath = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + CodeDate;
                    if (!Directory.Exists(FolderPath))
                    {
                        Directory.CreateDirectory(FolderPath);
                    }
                    File.Copy(NewFileName, FolderPath + "\\" + GUIDFile);
                    htParam.Add("Attachment", FolderPath + "\\" + GUIDFile);
                }
                else
                {
                    htParam.Add("Attachment", "");
                }

                if (BankName != OldBankAcc && IFSCCode != OldBankIFSC)
                {
                    ReturnValue = new bllMaster().InsertBankAccountNo(htParam);
                }
            }
            return ReturnValue;
        }

        #region Email 

        [WebMethod]
        public static int ProfileCreationMail_ToCM(Hashtable htParam, string Code)
        {
            int ReturnValue = 1;
            int EmployeeID = Convert.ToInt32(new bllMaster().GetEmployeeIdFromCode(Code));
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            string DomainHead = "";
            string DomainEmailID = "";
            string ToAddress = string.Empty;
            string ToBCC = string.Empty;
            string ToCC = string.Empty;


            DataTable dtdom = new bllMaster().GetDomainHeadInfo(EmployeeID);
            if (dtdom != null)
            {
                if (dtdom.Rows.Count > 0)
                {
                    DomainHead = Convert.ToString(dtdom.Rows[0]["DomainHeadName"]);
                    DomainEmailID = Convert.ToString(dtdom.Rows[0]["DomainHeadEmailID"]);
                }
            }

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                head.Append("<html><head></head><body>");
                body.Append("<table style=\"width:802px;font-family:verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                    "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                    "<tr><td style=\"text-align:left; font-size:11px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />New user " + Convert.ToString(htParam["FirstName"]) + " " + Convert.ToString(htParam["MiddleName"]) + " " + Convert.ToString(htParam["lastName"]) + "  has joined & below are the credentials.<br /><br /></b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Code:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["Code"]).ToUpper() + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["FirstName"]) + " " + Convert.ToString(htParam["MiddleName"]) + " " + Convert.ToString(htParam["lastName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Date of birth:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(htParam["DateOfBirth"]).ToString("dd-MMM-yyyy") + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["WorkingBranchName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(htParam["JoiningDate"]).ToString("dd-MMM-yyyy") + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["Salary"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["JobType"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["DomainName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Subdomain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["SubDomain"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["DepartmentName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["DesignationName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Shift:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ShiftOld"]) + "&nbsp;&nbsp;<b>Cut Off Time:</b>&nbsp;" + Convert.ToString(htParam["CutOffTime"]) + "</td></tr>");
                if (Convert.ToString(htParam["DomainName"]) != "Support")
                {
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project assigned:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ProjectName"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process assigned:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ProcessName"]) + "</td></tr>");
                }
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ProjectManagerName"]) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Employee Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["EmployeeRemark"]) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary Justification:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["SalaryJustification"]) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Created By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtInit.Rows[0]["FirstName"]) + " " + Convert.ToString(dtInit.Rows[0]["lastName"]) + " on " + DateTime.Now.ToString("dd-MMM-yyyy") + "</td></tr>" +

                "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +

                "</table>");
                footer.Append("</body></html>");

                string Pass = new bllMaster().GetPassword("ackdata");

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("ack@infinity-data.com", "Profile Notifications", System.Text.Encoding.UTF8);
                mail.To.Add("cm@infinity-data.com");
                mail.To.Add("Hetal@infinity-data.com");
                mail.To.Add("k.sagar@infinity-data.com");
                mail.Bcc.Add("n.nilkanth@infinity-data.com");

                mail.Subject = "New User " + Convert.ToString(htParam["Code"]).ToUpper() + " has joined.";
                mail.Body = head.ToString() + body.ToString() + footer.ToString();
                mail.IsBodyHtml = true;
                mail.Priority = System.Net.Mail.MailPriority.High;
                SmtpClient client = new SmtpClient();
                client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);

                client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
                client.Port = 587;
                client.EnableSsl = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;


                try
                {
                    client.Send(mail);
                    ReturnValue = 1;
                    return 1;
                }
                catch (Exception ex) { return 0; }

            }
            return ReturnValue;
        }

        [WebMethod]
        public static int ProfileCreationMail(Hashtable htParam, string EmailType, string Code)
        {
            int ReturnValue = 1;
            int EmployeeID = Convert.ToInt32(new bllMaster().GetEmployeeIdFromCode(Code));
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            string DomainHead = "";
            string DomainEmailID = "";
            string ToAddress = string.Empty;
            string ToBCC = string.Empty;
            string ToCC = string.Empty;

            //DataTable dtdom = new bllMaster().GetDomainHeadInfo(EmployeeID);
            //if (dtdom != null)
            //{
            //    if (dtdom.Rows.Count > 0)
            //    {
            //        DomainHead = Convert.ToString(dtdom.Rows[0]["DomainHeadName"]);
            //        DomainEmailID = Convert.ToString(dtdom.Rows[0]["DomainHeadEmailID"]);
            //    }
            //}

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, EmailType);
            if (dtEmail != null)
            {
                if (dtEmail.Rows.Count > 0)
                {
                    DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);
                    DomainEmailID = Convert.ToString(dtEmail.Rows[0]["DomainHeadEmail"]);

                }
            }

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                head.Append("<html><head></head><body>");
                body.Append("<table style=\"width:802px;font-family:verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                    "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                    "<tr><td style=\"text-align:left; font-size:11px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />New user " + Convert.ToString(htParam["FirstName"]) + " " + Convert.ToString(htParam["MiddleName"]) + " " + Convert.ToString(htParam["lastName"]) + "  has joined & below are the credentials.<br /><br /></b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Code:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["Code"]).ToUpper() + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["FirstName"]) + " " + Convert.ToString(htParam["MiddleName"]) + " " + Convert.ToString(htParam["lastName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Date of birth:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(htParam["DateOfBirth"]).ToString("dd-MMM-yyyy") + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["WorkingBranchName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(htParam["JoiningDate"]).ToString("dd-MMM-yyyy") + "</td></tr>" +
                    //"<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["Salary"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["JobType"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["DomainName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Subdomain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["SubDomain"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["DepartmentName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["DesignationName"]) + "</td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Shift:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ShiftOld"]) + "&nbsp;&nbsp;<b>Cut Off Time:</b>&nbsp;" + Convert.ToString(htParam["CutOffTime"]) + "</td></tr>");
                if (Convert.ToString(htParam["DomainName"]) != "Support")
                {
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project assigned:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ProjectName"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process assigned:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ProcessName"]) + "</td></tr>");
                }
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["ProjectManagerName"]) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Employee Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["EmployeeRemark"]) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary Justification:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["SalaryJustification"]) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Created By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtInit.Rows[0]["FirstName"]) + " " + Convert.ToString(dtInit.Rows[0]["lastName"]) + " on " + DateTime.Now.ToString("dd-MMM-yyyy") + "</td></tr>" +

                "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +

                "</table>");
                footer.Append("</body></html>");

                string Pass = new bllMaster().GetPassword("ackdata");

                ToAddress = Convert.ToString(dtEmail.Rows[0]["To"]);
                ToCC = Convert.ToString(dtEmail.Rows[0]["CcCreateProfile"]);
                ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("ack@infinity-data.com", "Profile Notifications", System.Text.Encoding.UTF8);
                mail.To.Add(ToAddress);
                mail.To.Add(ToCC);
                mail.Bcc.Add(ToBCC);

                mail.Subject = "New User " + Convert.ToString(htParam["Code"]).ToUpper() + " has joined.";
                mail.Body = head.ToString() + body.ToString() + footer.ToString();
                mail.IsBodyHtml = true;
                mail.Priority = System.Net.Mail.MailPriority.High;
                SmtpClient client = new SmtpClient();
                client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);

                client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
                client.Port = 587;
                client.EnableSsl = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                try
                {
                    client.Send(mail);
                    ReturnValue = 1;
                    return 1;
                }
                catch (Exception ex) { return 0; }

            }
            return ReturnValue;
        }

        [WebMethod]
        public static string GetApplicantDetails(int AppId)
        {
            DataTable dt1 = new bllRequisition().getApplicantListById(AppId);
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

        #endregion

    }
}