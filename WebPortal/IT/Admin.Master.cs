using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal.IT
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 12)
            {
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
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 216)
            {
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
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7910 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 394 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9852)
            {
                InvoiceVerificationpage.Style.Add("display", "");
                tabhraccess.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 5 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8218 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 209)
            {
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "");
                tabhelpdesk.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 235)
            {
                tabhraccess.Style.Add("display", "");
                tabhrreport.Style.Add("display", "");
                tabmgtreport.Style.Add("display", "");
                tabotherinks.Style.Add("display", "");
                tabcreditcard.Style.Add("display", "");
                tabhelpdesk.Style.Add("display", "");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 7036 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8082 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8938)
            {
                tabhraccess.Style.Add("display", "");
                tabhrreport.Style.Add("display", "");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9738 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 9698 || int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 8535)
            {
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
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 6959)
            {
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
            else if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 99)
            {
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
            else
            {
                tabhraccess.Style.Add("display", "none");
                tabhraccess.Style.Add("display", "none");
                tabhrreport.Style.Add("display", "none");
                tabmgtreport.Style.Add("display", "none");
                tabotherinks.Style.Add("display", "none");
                tabcreditcard.Style.Add("display", "none");
                tabhelpdesk.Style.Add("display", "none");
                tabpmutilities.Style.Add("display", "none");
            }
        }
    }
}