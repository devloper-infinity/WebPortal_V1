"""
PRP -> 561-Dashboard Clean up categorizer (all sheets).

Usage:
    python prp_to_cleanup.py <PRP.xlsx> <Cleanup_template.xlsx> [output.xlsx]
    (output optional: defaults to "<deal>-Dashboard Clean up.xlsx" next to the PRP file)

How it works
- Reads every block in the Clean up template (a block starts at an "Investor Loan ID"
  header and runs right until a blank cell or the next "Investor Loan ID").
- Each header is matched to the PRP "Dashboard" column of the same name
  (ignoring spaces, case and punctuation).
- A loan is pulled into a block when ANY flag column in that block shows an issue:
  Fail, Y, Yes or Red Flag.
- Stacked blocks (e.g. Tax Lien) are pushed down automatically if a block above grows.
- Formatting: Calibri 10, centre/middle, all borders. Header wrapped with thick outside border;
  data rows not wrapped.
- City-Municipal (Township block): only 'Township Search Pass/Fail' = Fail is used.
- Senior Lien (Junior block): loans with Junior Mortgages Count > 0;
  Remarks = Issue when Total Junior Mortgage Amount exceeds Orig Bal.
- Header colours: Investor Loan ID, Orig Bal, Remarks in green; all other headers yellow.
"""
import sys, re, os, shutil, subprocess, tempfile, warnings
import openpyxl
from openpyxl.styles import Font, Border, Side, Alignment, PatternFill

warnings.filterwarnings("ignore")

SKIP_SHEETS = {"Worksheet", "Sheet1"}
FLAG_VALUES = {"fail", "y", "yes", "redflag"}
ACCT = '_("$"* #,##0.00_);_("$"* \\(#,##0.00\\);_("$"* "-"??_);_(@_)'
MONEY_WORDS = ("amount", "amt", "bal", "owed")

# Extra formula columns (keyed by sheet and normalized header). Letters are resolved
# from header names, so the formula still works if columns move.
# Value: (formula template, number format, {placeholder: normalized header it points to})
FORMULAS = {
    ("Delinquent Taxes", "0.04"): ("={G}{r}*4%", ACCT, {"G": "origbal"}),
    ("Delinquent Taxes", "status"): ('=IF({H}{r}-{C}{r}<0,"Fail","Pass")', None,
                                     {"C": "delinquenttaxamount", "H": "0.04"}),
    ("Senior Lien", "remarks"): ('=IF({E}{r}-{C}{r}<0,"Issue","No Issue")', None,
                                 {"C": "totaljuniormortgageamount", "E": "origbal"}),
}

# Header colours: these headers green, all others yellow.
GREEN = PatternFill("solid", fgColor="FF92D050")
YELLOW = PatternFill("solid", fgColor="FFFFFF00")
GREEN_HEADERS = {"investorloanid", "origbal", "remark", "remarks"}

# Blocks that should use only specific trigger columns/values instead of the default rule.
# Key: (sheet, normalized header of the block's 2nd column)
TRIGGER_OVERRIDE = {
    ("City-Municipal", "townshipsearchstatustownshiplevel"): {"townshipsearchpassfail": {"fail"}},
    # Junior mortgage block: any loan with at least one junior mortgage
    ("Senior Lien", "juniormortgagescount"): {"juniormortgagescount": lambda v: isinstance(v, (int, float)) and v > 0},
}


def matches(value, test):
    return test(value) if callable(test) else norm(value) in test

THIN, THICK = Side(style="thin"), Side(style="thick")


def norm(s):
    if isinstance(s, float) and s == 0.04:
        return "0.04"
    return re.sub(r"[^a-z0-9]", "", str(s).lower())


def clean(v):
    if isinstance(v, str):
        v = v.replace("_x000D_", "").replace("\r", "")
        v = re.sub(r"\s*\n\s*", " ", v).strip()   # single line, so data cells stay unwrapped
        if re.fullmatch(r"\$\s*-", v):
            return 0
    return v


def find_blocks(ws):
    blocks = []
    for row in ws.iter_rows():
        for c in row:
            if c.value == "Investor Loan ID":
                heads, j = [], c.column
                while True:
                    v = ws.cell(c.row, j).value
                    if v is None or (j > c.column and v == "Investor Loan ID"):
                        break
                    heads.append(v)
                    j += 1
                blocks.append({"row": c.row, "col": c.column, "headers": heads})
    return blocks


def style_block(ws, top, left, ncols, nrows):
    for r in range(top, top + nrows + 1):
        for c in range(left, left + ncols):
            cell = ws.cell(r, c)
            hdr = r == top
            cell.font = Font(name="Calibri", size=10, bold=hdr)
            if hdr:
                cell.fill = GREEN if norm(cell.value) in GREEN_HEADERS else YELLOW
                cell.border = Border(top=THICK, bottom=THICK,
                                     left=THICK if c == left else THIN,
                                     right=THICK if c == left + ncols - 1 else THIN)
                cell.alignment = Alignment(wrap_text=True, vertical="center", horizontal="center")
            else:
                cell.border = Border(top=THIN, bottom=THIN, left=THIN, right=THIN)
                cell.alignment = Alignment(wrap_text=False, vertical="center", horizontal="center")


