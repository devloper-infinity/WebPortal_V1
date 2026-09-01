# Infinity Credit RCA taxonomy deployment

Run the scripts in numeric order against `InfinityERP`:

1. `001_Master_Tables.sql`
2. `002_Foreign_Keys_And_Indexes.sql`
3. `003_Excel_Master_Data.sql`
4. `004_Taxonomy_Mappings.sql`
5. `005_Stored_Procedures.sql`
6. `006_Fix_Project_Eligibility.sql` only when upgrading an already-executed initial deployment

Source reconciliation: 9 taxonomy values, 2 ET1 values, 5 ET2 parent relationships,
32 ET3 parent relationships (9 distinct names), 9 ET4 values, 9 ET5 values,
203 ET6 values, 3,789 ET7 values, 3 ET8 values, and 3 ET9 values.

The current UI deliberately does not expose Taxonomy. Every ET5 row is nevertheless
linked to its source Taxonomy so future filtering can use Taxonomy -> ET5 -> ET6 -> ET7.

`DesignRestorePoint_20260901` contains the exact pre-change page, code-behind, helper,
and JavaScript files. Restoring those four files rolls back only the UI/design layer;
database rollback should be handled through the deployment process.
