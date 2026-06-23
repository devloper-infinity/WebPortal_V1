Helpdesk module update summary

Updated pages:
- AddTicket.aspx / AddTicket.aspx.cs
- TIcketQueue.aspx / TIcketQueue.aspx.cs
- AddTicketRemark.aspx / AddTicketRemark.aspx.cs
- TicketApproval.aspx / TicketApproval.aspx.cs

Key additions:
1. Add Ticket now captures triage and SLA-friendly metadata:
   Ticket Type, Category, Sub Category, Impact, Urgency, Priority, Source, Contact No., Asset/Application Code, Preferred Contact, Affected Users, Required By, Steps Tried / Error Message.
2. Ticket Queue now has Department Queue and My Queue tabs.
3. Department users can assign tickets to themselves through AssignTicketToSelf; assigned items are surfaced through GetMyQueue.
4. Remarks now capture Work Type, Resolution Code, Time Spent, and Root Cause / Internal Note.
5. Approval UI now captures Impact and Risk / Compliance and appends those values to the approval remark for compatibility with existing approval JS.

Backend/BLL notes:
- AddTicket.aspx.cs includes InsertTicketExpanded. It passes expanded fields in the Hashtable to InsertTicketForSoftware.
- TIcketQueue.aspx.cs includes AssignTicketToSelf and GetMyQueue. GetMyQueue filters common assigned-to column names from GetAllTicketDepartmentwise. If your DataTable uses a different assigned-user column, add it to possibleAssignedColumns.
- AddTicketRemark.aspx.cs includes UpdateTicketRemarkExpanded. It passes expanded remark fields to UpdateTicketRemark and also appends compatibility details in the description from the UI.
- TicketApproval.aspx.cs includes InsertTicketApprovalExpanded for future use. The current UI calls the existing btnApproveTicket after appending Impact/Risk into Remark, because the ticket-id source is usually maintained by the existing external approval JS.

Database/SP suggestions:
- Add nullable columns or mapping fields for TicketType, Category, SubCategory, Impact, Urgency, Priority, Source, ContactNo, AssetCode, PreferredContact, AffectedUsers, RequiredBy, StepsTried, AssignedTo, AssignedBy, AssignedDate, WorkType, ResolutionCode, TimeSpent, RootCause, Risk.
- Ensure queue queries return AssignedTo or one of the supported assigned-user column names for My Queue filtering.