def recalc(path):
    """Save through LibreOffice (if installed) so formula results are stored."""
    exe = shutil.which("soffice") or shutil.which("libreoffice")
    if not exe:
        return
    tmp = tempfile.mkdtemp()
    subprocess.run([exe, "--headless", "--convert-to", "xlsx", "--outdir", tmp, path],
                   check=True, capture_output=True)
    shutil.move(os.path.join(tmp, os.path.basename(path)), path)


def run(prp_path, tmpl_path, out_path):
    src = openpyxl.load_workbook(prp_path, data_only=True)["Dashboard"]
    idx = {norm(c.value): i for i, c in enumerate(src[1]) if c.value and str(c.value).strip()}
    id_i = idx["investorloanid"]
    rows = [r for r in src.iter_rows(min_row=2, values_only=True) if r[id_i] is not None]

    wb = openpyxl.load_workbook(tmpl_path)
    report = []
    for ws in wb.worksheets:
        if ws.title in SKIP_SHEETS:
            continue
        blocks = find_blocks(ws)
        if not blocks:
            continue
        ws.delete_rows(1, ws.max_row)   # rewrite headers + data

        groups = {}
        for b in blocks:
            groups.setdefault(b["row"], []).append(b)
        offset, prev_end = 0, 0
        for trow in sorted(groups):
            start = trow + offset
            if prev_end and start < prev_end + 3:      # keep 2 blank rows between stacked blocks
                start = prev_end + 3
            offset = start - trow
            group_end = start
            for b in groups[trow]:
                heads = b["headers"]
                keys = [norm(h) for h in heads]
                rule = TRIGGER_OVERRIDE.get((ws.title, keys[1] if len(keys) > 1 else ""))
                if rule is None:
                    rule = {k: FLAG_VALUES for k in keys[1:] if k in idx and
                            any(norm(r[idx[k]]) in FLAG_VALUES for r in rows)}
                flag_cols = list(rule)
                hits = [r for r in rows if any(matches(r[idx[k]], t) for k, t in rule.items())]
                col_of = {k: openpyxl.utils.get_column_letter(b["col"] + i) for i, k in enumerate(keys)}

                for i, h in enumerate(heads):
                    cell = ws.cell(start, b["col"] + i, h)
                    if h == 0.04:
                        cell.number_format = "0%"

                for n, r in enumerate(hits, start=start + 1):
                    for i, k in enumerate(keys):
                        cell = ws.cell(n, b["col"] + i)
                        f = FORMULAS.get((ws.title, k))
                        if f:
                            refs = {L: col_of[h] for L, h in f[2].items()}
                            cell.value = f[0].format(r=n, **refs)
                            if f[1]:
                                cell.number_format = f[1]
                            continue
                        if k not in idx:
                            continue
                        v = clean(r[idx[k]])
                        cell.value = v
                        if hasattr(v, "year"):
                            cell.number_format = "mm-dd-yy"
                        elif isinstance(v, (int, float)) and any(w in k for w in MONEY_WORDS):
                            cell.number_format = ACCT

                style_block(ws, start, b["col"], len(heads), len(hits))
                missing = [h for h, k in zip(heads, keys) if k not in idx and (ws.title, k) not in FORMULAS]
                report.append((ws.title, str(heads[1]), len(hits),
                               [h for h in heads if norm(h) in flag_cols], missing))
                group_end = max(group_end, start + len(hits))
            prev_end = group_end
    wb.save(out_path)
    recalc(out_path)
    return report


def deal_name(path):
    """Deal prefix from the PRP file name, e.g. '561-4884-4887-4880 Dashboard Report.xlsx' -> '561-4884-4887-4880'."""
    stem = os.path.splitext(os.path.basename(path))[0]
    return re.sub(r"[\s_\-]*(prp\s*)?dashboard(\s*report)?$", "", stem, flags=re.I).strip(" _-") or stem


if __name__ == "__main__":
    a = sys.argv[1:4]
    if len(a) == 2:                       # output name follows the deal: "<deal>-Dashboard Clean up.xlsx"
        a.append(os.path.join(os.path.dirname(a[0]), f"{deal_name(a[0])}-Dashboard Clean up.xlsx"))
        print("Output:", a[2])
    for sheet, first, n, flags, missing in run(*a):
        print(f"{sheet:18} | {first[:40]:40} | {n:4} loans | flags: {flags}"
              + (f" | not in PRP: {missing}" if missing else ""))
