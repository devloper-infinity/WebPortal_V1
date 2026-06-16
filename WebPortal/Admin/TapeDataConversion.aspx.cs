using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class TapeDataConversion : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string MainPath = "";
        static string DownloanName = "";
        static string FileName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            MainPath = Server.MapPath(@"~\ReportDocument");
            try
            {
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                DownloanName = name;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                string file_Name = name;
                //string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["tdconv_file"].FileName);
            }
            catch { }
        }


        [WebMethod]
        public static int ConvertData()
        {
            int returnvalue = 0;

            if (NewFileName != "")
            {
                var masterData = new Dictionary<string, Dictionary<string, string>>();

                using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
                {
                    string query = "SELECT Type, Keys, Value FROM TapeDataMasterConverterMaster";

                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        string type = reader["Type"].ToString().Trim();
                        string key = reader["Keys"].ToString().Trim();
                        string value = reader["Value"].ToString().Trim();

                        if (!masterData.ContainsKey(type))
                            masterData[type] = new Dictionary<string, string>();

                        masterData[type][key] = value;
                    }
                }

                using (var workbook = new XLWorkbook(NewFileName))
                {
                    var ws = workbook.Worksheet(1);
                    var range = ws.RangeUsed();

                    // Map Excel headers to column numbers
                    var headerRow = ws.Row(1);
                    var columnMap = new Dictionary<string, int>();

                    foreach (var cell in headerRow.CellsUsed())
                    {
                        string columnName = cell.GetString().Trim();

                        if (masterData.ContainsKey(columnName))
                        {
                            columnMap[columnName] = cell.Address.ColumnNumber;
                        }
                    }

                    // Loop rows
                    foreach (var row in range.RowsUsed().Skip(1))
                    {
                        foreach (var col in columnMap)
                        {
                            string type = col.Key;
                            int colIndex = col.Value;

                            string excelValue = row.Cell(colIndex).GetString().Trim();

                            if (masterData[type].TryGetValue(excelValue, out string newValue))
                            {
                                row.Cell(colIndex).Value = newValue;
                            }
                        }
                    }
                    if (!Directory.Exists(MainPath))
                    {
                        Directory.CreateDirectory(MainPath);
                    }

                    FileName = MainPath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
                    workbook.SaveAs(FileName);
                    returnvalue = 1;
                }


            }

            return returnvalue;
        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = false;
            Response.AppendHeader("Content-Type", "application/xlsx");
            Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            Response.TransmitFile(FileName);
            Response.End();
        }
    }
}