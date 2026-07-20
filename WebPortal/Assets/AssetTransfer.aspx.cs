using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using WebPortal.Assets.Classes;

namespace WebPortal.Assets
{
    public partial class AssetTransfer : System.Web.UI.Page
    {
        private static AssetBAL S => new AssetBAL();

        private static long U =>
            Convert.ToInt64(HttpContext.Current.User.Identity.Name.ToString());

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static object Lookup(string type, int? parentID)
        {
            return AssetBAL.Rows(S.Lookup(type, parentID));
        }

        [WebMethod]
        public static object List()
        {
            return AssetBAL.Rows(S.List("Transfer"));
        }

        [WebMethod]
        public static ApiResult Save(TransferInput x)
        {
            try
            {
                return ApiResult.Ok(
                    S.Save("usp_Assets_SaveTransfer", x, U)
                );
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }

        [WebMethod]
        public static ApiResult SaveBatch(List<long> assetIDs, TransferInput x)
        {
            try
            {
                if (assetIDs == null || assetIDs.Count == 0)
                {
                    return ApiResult.Fail("Please select at least one available asset.");
                }
                if (x == null) return ApiResult.Fail("Transfer details are required.");
                if (x.FromBranchID <= 0 || x.ToBranchID <= 0) return ApiResult.Fail("From Branch and To Branch are required.");
                if (x.FromBranchID == x.ToBranchID) return ApiResult.Fail("From Branch and To Branch must be different.");
                assetIDs = new List<long>(new HashSet<long>(assetIDs));
                var available = S.Lookup("TransferAvailableAsset", null);
                var validAssetIDs = new HashSet<long>();
                foreach (System.Data.DataRow row in available.Rows)
                    if (Convert.ToInt32(row["BranchID"]) == x.FromBranchID) validAssetIDs.Add(Convert.ToInt64(row["ID"]));
                foreach (var assetID in assetIDs)
                    if (!validAssetIDs.Contains(assetID)) return ApiResult.Fail("One or more selected assets are no longer available in the From Branch. Refresh and try again.");

                int created = 0;

                foreach (var assetID in assetIDs)
                {
                    if (assetID <= 0)
                        continue;

                    x.TransferID = 0;
                    x.AssetID = assetID;

                    S.Save("usp_Assets_SaveTransfer", x, U);
                    created++;
                }

                return created > 0
                    ? ApiResult.Ok(
                        created,
                        created + " transfer(s) created successfully."
                      )
                    : ApiResult.Fail("Please select at least one valid asset.");
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }

        [WebMethod]
        public static ApiResult Action(long id, string action, string remarks)
        {
            try
            {
                if (string.Equals(action, "Dispatched", StringComparison.OrdinalIgnoreCase))
                {
                    var status = S.TransferStatus(id, U);
                    if (!string.Equals(status, "Approved", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(status, "Approve", StringComparison.OrdinalIgnoreCase))
                        return ApiResult.Fail("Asset transfer is not approved.");
                    if (string.Equals(status, "Approve", StringComparison.OrdinalIgnoreCase))
                        S.NormalizeTransferDecision(id, "Approved", U);
                }
                S.Action("Transfer", id, action, remarks, U);
                if (string.Equals(action, "Dispatched", StringComparison.OrdinalIgnoreCase))
                    S.NormalizeTransferDispatch(id, remarks, U);
                return ApiResult.Ok(null, "Transfer dispatched successfully.");
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }
    }
}
