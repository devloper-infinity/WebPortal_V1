using System;
using System.Collections;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    internal static class EditInfinityFeedbackHelpers
    {

        [WebMethod]
        public static int UpdateInfinityImportedFeedback_NewERP(int FeedbackID, string ProdIDs, string Category, string SubCategory, string ErrorField, string Screen, string ErrorType, string Finding, string FeedbackType, string Severity, string FeedbackStatus, string RCA, string Source, string FeedbackReceivedDate, bool IsDisplayInERP, string Subdomain)
        {
            int ReturnValue = 0;

            bool requiresFeedbackStatus = string.Equals(Severity, "Critical", StringComparison.OrdinalIgnoreCase)
                || string.Equals(Severity, "Non-Critical", StringComparison.OrdinalIgnoreCase);

            if (requiresFeedbackStatus)
            {
                if (string.Equals(FeedbackStatus, "Agree", StringComparison.OrdinalIgnoreCase))
                    FeedbackStatus = "Agree";
                else if (string.Equals(FeedbackStatus, "Disagree", StringComparison.OrdinalIgnoreCase))
                    FeedbackStatus = "Disagree";
                else
                    return 0;
            }
            else
            {
                FeedbackStatus = string.Empty;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("FeedbackID", FeedbackID);
            htParam.Add("Category", Category);
            htParam.Add("Subcategory", SubCategory);
            htParam.Add("ErrorField", ErrorField);
            htParam.Add("Screen", Screen);
            htParam.Add("ErrorType", ErrorType);
            htParam.Add("Finding", Finding);
            htParam.Add("FeedbackType", FeedbackType);
            htParam.Add("Severity", Severity);
            htParam.Add("FeedbackStatus", FeedbackStatus);
            htParam.Add("RCA", RCA);
            htParam.Add("Source", Source);
            htParam.Add("FeedbackReceivedDate", FeedbackReceivedDate);
            htParam.Add("IsDisplayInERP", IsDisplayInERP);
            htParam.Add("Subdomain", Subdomain);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().UpdateInfinityImportedFeedback_NewERP(htParam);

            if (ProdIDs != "0")
            {
                string str_split = ProdIDs.Substring(2);
                string[] IDs = str_split.Split(',');

                foreach (var sub_str in IDs)
                {
                    Hashtable htProd = new Hashtable();
                    htProd.Add("FeedbackID", FeedbackID);
                    htProd.Add("ProdID", sub_str);
                    htProd.Add("Source", Source);
                    htProd.Add("Subdomain", Subdomain);
                    htProd.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    ReturnValue = new bllMaster().InsertInfinityImportedFeedback_NewERP(htProd);
                }
            }

            return ReturnValue;
        }
    }
}