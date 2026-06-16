using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllReport
    {
        dalReport dalreport = new dalReport();
        public DataTable GetProjectInflow_Credit(string Month, string Year)
        {
            return dalreport.GetProjectInflow_Credit(Month, Year);
        }
        public DataTable GetProjectInflow_Servicing(string Month, string Year)
        {
            return dalreport.GetProjectInflow_Servicing(Month, Year);
        }
        public DataTable GetProjectQ_Credit(string Month, string Year)
        {
            return dalreport.GetProjectQ_Credit(Month, Year);
        }
        public DataTable GetProjectQ_Servicing(string Month, string Year)
        {
            return dalreport.GetProjectQ_Servicing(Month, Year);
        }
        public DataTable GetReviewerQ_Credit(string Month, string Year)
        {
            return dalreport.GetReviewerQ_Credit(Month, Year);
        }
        public DataTable GetReviewerQ_Servicing(string Month, string Year)
        {
            return dalreport.GetReviewerQ_Servicing(Month, Year);
        }

        public DataTable GetSegmentQ_Credit(string Month, string Year)
        {
            return dalreport.GetSegmentQ_Credit(Month, Year);
        }

        public DataTable GetSegmentQ_Servicing(string Month, string Year)
        {
            return dalreport.GetSegmentQ_Servicing(Month, Year);
        }

        public DataTable GetQualityQ_Credit(string Month, string Year)
        {
            return dalreport.GetQualityQ_Credit(Month, Year);
        }

        public DataTable GetQualityQ_Servicing(string Month, string Year)
        {
            return dalreport.GetQualityQ_Servicing(Month, Year);
        }

        public DataTable GetAvgSalary_Credit(string Month, string Year)
        {
            return dalreport.GetAvgSalary_Credit(Month, Year);
        }

        public DataTable GetAvgSalary_Servicing(string Month, string Year)
        {
            return dalreport.GetAvgSalary_Servicing(Month, Year);
        }
        public DataTable GetIndividualPerformance_Credit(string Month, string Year)
        {
            return dalreport.GetIndividualPerformance_Credit(Month, Year);
        }
        public DataTable GetIndividualPerformance_Servicing(string Month, string Year)
        {
            return dalreport.GetIndividualPerformance_Servicing(Month, Year);
        }
        public DataTable GetProductionReport_Credit(string Month, string Year)
        {
            return dalreport.GetProductionReport_Credit(Month, Year);
        }
        public DataTable GetProductionReport_Servicing(string Month, string Year)
        {
            return dalreport.GetProductionReport_Servicing(Month, Year);
        }
        public DataTable GetFeedbackdump_Credit(string Month, string Year)
        {
            return dalreport.GetFeedbackdump_Credit(Month, Year);
        }
        public DataTable GetFeedbackdump_Servicing(string Month, string Year)
        {
            return dalreport.GetFeedbackdump_Servicing(Month, Year);
        }

        public DataTable GetFeedbackdump_ServicingRQC(string Month, string Year)
        {
            return dalreport.GetFeedbackdump_ServicingRQC(Month, Year);
        }

        public DataTable GetFeedbackdump_ServicingRQC_RW(string Month, string Year)
        {
            return dalreport.GetFeedbackdump_ServicingRQC_RW(Month, Year);
        }
        public DataTable GetFeedbackdumpEnglish_Servicing(string Month, string Year)
        {
            return dalreport.GetFeedbackdumpEnglish_Servicing(Month, Year);
        }
        public DataTable GetWeeklyTrending_Credit(string Month, string Year)
        {
            return dalreport.GetWeeklyTrending_Credit(Month, Year);
        }
        public DataTable GetWeeklyTrending_Servicing(string Month, string Year)
        {
            return dalreport.GetWeeklyTrending_Servicing(Month, Year);
        }
        public DataTable GetMonthlyTrending_Credit(string Month, string Year)
        {
            return dalreport.GetMonthlyTrending_Credit(Month, Year);
        }
        public DataTable GetMonthlyTrending_Servicing(string Month, string Year)
        {
            return dalreport.GetMonthlyTrending_Servicing(Month, Year);
        }
        public DataTable GetErrorTrendingAll_Credit(string Month, string Year)
        {
            return dalreport.GetErrorTrendingAll_Credit(Month, Year);
        }
        public DataTable GetErrorTrendingAll_Servicing(string Month, string Year)
        {
            return dalreport.GetErrorTrendingAll_Servicing(Month, Year);
        }
        public DataTable GetErrorTrendingUser_Credit(string Month, string Year)
        {
            return dalreport.GetErrorTrendingUser_Credit(Month, Year);
        }
        public DataTable GetErrorTrendingUser_Servicing(string Month, string Year)
        {
            return dalreport.GetErrorTrendingUser_Servicing(Month, Year);
        }

        #region Detailed Feedback Output
        public DataTable WeeklyGraphicalView_QCDate()
        {
            return dalreport.WeeklyGraphicalView_QCDate();
        }
        public DataTable ClientwiseErrorTrending_QCDate()
        {
            return dalreport.ClientwiseErrorTrending_QCDate();
        }
        public DataTable ReviewerwiseErrorTrending_QCDate()
        {
            return dalreport.ReviewerwiseErrorTrending_QCDate();
        }
        public DataTable ReviewVsQCCount_QCDate()
        {
            return dalreport.ReviewVsQCCount_QCDate();
        }
        public DataSet GetNoErrorFileAnalysis_QCDate()
        {
            return dalreport.GetNoErrorFileAnalysis_QCDate();
        }
        public DataTable Reviewerwiseclientwiseerror_QCDate()
        {
            return dalreport.Reviewerwiseclientwiseerror_QCDate();
        }
        public DataTable Reviewerwiseqcwiseclientwiseerror_QCDate()
        {
            return dalreport.Reviewerwiseqcwiseclientwiseerror_QCDate();
        }
        public DataTable WeeklyQCerDetails_QCDate()
        {
            return dalreport.WeeklyQCerDetails_QCDate();
        }

        public DataTable GetSubCategory_QCDate()
        {
            return dalreport.GetSubCategory_QCDate();
        }

        public DataTable GetCategorySubCategory_QCDate()
        {
            return dalreport.GetCategorySubCategory_QCDate();
        }
        public DataSet GetFeedbacks()
        {
            return dalreport.GetFeedbacks();
        }

        public DataTable GetClientQualityReport_QCDate()
        {
            return dalreport.GetClientQualityReport_QCDate();
        }

        public DataTable ValidateQualityReportExcel()
        {
            return dalreport.ValidateQualityReportExcel();
        }

        #endregion
        public DataTable GetLoanProcessDetails(string FromDate, string ToDate)
        {
            return dalreport.GetLoanProcessDetails(FromDate, ToDate);
        }
        public DataTable GetLoanProcessSummary(string FromDate, string ToDate)
        {
            return dalreport.GetLoanProcessSummary(FromDate, ToDate);
        }
    }
}