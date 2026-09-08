# IHMS Helpdesk deployment

1. Run `IHMS_Database.sql` against the ERP database. It creates only `IHMS_` objects.
2. Grant roles in `IHMS_UserRole`: `ITUser`, `ITHead`, `Approver`, `HelpdeskAdmin`. Every authenticated employee can use the self-service page; role checks are enforced again in SQL.
3. Give the IIS application-pool identity modify permission on `App_Data/IHMS` for attachments.
4. Configure and install the sibling `IHMS.EmailService` utility. Use an Entra application with application permissions `Mail.ReadWrite`, `Mail.Send`, and admin consent restricted to the shared mailbox using an application access policy.
5. Add the new pages to the ERP menu/right mappings. The pages continue to use the existing forms authentication identity and `EmployeeInfo` session profile.

The ticket lock is enforced in stored procedures, not only in the browser. Internal notes are filtered from requestors and never enter the outbound email queue. Ticket activity and approval/assignment histories are append-only.
