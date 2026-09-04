import fs from "node:fs/promises";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";

const source = "C:/Users/ngk/OneDrive - Infinity IPS, Inc/Desktop/August-2026/757-004 Client BIlling - August'2026 - Audit.xlsx";
const workbook = await SpreadsheetFile.importXlsx(await FileBlob.load(source));
const summary = await workbook.inspect({
  kind: "workbook,sheet,table,region,formula,drawing",
  maxChars: 18000,
  tableMaxRows: 15,
  tableMaxCols: 20,
  tableMaxCellChars: 100,
  options: { maxResults: 200 },
});
console.log(summary.ndjson);

await fs.mkdir(".tmp-xlsx/renders", { recursive: true });
for (const sheet of workbook.worksheets.items) {
  const preview = await workbook.render({ sheetName: sheet.name, autoCrop: "all", scale: 1, format: "png" });
  const safeName = sheet.name.replace(/[<>:"/\\|?*]/g, "_");
  await fs.writeFile(`.tmp-xlsx/renders/${safeName}.png`, new Uint8Array(await preview.arrayBuffer()));
}
