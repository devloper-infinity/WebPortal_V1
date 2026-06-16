using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 12)
            {
                specialmenu.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "");
                servReport.Style.Add("display", "");
                creditutilreport.Style.Add("display", "");
                lauramacreport.Style.Add("display", "");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                attritionReport.Style.Add("display", "");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 216)
            {
                specialmenu.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "none");
                servReport.Style.Add("display", "");
                creditutilreport.Style.Add("display", "none");
                lauramacreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                attritionReport.Style.Add("display", "");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 5 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8128)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "");
                tabhelpdesk.Style.Add("display", "none");
                ccm1.Style.Add("display", "none");
                ccm2.Style.Add("display", "none");
                ccm3.Style.Add("display", "");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 209)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "");
                tabhelpdesk.Style.Add("display", "none");
                ccm1.Style.Add("display", "");
                ccm2.Style.Add("display", "");
                ccm3.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "");
                tabhrreport.Style.Add("display", "");
                tabmgtreport.Style.Add("display", "");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "");
                tabhelpdesk.Style.Add("display", "");
                liproductionsection.Style.Add("display", "");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7036 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8082 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8938)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "");
                tabhrreport.Style.Add("display", "");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");

                if ((int.Parse(HttpContext.Current.User.Identity.Name.ToString())) == 7036)
                {
                    tabmgtreport.Style.Add("display", "");
                    LiUserAck.Style.Add("display", "");
                    credReport.Style.Add("display", "none");
                    servReport.Style.Add("display", "none");
                    detailfeedbackoutput.Style.Add("display", "none");
                    creditutilreport.Style.Add("display", "none");
                    lauramacreport.Style.Add("display", "none");
                }
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7910 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 394 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9852)
            {
                specialmenu.Style.Add("display", "none");
                InvoiceVerificationpage.Style.Add("display", "");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9698 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8535 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7171)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "");
                servReport.Style.Add("display", "none");
                creditutilreport.Style.Add("display", "none");
                lauramacreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9738)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "");
                servReport.Style.Add("display", "none");
                creditutilreport.Style.Add("display", "");
                lauramacreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9803)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "");
                servReport.Style.Add("display", "none");
                creditutilreport.Style.Add("display", "");
                lauramacreport.Style.Add("display", "");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 6959)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "none");
                servReport.Style.Add("display", "none");
                detailfeedbackoutput.Style.Add("display", "none");
                lauramacreport.Style.Add("display", "");
                creditutilreport.Style.Add("display", "");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 99 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 277)
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "");
                credReport.Style.Add("display", "none");
                servReport.Style.Add("display", "");
                creditutilreport.Style.Add("display", "none");
                lauramacreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9267)
            {
                specialmenu.Style.Add("display", "");
                tabhraccess.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9864) //-----LCV
            {
                specialmenu.Style.Add("display", "");
                liSkipLevelMeeting.Style.Add("display", "");
                liNewJoineeHrFollowUp.Style.Add("display", "");
                liAbscondingEmployeeFollowup.Style.Add("display", "");
                ViewAllApplicantList.Style.Add("display", "");

                tabhraccess.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else
            {
                specialmenu.Style.Add("display", "none");
                attritionReport.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }

            int PMFlag = new bllMaster().CheckIfPM(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (PMFlag == 1)
            {
                tabpmutilities.Style.Add("display", "");
                if (Convert.ToInt32(dt.Rows[0]["Domain"]) == 9)
                {
                    pmDueDilligence.Style.Add("display", "");
                }
                else
                {
                    pmDueDilligence.Style.Add("display", "none");
                }
                if ((int.Parse(HttpContext.Current.User.Identity.Name.ToString())) == 285 || (int.Parse(HttpContext.Current.User.Identity.Name.ToString())) == 216 || (int.Parse(HttpContext.Current.User.Identity.Name.ToString())) == 12)
                {
                    attritionReport.Style.Add("display", "");
                }
                else
                {
                    attritionReport.Style.Add("display", "none");
                }
            }
            else
            {
                tabpmutilities.Style.Add("display", "none");
            }
        }

    }
}