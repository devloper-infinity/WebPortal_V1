using System;
using System.Collections.Generic;
using System.Web.Services;

namespace WebPortal.TrackingSheet
{
    public partial class TrackingSheetFeedbackPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static string GetPageData(long assignmentId)
        {
            if (!TrackingSheetPage.GetCompletionFeedbackRequirement(assignmentId))
                throw new InvalidOperationException("Mandatory feedback is not configured for this assignment.");
            return TrackingSheetPage.GetFeedbackDefaults(assignmentId);
        }

        [WebMethod] public static List<FeedbackListItem> GetFeedbackCategories() { return TrackingSheetPage.GetFeedbackCategories(); }
        [WebMethod] public static List<FeedbackListItem> GetFeedbackSubcategories(int categoryId) { return TrackingSheetPage.GetFeedbackSubcategories(categoryId); }
        [WebMethod] public static FeedbackSaveResult SaveFeedback(TrackingFeedbackModel model) { return TrackingSheetPage.SaveFeedback(model); }
        [WebMethod] public static TrackingActionResult CompleteLoan(long assignmentId, string remark)
        { return TrackingSheetPage.CompleteLoan(assignmentId, remark, new string[0]); }
    }
}
