using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EditAttendanceCorrectionRequest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string BindEditInformation(int RequestID)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAttendanceCorrectionByID(RequestID));
        }

        [WebMethod]
        public static int UpdateAttendance_PM(int RequestID, string Code, string IntimeParam, string OutTimeParam, string InDateParam, string OutDateParam, string TotalHoursParam, string Remark, string Status, string Location, string ReasonType, string UserAttnReason)
        {
            return AttendanceCorrectionWebMethods.SaveAttendanceCorrection(new AttendanceCorrectionWebMethods.AttendanceSaveRequest
            {
                Mode = AttendanceCorrectionWebMethods.AttendanceSaveMode.EditUpdate,
                RequestID = RequestID,
                Code = Code,
                IntimeParam = IntimeParam,
                OutTimeParam = OutTimeParam,
                InDateParam = InDateParam,
                OutDateParam = OutDateParam,
                TotalHoursParam = TotalHoursParam,
                Remark = Remark,
                Status = Status,
                Location = Location,
                ReasonTypeParam = ReasonType,
                UserAttnReason = UserAttnReason
            });
        }

        [WebMethod]
        public static int SendAttendanceEmail_InOut(string Code, string InDate, string InTime, string OutDate, string OutTime, string TotalHours, string Reason, string Status, string ReasonType, string UserReason)
        {
            return AttendanceCorrectionWebMethods.SendAttendanceCorrectionEmail(new AttendanceCorrectionWebMethods.AttendanceEmailRequest
            {
                Mode = AttendanceCorrectionWebMethods.AttendanceEmailMode.Decision,
                Code = Code,
                InDate = InDate,
                InTime = InTime,
                OutDate = OutDate,
                OutTime = OutTime,
                TotalHours = TotalHours,
                Reason = Reason,
                Status = Status,
                ReasonType = ReasonType,
                UserReason = UserReason
            });
        }

    }
}
