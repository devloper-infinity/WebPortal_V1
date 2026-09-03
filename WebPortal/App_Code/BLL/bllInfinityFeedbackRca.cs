using System.Data;
using System.Collections.Generic;
using System.Text;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllInfinityFeedbackRca
    {
        private readonly dalInfinityFeedbackRca dal = new dalInfinityFeedbackRca();

        public DataTable GetBootstrap(long feedbackId, string subdomain)
        {
            return dal.GetBootstrap(feedbackId, subdomain);
        }

        public DataTable GetChildren(int errorType, int parentId)
        {
            return dal.GetChildren(errorType, parentId);
        }

        public int SaveSelections(long feedbackId, string subdomain, int[] ids, int addedBy)
        {
            return dal.SaveSelections(feedbackId, subdomain, ids, addedBy);
        }

        public int ValidateSelections(long feedbackId, string subdomain, int[] ids)
        {
            return dal.ValidateSelections(feedbackId, subdomain, ids);
        }

        public int ClearSelections(long feedbackId, string subdomain)
        {
            return dal.ClearSelections(feedbackId, subdomain);
        }

        public void AppendReportColumns(DataTable feedbackTable)
        {
            if (feedbackTable == null || !feedbackTable.Columns.Contains("FeedbackID")) return;

            for (int index = 1; index <= 9; index++)
                if (!feedbackTable.Columns.Contains("ErrorType" + index + "Name"))
                    feedbackTable.Columns.Add("ErrorType" + index + "Name", typeof(string));

            HashSet<long> ids = new HashSet<long>();
            foreach (DataRow row in feedbackTable.Rows)
            {
                long id;
                if (long.TryParse(System.Convert.ToString(row["FeedbackID"]), out id)) ids.Add(id);
            }
            if (ids.Count == 0) return;

            StringBuilder csv = new StringBuilder();
            foreach (long id in ids)
            {
                if (csv.Length > 0) csv.Append(',');
                csv.Append(id);
            }

            DataTable values = dal.GetReportValues(csv.ToString());
            Dictionary<long, DataRow> lookup = new Dictionary<long, DataRow>();
            foreach (DataRow row in values.Rows) lookup[System.Convert.ToInt64(row["FeedbackID"])] = row;

            foreach (DataRow target in feedbackTable.Rows)
            {
                long id;
                DataRow source;
                if (!long.TryParse(System.Convert.ToString(target["FeedbackID"]), out id) || !lookup.TryGetValue(id, out source)) continue;
                for (int index = 1; index <= 9; index++)
                    target["ErrorType" + index + "Name"] = source["ErrorType" + index + "Name"];
            }
        }

        public DataTable GetAdminList(int errorType) { return dal.GetAdminList(errorType); }
        public DataTable GetAdminParents(int errorType) { return dal.GetAdminParents(errorType); }
        public int AddMaster(int errorType, string name, int parentId, int displayOrder, int addedBy) { return dal.AddMaster(errorType, name, parentId, displayOrder, addedBy); }
        public int SetMasterActive(int errorType, int id, bool isActive) { return dal.SetMasterActive(errorType, id, isActive); }
    }
}
