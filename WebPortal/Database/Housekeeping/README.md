# Housekeeping module deployment

1. Run `01_CreateTables.sql`, `02_CreateIndexes.sql`, then `03_Procedures.sql` against the WebPortal `MainCon` database.
2. Add at least one active row in `HK_UserRole` per authorized numeric employee ID. `Admin` grants create/update/deactivate rights; `Management` is read-only; `Supervisor` can manage operational records. This implementation currently accepts global grants (`BuildingID` and `VendorID` NULL).
3. The application resolves the employee ID from `Session["EmployeeID"]`, then a numeric `Session["UserName"]`/authenticated name. Confirm the existing login identity is numeric or populate that session value before enabling the module.
4. Open `Admin/HousekeepingDashboard.aspx`; its module navigation links to the remaining Housekeeping pages.

The scripts are rerunnable and do not delete table data. `usp_HK_SaveModuleData` currently implements building, floor, vendor, staff, location, activity, schedule, attendance, task status, inspection, vendor evaluation, complaint, and inventory transaction saves. Master deactivation is soft-delete. Some requested workflows still need database integration before production use.
