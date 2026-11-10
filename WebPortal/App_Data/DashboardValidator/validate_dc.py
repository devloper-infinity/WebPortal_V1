"""
Dashboard vs D&C exception validation.

Usage:
    python validate_dc.py <PRP.xlsx> <D&C report.xlsx> <Cleanup_template.xlsx> [output.xlsx]
    (output optional: defaults to "<deal>-D&C Validation Report.xlsx" next to the D&C file)

For every loan flagged on each dashboard sheet, looks for the expected exception(s)
in the D&C report and checks the amount and the exception level.

Result values
  No Issue                              exception present, amount matches, level as expected
  Amount Issue            exception present but amount differs / not stated
  Grade Issue             amount validated but level not as expected
  Amt & Grade Issue    both
  Not Raised           no expected exception in D&C
"""
import sys, re, datetime, warnings
import openpyxl
from openpyxl.styles import Font, Border, Side, Alignment, PatternFill

warnings.filterwarnings("ignore")

# ---------------------------------------------------------------- exception names
LOW = "Title Rvw shows lower lien position than loan docs"
MAJ = "Title Review shows major title concern"
MUNI = ["Title reports unpaid liens", "Title Review shows outstanding municipal liens",
        "Code Enforcement Lien", "Municipal Lien against the property",
        "Notice or lien against subject property", "Water/Sewer Taxes"]
MATURITY = ["Origination date is later than maturity date", "Loan maturity date has passed",
            "Maturity date not available on the mortgage",
            "Maturity date not mentioned on the mortgage document",
            "Maturity date not available on mortgage doc"]

ACCT = '_("$"* #,##0.00_);_("$"* \\(#,##0.00\\);_("$"* "-"??_);_(@_)'
THIN, THICK = Side(style="thin"), Side(style="thick")
GREEN = PatternFill("solid", fgColor="FF92D050")
YELLOW = PatternFill("solid", fgColor="FFFFFF00")
OK_FILL = PatternFill("solid", fgColor="FFC6EFCE")
BAD_FILL = PatternFill("solid", fgColor="FFFFC7CE")
MANUAL_FILL = PatternFill("solid", fgColor="FFFFEB9C")
GREEN_HEADERS = {"investorloanid", "origbal", "result", "remark", "remarks"}


def norm(s):
    return re.sub(r"[^a-z0-9]", "", str(s).lower())


def num(v):
    return float(v) if isinstance(v, (int, float)) else 0.0


def amounts_in(text):
    return [float(a.replace(",", "")) for a in re.findall(r"\$\s?([\d,]+(?:\.\d+)?)", text or "")
            if a.replace(",", "").replace(".", "").isdigit()]


WORDNUM = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "a": 1, "an": 1}


def exception_text(items):
    """Full text of exceptions for the 'Exception' column, one after another."""
    return " || ".join(f"[Lvl {x[1]}] {x[0]}: {x[2]}" for x in items)


def match_amount(dash_amts, amounts, exclude=()):
    """Match a dashboard amount against any single exception amount or the sum of
    several (e.g. 1st + 2nd junior lien). Returns (matched_text or None, candidates)."""
    import itertools
    cand = sorted({round(a, 2) for a in amounts if all(abs(a - e) > 1 for e in exclude)})[:12]
    for d in dash_amts:
        for k in range(1, min(5, len(cand)) + 1):
            for combo in itertools.combinations(cand, k):
                if abs(sum(combo) - d) <= 1:
                    txt = " + ".join(f"${a:,.2f}" for a in combo)
                    return (txt if k == 1 else f"{txt} = ${sum(combo):,.2f}"), cand
    return None, cand


def lien_count(text, kind):
    """Count of junior / senior (prior) mortgages stated in the exception text."""
    words = {"junior": r"junior", "senior": r"(?:prior|senior)"}[kind]
    m = re.findall(r"\b(one|two|three|four|five|\d+)\s+(?:\w+\s+){0,3}?" + words + r"\b", text.lower())
    vals = [WORDNUM.get(v, int(v) if v.isdigit() else 0) for v in m]
    return max(vals) if vals else None


# ---------------------------------------------------------------- loaders
def load_prp(path):
    ws = openpyxl.load_workbook(path, data_only=True)["Dashboard"]
    idx = {norm(c.value): i for i, c in enumerate(ws[1]) if c.value and str(c.value).strip()}
    rows = [r for r in ws.iter_rows(min_row=2, values_only=True) if r[idx["investorloanid"]]]
    return idx, rows


def load_dc(path):
    """Reads the D&C report by header name (works whether or not a Grade 1 column exists)."""
    wb = openpyxl.load_workbook(path, read_only=True)
    # Production exports commonly open on a pivot/table sheet. Prefer the actual
    # D&C sheet, then fall back to the first sheet containing a Loan header.
    ws = next((s for s in wb.worksheets if norm(s.title) in {"dc", "dispositionandcomments"}), None)
    if ws is None:
        ws = next((s for s in wb.worksheets
                   if any(str(v or "").lower().startswith("loan") for v in next(s.iter_rows(values_only=True), ()))),
                  wb.worksheets[0])
    # name stays on one line; the quoted description is optional (e.g. "* DTI > 60% (Lvl 4)" with no text)
    pat = re.compile(r'\*\s*([^*\n]+?)\s*\(Lvl\s*(\d)\)\s*(?:"(.*?)"(?=\s*\*|\s*$))?', re.S)
    it = ws.iter_rows(values_only=True)
    # Some D&C exports have a merged section-title row above the real headers.
    # Find the first row that contains both a Loan column and Grade columns.
    hdr = None
    for candidate in it:
        labels = [str(h or "") for h in candidate]
        if any(h.lower().startswith("loan") for h in labels) and any(h.lower().startswith("grade") for h in labels):
            hdr = labels
            break
    if hdr is None:
        raise ValueError("D&C report does not contain a Loan/Grade header row")
    id_c = next(i for i, h in enumerate(hdr) if h.lower().startswith("loan"))
    mod_c = next((i for i, h in enumerate(hdr) if "mod" in h.lower()), None)
    grade_c = [i for i, h in enumerate(hdr) if h.lower().startswith("grade")]
    serv_c = next((i for i, h in enumerate(hdr) if "servicing" in h.lower()), None)
    title_c = next((i for i, h in enumerate(hdr) if h.strip().lower() == "title"), None)
    out = {}
    for r in it:
        if not r or r[id_c] in (None, ""):
            continue
        items = []
        for ci in grade_c:
            if ci < len(r):
                for m in pat.finditer(r[ci] or ""):
                    items.append((m.group(1).strip(), int(m.group(2)), (m.group(3) or "").strip()))
        mod = (r[mod_c] or "").strip() if mod_c is not None and mod_c < len(r) else ""
        try:
            lid = int(str(r[id_c]).strip())
        except ValueError:
            continue
        serv = str(r[serv_c] or "") if serv_c is not None and serv_c < len(r) else ""
        title = str(r[title_c] or "") if title_c is not None and title_c < len(r) else ""
        # only exceptions with wording are validated; blank ones are listed separately
        blank = [x for x in items if not re.search(r"[A-Za-z0-9]", x[2])]
        items = [x for x in items if x not in blank]
        out[lid] = {"items": items, "blank": blank, "mod": mod, "serv": serv, "title": title}
    return out


# ---------------------------------------------------------------- checks
def build_checks(g, superlien):
    """Each check: sheet, trigger, primary exceptions, secondary exceptions,
    amount candidates (list of floats), expected levels (set or None), finding text."""
    def tax_notes_l4(r):
        lines = re.split(r"[\n\r]+|_x000d_", str(g(r, "Tax Notes") or "").lower())
        return any(re.search(r"\b(sold|forfeit\w*|paid by buyer|tax sale)\b", ln)
                   and not re.search(r"\b(released|redeemed|no tax sale|not sold)\b", ln) for ln in lines)

    def delinquent_levels(r):
        ob = num(g(r, " Orig Bal"))
        if (ob and num(g(r, "Delinquent Tax Amount")) > 0.04 * ob) or tax_notes_l4(r):
            return {4}
        return {2, 3}

    def ba(r, a, b):
        x, y = num(g(r, a)), num(g(r, b))
        return [v for v in (x, y, x + y) if v]

    def maturity_issue(r):
        od, md = g(r, "Orig Date"), g(r, "Subject Mortgage Maturity Date")
        if not isinstance(md, datetime.datetime) or md.year < 1901:
            return "Maturity date blank"
        if isinstance(od, datetime.datetime):
            months = (md.year - od.year) * 12 + md.month - od.month
            if months < 0:
                return "Origination later than maturity"
            if md < datetime.datetime.now():
                return "Maturity date passed"
            if months < 360:
                return f"Term {months} months (< 360)"
        return None

    muni_amts = lambda r, cols: [num(g(r, c)) for c in cols if num(g(r, c))]

    return [
        dict(sheet="Delinquent Taxes", trig=lambda r: g(r, "Delinquent OR Unpaid Taxes") == "Fail",
             prim=["Title Review shows outstanding delinquent taxes", "Delinquent Taxes"], sec=["Real estate lien against property"],
             amt=lambda r: [num(g(r, "Delinquent Tax Amount"))] if num(g(r, "Delinquent Tax Amount")) else [],
             lvl=delinquent_levels,
             find=lambda r: ("Delinquent with $0 amount in PRP" if not num(g(r, "Delinquent Tax Amount")) else
                             f"Delinquent; {num(g(r,'Delinquent Tax Amount'))/num(g(r,' Orig Bal'))*100:.2f}% of Orig Bal"
                             if num(g(r, " Orig Bal")) else "Delinquent")
                            + ("; sold/tax sale in notes" if tax_notes_l4(r) else "")),
        dict(sheet="Tax Lien", trig=lambda r: g(r, "Tax Lien") == "Y",
             prim=["Tax Lien showing on the subject property",
                   "The property had a tax sale - property or cert was sold to 3rd party", "Real estate lien against property"], sec=[LOW, MAJ],
             amt=lambda r: ba(r, "Tax Lien Amount Before Subject", "Tax Lien Amount After Subject"),
             lvl=lambda r: {4}, find=lambda r: "Tax Lien = Y"),
        dict(sheet="Tax Cert Red Flag", trig=lambda r: g(r, "Potential for Tax Cert Investor paying taxes") == "Red Flag",
             prim=["The property had a tax sale - property or cert was sold to 3rd party", LOW, MAJ], sec=[],
             amt=lambda r: [], lvl=lambda r: {4}, find=lambda r: "Tax Cert = Red Flag"),
        dict(sheet="State Tax", trig=lambda r: g(r, "State Tax Lien") == "Fail",
             prim=["Title Review shows outstanding state tax due", "State Tax Judgment",
                   "Active State Tax Lien Judgement."], sec=[LOW, MAJ],
             amt=lambda r: ba(r, "State Tax Lien Amount Before Subject", "State Tax Lien Amount After Subject"),
             lvl=lambda r: {3} if g(r, "State") == "PA" else {2, 3},
             find=lambda r: f"State Tax Lien = Fail ({g(r,'State')})"),
        dict(sheet="Federal Tax", trig=lambda r: g(r, "Federal Tax Lien") == "Fail",
             prim=["Title Review shows outstanding IRS liens", "IRS Lien outstanding",
                   "Updated title review shows IRS / vehicle / federal / personal tax liens",
                   "Title review shows lien by DOJ Department of Justice [Title_DOJ]",
                   "Title Review shows lien by DOJ_Department of Justice"], sec=[LOW, MAJ],
             amt=lambda r: ba(r, "Federal Tax Lien Amount Before Subject", "Federal Tax Lien Amount After Subject"),
             lvl=lambda r: {3} if g(r, "State") == "PA" else {2},
             find=lambda r: f"Federal Tax Lien = Fail ({g(r,'State')})"),
        dict(sheet="Senior Lien", trig=lambda r: g(r, "Subject mortgage in first position?") == "Fail",
             prim=[LOW, MAJ, "Sr Lien 1 Foreclosure started, investigate.",
                   "Sr Lien 2 Foreclosure started, investigate.",
                   "Lis Pendens Sr Lien 1 doesn't list lender/servicer/seller name",
                   "Lis Pendens Sr Lien 2 doesn't list lender/servicer/seller name", "Missing Title evidence"],
             sec=[], amt=lambda r: [num(g(r, "Total Senior Mortgage Amount"))] if num(g(r, "Total Senior Mortgage Amount")) else [],
             lvl=lambda r: {3, 4}, excl=lambda r: num(g(r, " Orig Bal")),
             count=("senior", "Senior Mortgage Count"),
             find=lambda r: f"Lien position {g(r,'Subject Mortgage Lien Position')}; {g(r,'Senior Mortgage Count')} senior mtg(s)"),
        dict(sheet="Junior Lien", trig=lambda r: num(g(r, "Junior Mortgages Count")) > 0 and
             num(g(r, "Total Junior Mortgage Amount")) > num(g(r, " Orig Bal")),
             prim=["Junior lien amount greater than the subject mortgage lien"],
             info=["Partial Claim on file"],
             sec=["Junior lien 1 started foreclosure, needs further investigation",
                  "Title Review shows unidentified junior lien"],
             amt=lambda r: [num(g(r, "Total Junior Mortgage Amount"))], lvl=lambda r: {3},
             excl=lambda r: num(g(r, " Orig Bal")), count=("junior", "Junior Mortgages Count"),
             find=lambda r: f"{g(r,'Junior Mortgages Count')} junior mtg(s) > Orig Bal {num(g(r,' Orig Bal')):,.2f}"),
        dict(sheet="Junior Lien FC", trig=lambda r: str(g(r, "Junior Lien Foreclosure: Review Required") or "").upper() == "Y",
             prim=["Junior lien 1 started foreclosure, needs further investigation",
                   "Junior lien 2 started foreclosure, needs further investigation",
                   "Junior lien 3 started foreclosure, needs further investigation",
                   "Lis Pendens Jr Lien 1 doesn't list lender/servicer/seller name",
                   "Lis Pendens Jr Lien 2 doesn't list lender/servicer/seller name",
                   "Lis Pendens Jr Lien 3 doesn't list lender/servicer/seller name"], sec=[LOW, MAJ],
             amt=lambda r: [], lvl=lambda r: {4}, find=lambda r: "Junior Lien FC review = Y"),
        dict(sheet="HOA", trig=lambda r: "Y" in (g(r, "HOA Lien Exists"), g(r, "HOA Foreclosure Y/N")),
             prim=["HOA/COA lien against property", "HOA\\COA lien agaist property"], sec=[LOW, MAJ],
             amt=lambda r: ba(r, "HOA Lien Amount Before Subject", "HOA Lien Amount After Subject"),
             lvl=lambda r: {4} if g(r, "HOA Foreclosure Y/N") == "Y" else ({3, 4} if g(r, "State") in superlien else {3}),
             find=lambda r: f"HOA FC = {g(r,'HOA Foreclosure Y/N')} ({g(r,'State')}{', super lien' if g(r,'State') in superlien else ''})"),
        dict(sheet="City-Municipal", trig=lambda r: "Y" in (g(r, "City Muni Assessment Lien Exists"),
                                                            g(r, "Water Sewer  Utilities Lien Exists"),
                                                            g(r, "Code Enforcement lien?")),
             prim=MUNI, sec=[LOW, MAJ, "Title Review shows outstanding delinquent taxes"],
             amt=lambda r: muni_amts(r, ["City Muni Assessment Lien Amount Before Subject", "City Muni Assessment Lien Amount After Subject",
                                         "Water Sewer  Utilities Lien Amount Before Subject", "Water Sewer Utilities Lien Amount After Subject",
                                         "Code Enforcement Lien amount Before", "Code Enforcement Lien amount After"]),
             lvl=lambda r: None, find=lambda r: "City/Water/Code lien = Y",
             only=["Title reports unpaid liens", "Title Review shows outstanding municipal liens",
                   "Code Enforcement Lien", "Municipal Lien against the property", "Water/Sewer Taxes"]),
        dict(sheet="Township Search", trig=lambda r: g(r, "Township Search Pass/Fail") == "Fail",
             prim=MUNI, sec=[], township=True,
             amt=lambda r: twp_amts(g, r),
             lvl=lambda r: None, find=lambda r: "Township Fail: " + ("; ".join(twp_needs(g, r)) or "nothing owed per PRP"), only=[]),
        dict(sheet="Mobile Home", trig=lambda r: g(r, "Mobile Home Present") == "Y",
             prim=["Property is Manufactured Housing", "Subject property is a manufactured home"], sec=[],
             amt=lambda r: [], lvl=lambda r: None, find=lambda r: "Mobile Home = Y"),
        dict(sheet="Maturity Date", trig=lambda r: maturity_issue(r) is not None,
             prim=MATURITY, sec=[], amt=lambda r: [],
             lvl=lambda r: {4} if maturity_issue(r) == "Maturity date blank" else None, find=maturity_issue),
        dict(sheet="FC Issues", trig=lambda r: g(r, "Subject Mortgage Foreclosed") == "Fail",
             prim=["Property is foreclosed and sold to 3rd party"], sec=[],
             amt=lambda r: [], lvl=lambda r: {4}, find=lambda r: "Subject Mortgage Foreclosed = Fail"),
    ]


# ---------------------------------------------------------------- Township / municipal / mobile home helpers
NO_VIOL_RE = re.compile(r"^\s*(none|no violations?|n/?a)\b", re.I)


def open_violation(txt):
    """PRP 'Code Enforcement & Permit Violations' holds an actual case (not NONE / NO VIOLATION)."""
    t = str(txt or "").strip()
    return bool(t) and not NO_VIOL_RE.match(t) and bool(re.search(r"case\s*#|violation", t, re.I))


def twp_needs(g, r):
    """What the Township search shows that must be reflected in D&C."""
    needs = []
    delq = lambda k: "delinquent" in str(g(r, k) or "").lower()
    if delq("Water Status") or delq("Sewer Status"):
        amt = num(g(r, "Total Amount Owed  (Water)")) + num(g(r, "Total Amount Owed (Sewer)"))
        needs.append(f"W/S delinquent ${amt:,.2f}")
    yes = lambda k: str(g(r, k) or "").strip().upper().startswith("Y")
    if yes("Demolition Lien?") or yes("Scheduled for Demolition?"):
        needs.append("Demolition")
    if open_violation(g(r, "Code Enforcement & Permit Violations")) or yes("Code Enforcement lien?"):
        needs.append("Code enforcement")
    if str(g(r, "Tax Status (Township Search Recheck)") or "").upper() == "DELINQUENT":
        needs.append("Tax delinquent")
    return needs


def twp_amts(g, r):
    """Amounts that must match: delinquent water/sewer total and/or violation fees (only for what is owed)."""
    n = twp_needs(g, r)
    w, sw = num(g(r, "Total Amount Owed  (Water)")), num(g(r, "Total Amount Owed (Sewer)"))
    delq = lambda k: "delinquent" in str(g(r, k) or "").lower()
    ws = (w if delq("Water Status") else 0) + (sw if delq("Sewer Status") else 0)   # delinquent part only
    vi = num(g(r, "Violations Total Amount"))
    out = []
    if any(x.startswith("W/S") for x in n) and ws:
        out.append(ws)
        if w + sw != ws:
            out.append(w + sw)                      # total owed also accepted
    if "Code enforcement" in n and vi:
        out.append(vi)
    if ws and vi:
        out.append(ws + vi)
    return out


WS_EXC = ["Water/Sewer Taxes", "Title reports unpaid liens", "Title Review shows outstanding municipal liens",
          "Municipal Lien against the property"]
CE_EXC = ["Code Enforcement Lien", "Notice or lien against subject property", "Municipal Lien against the property",
          "Title reports unpaid liens"]
TAX_EXC = ["Title Review shows outstanding delinquent taxes", "Delinquent Taxes"]


def muni_grade(hit, ob):
    """Level per exception type: code enforcement / demolition = L4; water/sewer = L2
    (L4 accepted when over 4% of Orig Bal, senior / prior, or a recorded lien that can foreclose). Others not level checked."""
    bad, tags = [], []
    for name, lvl, txt in hit:
        t = f"{name} {txt}".lower()
        if re.search(r"code enforcement|demolition|violation", t) and not re.search(r"no violation", t):
            exp, tag = {4}, "CE L4"
        elif re.search(r"water|sewer|utilit", t):
            over4 = ob and any(a > 0.04 * ob for a in amounts_in(txt))
            # recorded W/S lien able to foreclose (or > 4% / senior / prior / super lien) may be L4
            if over4 or re.search(r"exceeds? 4(\.0+)?\s*%|senior|prior|super.?lien|recorded on|foreclos", t):
                exp, tag = {2, 4}, "W/S L2/L4"
            else:
                exp, tag = {2}, "W/S L2"
        else:
            continue
        if tag not in tags:
            tags.append(tag)
        if lvl not in exp:
            bad.append(f"{name} L{lvl} (expected {tag.split()[1]})")
    return bad, (", ".join(tags) or "N/A")


MH_KW_RE = re.compile(r"manufactured home rider|\bMH rider|affidavit of affixation|affixation affidavit|\bVIN\b|VIN\s*#|"
                      r"vehicle identification|TPOL|schedule\s*b|sch\.?\s*b\b", re.I)
MAT_DATE_RE = re.compile(r"maturity date(?:\s+(?:of|is|was|as))?\s*:?\s*(\d{1,2}/\d{1,2}/\d{2,4})", re.I)


MH_DOC_RE = {"VIN#": r"\bVIN\b|serial number|vehicle identification",
             "affixation affidavit": r"affixation|affixture",
             "MH rider": r"(manufactured|mobile) home rider|\bMH rider"}
MH_NEG_RE = re.compile(r"\bnot\b|n't\b|\bno\b|missing|unavailable|absent|without", re.I)


def mh_available(text):
    """MH documents the exception states are available (VIN#, affixation affidavit, MH rider).
    A sentence that says the item is not available / missing / does not show counts as not available."""
    got = []
    for snt in re.split(r"(?<=[.!?])\s+", text or ""):
        for name, pat in MH_DOC_RE.items():
            for m in re.finditer(pat, snt, re.I):
                # negation near this item (same clause) means not available
                clause = re.split(r",|;|\band\b|\bwhile\b|\bbut\b", snt[max(0, m.start() - 60):m.end() + 60])
                near = next((c for c in clause if re.search(pat, c, re.I)), snt)
                if not MH_NEG_RE.search(near) and name not in got:
                    got.append(name)
    return got


def mh_grade(hit):
    """None of VIN# / affixation affidavit / MH rider stated as available -> Level 4 required."""
    avail = [a for x in hit for a in mh_available(x[2])]
    if avail:
        return None, "Available: " + ", ".join(dict.fromkeys(avail))
    return {4}, "No VIN# / affixation affidavit / MH rider available"


LIEN_FC_RE = re.compile(r"foreclosure started|started foreclosure|lis pendens (sr|jr) lien|started fc", re.I)


def is_lien_fc(name):
    return bool(LIEN_FC_RE.search(name or ""))


TOPICS = {
    "Delinquent Taxes": r"delinquent|tax",
    "State Tax": r"state tax|department of revenue|franchise tax|comptroller|taxation|state of",
    "Federal Tax": r"federal tax|internal revenue|\birs\b|department of justice|united states",
    "Tax Lien": r"tax lien|tax sale|certificate|fifa|fieri",
    "HOA": r"\bhoa\b|homeowner|association|condominium",
    "City-Municipal": r"municipal|water|sewer|utilit|code enforcement|permit|mud",
    "Township Search": r"municipal|water|sewer|utilit|code enforcement|permit|mud",
    "Senior Lien": r"prior mortgage|senior|second lien|mortgage",
    "Junior Lien": r"junior|partial claim",
    "Lien Level": r"lien|judgment|mortgage",
}
REASONS = [
    (r"ssn#?\b[^.]*\b(inconsistent|not consistent|does not match|not match)", "SSN# inconsistent"),
    (r"ssn#?\b[^.]*\b(not provided|not mentioned|not available|not reflected)", "SSN# not provided"),
    (r"(property )?address[^.]*\b(inconsistent|not consistent|does not match|different)", "Address inconsistent"),
    (r"prior owner", "Lien against prior owner"),
    (r"\b(released|satisfied|redeemed)\b", "Lien released/satisfied per title"),
    (r"no active judgments or liens", "Title shows no active judgments or liens"),
]


def title_reason(title, sheet):
    """Why an exception may not be raised: look near the topic in the D&C Title comments."""
    if not title or sheet not in TOPICS:
        return ""
    sents = [x.strip() for x in re.split(r"(?<=[.!?])\s+|\n+", title) if x.strip()]
    topic = TOPICS.get(sheet, r"lien|judgment")
    found = []
    for i, snt in enumerate(sents):
        if re.search(topic, snt, re.I):
            window = " ".join(sents[i:i + 3]).lower()
            for pat, label in REASONS:
                if sheet == "Lien Level" and label.startswith(("SSN", "Address")):
                    continue                        # borrower-identity reasons don't explain a missing lien level
                if re.search(pat, window) and label not in found:
                    found.append(label)
    if not found and sheet != "Delinquent Taxes" and re.search(REASONS[-1][0], title.lower()):
        found.append(REASONS[-1][1])
    return ", ".join(found)


g_row = None


def _why(lid, sheet, dc):
    rs = title_reason(dc.get(lid, {}).get("title", ""), sheet)
    return f"Title comment: {rs}. " if rs else ""


def evaluate(chk, r, g, dc):
    lid = int(g(r, "Investor Loan ID"))
    items = dc.get(lid, {"items": []})["items"]
    P = {norm(e) for e in chk["prim"]}
    S = {norm(e) for e in chk["sec"]}
    hit = [x for x in items if norm(x[0]) in P]
    generic_only = False
    if not hit:
        hit = [x for x in items if norm(x[0]) in S]
        generic_only = bool(hit)
    exp = chk["lvl"](r)
    doj = any("doj" in norm(x[0]) or re.search(r"department of justice|united states district court", x[2].lower())
              for x in hit)
    if chk["sheet"] in ("Federal Tax", "State Tax") and doj:
        exp = {4}                                  # DOJ / USA liens are Level 4
    if any(norm(x[0]) == norm("Real estate lien against property") for x in hit):
        exp = {4}                                  # raised as a tax lien (real estate lien) -> Level 4
    # I. state tax lien recorded prior to subject mortgage -> Level 3 allowed
    if chk["sheet"] in ("State Tax", "Federal Tax") and not doj and exp and any(re.search(r"\bprior\b", x[2].lower()) for x in hit):
        exp = exp | {3}
        if chk["sheet"] == "State Tax":
            exp = exp | {4}                        # state tax lien / warrant prior to subject mortgage: L4 accepted
    if any(is_lien_fc(x[0]) for x in hit):
        exp = {4}                                  # any lien starting FC is always Level 4
    dash_amts = chk["amt"](r)
    row = dict(lid=lid, find=chk["find"](r), damt=max(dash_amts) if dash_amts else None,
               exp="/".join(f"L{x}" for x in sorted(exp)) if exp else "N/A")
    if chk["sheet"] == "Maturity Date" and "< 360" in row["find"] and not hit:
        row.update(exc="", lvl="", camt="", ac="", gc="", res="Manual Check",
                   com="Maturity is on the mortgage doc; validation team to verify manually", full="")
        return row
    if chk["sheet"] == "Maturity Date" and row["find"] == "Maturity date blank" and not hit:
        d_ = dc.get(lid, {})
        alltxt = " ".join([d_.get("title", ""), d_.get("serv", "")] + [x[2] for x in items])
        m = MAT_DATE_RE.search(alltxt)
        if m:
            row.update(exc="", lvl="", camt="", ac="", gc="", res="Manual Check",
                       com=f"PRP maturity blank; D&C states maturity date {m.group(1)}", full=m.group(0))
            return row
    needs, missing = [], []
    if chk.get("township"):
        needs = twp_needs(g, r)
        names = {norm(x[0]) for x in items}
        has = lambda lst: any(norm(e) in names for e in lst)
        if not needs:
            if hit:
                bad, row["exp"] = muni_grade(hit, num(g(r, " Orig Bal")))
                row.update(exc=" | ".join(f"{x[0]} (Lvl {x[1]})" for x in hit), lvl=", ".join(f"L{x[1]}" for x in hit),
                           camt="", ac="N/A", gc="Mismatch" if bad else "N/A", res="Grade Issue" if bad else "No Issue",
                           com="; ".join(bad) if bad else "PRP shows nothing owed; municipal exception raised from title",
                           full=exception_text(hit))
            else:
                row.update(exc="", lvl="", camt="", ac="", gc="", res="Manual Check",
                           com="Township Fail but nothing owed / no violation per PRP; verify reason", full="")
            return row
        if needs == ["Tax delinquent"]:
            th = [x for x in items if norm(x[0]) in {norm(e) for e in TAX_EXC}]
            row.update(exc=" | ".join(f"{x[0]} (Lvl {x[1]})" for x in th), lvl=", ".join(f"L{x[1]}" for x in th),
                       camt="", ac="N/A", gc="N/A", res="No Issue" if th else "Not Raised",
                       com="Township tax delinquent; see Delinquent Taxes sheet for level" if th else
                           _why(lid, "Delinquent Taxes", dc) + "Township shows tax delinquent; no delinquent tax exception",
                       full=exception_text(th) or "None")
            return row
        for nd in needs:
            if nd.startswith("W/S") and not has(WS_EXC):
                missing.append(nd)
            if nd in ("Code enforcement", "Demolition") and not has(CE_EXC):
                missing.append(nd)
            if nd == "Tax delinquent" and not has(TAX_EXC):
                missing.append(nd)
    blank_hit = [x for x in dc.get(lid, {}).get("blank", []) if norm(x[0]) in P | S]
    if not hit and blank_hit:
        row.update(exc=" | ".join(f"{x[0]} (Lvl {x[1]})" for x in blank_hit), lvl=", ".join(f"L{x[1]}" for x in blank_hit),
                   camt="", ac="", gc="", res="Verbiage Issue",
                   com="Exception raised with no wording; amount and level could not be validated",
                   full=exception_text(blank_hit) + ' (no description)')
        return row
    info = [x for x in items if norm(x[0]) in {norm(e) for e in chk.get("info", [])}]
    if not hit and info:
        amts = [a for x in info for a in amounts_in(x[2])]
        row.update(exc="", lvl="", camt=", ".join(f"${a:,.2f}" for a in amts[:5]), ac="", gc="",
                   res="Not Raised",
                   com=_why(lid, chk["sheet"], dc) + f"Expected exception not raised; related {info[0][0]} (Lvl {info[0][1]}) found"
                       + (f", totals ${sum(amts):,.2f} vs dashboard ${row['damt']:,.2f}" if amts and row['damt'] else ""),
                   full=exception_text(info))
        return row
    if not hit:
        other = [x for x in items if x[1] >= 2]
        row.update(exc="", lvl="", camt="", ac="", gc="", res="Not Raised",
                   com=_why(lid, chk["sheet"], dc) + ("Not raised: " + ", ".join(needs) if needs else "No expected exception in D&C"),
                   full="No related exception. Other exceptions on this loan: " +
                        (", ".join(f"{x[0]} (Lvl {x[1]})" for x in other) or "None"))
        return row
    row["full"] = exception_text(hit)
    row["exc"] = " | ".join(f"{x[0]} (Lvl {x[1]})" for x in hit)
    row["lvl"] = ", ".join(f"L{x[1]}" for x in hit)
    found = [a for x in hit for a in amounts_in(x[2])]
    # amount check: single amount or sum of several liens (1st + 2nd ...), subject Orig Bal excluded
    excl = [chk["excl"](r)] if chk.get("excl") and chk["excl"](r) else []
    matched, cand = match_amount(dash_amts, found, excl) if dash_amts else (None, [])
    if not dash_amts:
        amt_ok, row["ac"] = True, "N/A"
        row["camt"] = ", ".join(f"${a:,.2f}" for a in sorted(set(found))[:6])
    else:
        amt_ok = matched is not None
        combo_note = ""
        if not amt_ok and found:
            # dashboard may combine this lien with another one described in a different exception
            others = [(a, x[0]) for x in items if x not in hit for a in amounts_in(x[2])]
            for a2, nm in others:
                m2, _ = match_amount([d - a2 for d in dash_amts], found, excl)
                if m2:
                    matched, amt_ok = f"{m2} + ${a2:,.2f}", True
                    combo_note = f"Dashboard amount includes ${a2:,.2f} from {nm}"
                    break
        row["ac"] = "Match" if amt_ok else ("Not stated" if not cand else "Mismatch")
        row["camt"] = matched if amt_ok else ", ".join(f"${a:,.2f}" for a in cand[:6])
    # lien count stated in exception vs dashboard count
    count_note = ""
    if chk.get("count"):
        kind, col = chk["count"]
        stated = [c for c in (lien_count(x[2], kind) for x in hit) if c]
        dcount = int(num(g_row(r, col))) if g_row else 0
        if stated and dcount and max(stated) != dcount and not (dash_amts and combo_note):
            count_note = f"Dashboard count {dcount}, exception states {max(stated)} {kind} lien(s)"
    # grade check
    muni_bad = None
    if chk["sheet"] == "Mobile Home":
        exp, mh_note = mh_grade(hit)
        row["exp"] = "L4" if exp else "Any"
    if chk["sheet"] in ("City-Municipal", "Township Search"):
        muni_bad, row["exp"] = muni_grade(hit, num(g(r, " Orig Bal")))
        grade_ok = not muni_bad
        row["gc"] = "N/A" if row["exp"] == "N/A" else ("Match" if grade_ok else "Mismatch")
    elif exp is None:
        grade_ok, row["gc"] = True, "N/A"
    else:
        grade_ok = any(x[1] in exp for x in hit)
        row["gc"] = "Match" if grade_ok else "Mismatch"
    if amt_ok and grade_ok:
        row["res"], row["com"] = "No Issue", ""
    elif not amt_ok and not grade_ok:
        row["res"] = "Amt & Grade Issue"
    elif not amt_ok:
        row["res"] = "Amount Issue"
    else:
        row["res"] = "Grade Issue"
    if row["res"] != "No Issue":
        bits = []
        if not amt_ok:
            if cand:
                near = min(cand, key=lambda a: abs(a - row["damt"]))
                bits.append(f"Dash ${row['damt']:,.2f} vs D&C ${near:,.2f} (diff ${row['damt'] - near:,.2f})")
            else:
                bits.append(f"Dash ${row['damt']:,.2f}; no amount stated in exception")
        if not grade_ok:
            bits.append("; ".join(muni_bad) if muni_bad else f"Expected {row['exp']}, raised {row['lvl']}")
            if chk["sheet"] == "Mobile Home":
                bits.append(mh_note)
            if chk["sheet"] == "State Tax" and 4 in {x[1] for x in hit} and 4 not in exp:
                bits.append("Junior state tax lien; L4 only when prior to the subject mortgage")
        if generic_only:
            bits.insert(0, f"Specific exception not raised; found under {hit[0][0]}")
        if count_note:
            bits.append(count_note)
        row["com"] = "; ".join(bits)
    else:
        row["com"] = "; ".join(b for b in (f"Raised under {hit[0][0]}" if generic_only else "",
                                           combo_note if dash_amts else "", count_note) if b)
    if missing:
        row["res"] = "Not Raised"
        row["com"] = _why(lid, chk["sheet"], dc) + "Not raised: " + ", ".join(missing) + \
            (f"; raised: {row['exc']}" + (f" ({'; '.join(muni_bad)})" if muni_bad else "") if row.get("exc") else "")
    if chk["sheet"] == "Mobile Home" and not any(MH_KW_RE.search(x[2]) for x in hit):
        row["res"] = "Verbiage Issue" if row["res"] == "No Issue" else row["res"]
        row["com"] = "No MH rider / affixation affidavit / VIN# / TPOL Sch B mention in exception" + (f"; {row['com']}" if row["com"] else "")
    return row


LOANREF_RE = re.compile(r"\b(?:Ln|Loan)\s*(?:No\.?|Number)?\s*#?\s*[:_\-]?\s*(\d{5,})\b", re.I)


def loanref_rows(dc):
    """Exception / comment text that refers to a different loan of the same deal (copy-paste risk)."""
    out = []
    for lid in sorted(dc):
        d = dc[lid]
        cols = [("Title", d["title"]), ("Servicing", d["serv"]), ("Mod Comments", d["mod"])] + \
               [(f"{x[0]} (Lvl {x[1]})", x[2]) for x in d["items"]]
        for where, txt in cols:
            for m in LOANREF_RE.finditer(txt or ""):
                o = int(m.group(1))
                if o != lid and o in dc:
                    s = max(0, m.start() - 80)
                    out.append(dict(lid=lid, find=f"Text refers to Ln#{o}", damt=None, exp="", exc=where, lvl="",
                                    camt="", ac="", gc="", res="Verbiage Issue",
                                    com=f"Exception text mentions another loan ({o}); possible copy from that loan",
                                    full="..." + txt[s:m.end() + 80] + "..."))
    return out


def mod_rows(g, rows, dc):
    out = []
    for r in rows:
        if g(r, "Subject Mortgage Modified") != "Y":
            continue
        lid = int(g(r, "Investor Loan ID"))
        d = dc.get(lid, {"items": [], "mod": ""})
        mc = d["mod"]
        hit = [x for x in d["items"] if norm(x[0]) in {norm("Loan appears modified. Mod missing or unexecuted"), norm("Modification Issue")}]
        has_mod = mc and mc.lower() != "not applicable"
        res = "No Issue" if has_mod or hit else "Not Raised"
        out.append(dict(lid=lid, find="Modified = Y", damt=num(g(r, "Modification Amount")) or None,
                        exp="N/A", exc=" | ".join(f"{x[0]} (Lvl {x[1]})" for x in hit),
                        lvl=", ".join(f"L{x[1]}" for x in hit), camt="", ac="N/A", gc="N/A", res=res,
                        full=(exception_text(hit) + (" || " if hit and has_mod else "") +
                              (f"Mod Comments: {mc}" if has_mod else "")) or "None",
                        com=("Mod comments present" if has_mod else
                             "Mod missing exception raised" if hit else "No Mod comments and no Mod exception")))
    return out


# ---------------------------------------------------------------- Lien level exception (compulsory)
SECOND_LIEN_RE = re.compile(r"originated as (a )?second lien|subject is (a )?second lien|subject mortgage is (a )?second lien", re.I)
LIEN_LEVEL = [LOW, MAJ]                       # either one counts as the lien level exception
NONLIEN_SEVERE_RE = re.compile(r"lien|prior mortgage|foreclos|\bhoa\b|tax|judgment|senior", re.I)


def lien_level_rows(g, rows, dc, superlien):
    """Loans where a lien sits ahead of the subject: lower lien position / major title concern must be raised.
    One per loan is enough; must be L4 when any lien started or completed foreclosure."""
    out = []
    for r in rows:
        lid = int(g(r, "Investor Loan ID"))
        items = dc.get(lid, {"items": []})["items"]
        st = g(r, "State")
        yes = lambda k: str(g(r, k) or "").strip().upper() in ("Y", "YES")
        trig, fc = [], []
        if yes("Tax Mortgages"): trig.append("Tax Mortgage")
        if yes("Tax Lien"): trig.append("Tax Lien")
        if g(r, "Potential for Tax Cert Investor paying taxes") == "Red Flag": trig.append("Tax Cert Red Flag")
        if str(g(r, "Tax Deed  in chain New") or "Pass") not in ("Pass", "N/A", ""): trig.append("Tax Deed in chain")
        if st == "PA" and "Fail" in (g(r, "State Tax Lien"), g(r, "Federal Tax Lien")):
            trig.append("State/Federal tax in PA")                  # borrower liens, above mortgage only in PA
        second = SECOND_LIEN_RE.search(" ".join(x[2] for x in items))
        if num(g(r, "Senior Mortgage Count")) > 0 and not second:
            trig.append(f"Senior mortgage count {int(num(g(r, 'Senior Mortgage Count')))}")
        hoa_fc = yes("HOA Foreclosure Y/N")
        if yes("HOA Lien Exists") and (st in superlien or hoa_fc):
            trig.append(f"HOA {'foreclosure' if hoa_fc else 'in super lien state ' + str(st)}")
        if yes("City Muni Assessment Lien Exists"): trig.append("City Muni lien")
        if yes("Code Enforcement lien?"): trig.append("Code Enforcement lien")
        if g(r, "Subject Mortgage Foreclosed") == "Fail":
            trig.append("Subject mortgage foreclosed"); fc.append("subject foreclosed")
        if hoa_fc: fc.append("HOA foreclosure")
        if yes("Tax Foreclosure?"): trig.append("Tax foreclosure"); fc.append("tax foreclosure")
        # Title issue categories (detail read first)
        other_liens = any(yes(k) for k in ("City Muni Assessment Lien Exists", "Water Sewer  Utilities Lien Exists",
                                           "Code Enforcement lien?", "Tax Lien"))
        junior_hoa_only = (yes("HOA Lien Exists") and not num(g(r, "HOA Lien Amount Before Subject"))
                           and st not in superlien and not hoa_fc and not other_liens)
        for sg in parse_issue_desc(str(g(r, "Issue Description") or "")):
            cat, code, detail = sg["cat"].lower(), sg["code"], f"{sg['code']} {sg['alert']}"
            if code == "NONMTGLN" and not junior_hoa_only:
                trig.append("Title NONMTGLN")
            elif code == "CODEENF":
                trig.append("Title CODEENF")
            elif (cat.startswith("severe") or cat.startswith("unresolved")):
                if code in ("SDSFC", "URHFC") or NONLIEN_SEVERE_RE.search(sg["alert"] or ""):
                    trig.append(f"Title {code}")
                if code in ("SDSFC", "URHFC"):
                    fc.append("foreclosure per title")
        if any(is_lien_fc(x[0]) for x in items):
            fc.append("lien foreclosure exception raised")
        if not trig:
            continue
        trig = list(dict.fromkeys(trig))
        need4 = bool(fc)
        hit = [x for x in items if norm(x[0]) in {norm(e) for e in LIEN_LEVEL}]
        row = dict(lid=lid, find="; ".join(trig), damt=None, exp="L4" if need4 else "L3/L4", camt="", ac="N/A")
        if not hit:
            row.update(exc="", lvl="", gc="", res="Not Raised",
                       com=_why(lid, "Lien Level", dc) + "Lien level exception (lower lien position / major title concern) missing",
                       full="Other exceptions: " + (", ".join(f"{x[0]} (Lvl {x[1]})" for x in items if x[1] >= 3) or "None"))
        else:
            ok = (not need4) or all(x[1] == 4 for x in hit)        # every lien level exception must be L4 on FC
            row.update(exc=" | ".join(f"{x[0]} (Lvl {x[1]})" for x in hit), lvl=", ".join(f"L{x[1]}" for x in hit),
                       gc="Match" if ok else "Mismatch", res="No Issue" if ok else "Grade Issue",
                       com=("" if ok else f"Foreclosure ({', '.join(dict.fromkeys(fc))}): lien level must be L4"),
                       full=exception_text(hit))
        out.append(row)
    return out


# ---------------------------------------------------------------- FC filed: LP dates vs Foreclosure Comments
DATE_RE = re.compile(r"\b(\d{1,2})/(\d{1,2})/(\d{2,4})\b")


def dates_in(text):
    out = set()
    for m, d, y in DATE_RE.findall(text or ""):
        y = int(y) + (2000 if len(y) == 2 else 0)
        try:
            out.add(datetime.date(y, int(m), int(d)))
        except ValueError:
            pass
    return out


def fc_section(serv):
    m = re.search(r"Foreclosure Comments:(.*?)(?:Bankruptcy Comments:|$)", serv or "", re.S | re.I)
    return m.group(1).strip() if m else ""


def fc_rows(g, rows, dc):
    out = []
    for r in rows:
        if g(r, "Foreclosure Filed for Subject Mortgage") != "Y":
            continue
        lid = int(g(r, "Investor Loan ID"))
        lp = g(r, "LP Filing Dates")
        lp_dates = {lp.date()} if isinstance(lp, datetime.datetime) else dates_in(str(lp or ""))
        sec = fc_section(dc.get(lid, {}).get("serv", ""))
        has_fc = bool(sec) and sec.lower().strip(". ") not in ("not applicable", "n/a", "na")
        found = dates_in(sec)
        hit = sorted(d for d in lp_dates if d in found)
        miss = sorted(d for d in lp_dates if d not in found)
        fmt = lambda ds: ", ".join(d.strftime("%m/%d/%Y") for d in ds)
        if not has_fc:
            res, com = "Not Raised", "Foreclosure Comments not applicable / blank in D&C"
        elif not lp_dates:
            res, com = "No Issue", "No LP date in PRP; foreclosure covered in D&C comments"
        elif miss:
            res, com = "Date Missing", f"{len(miss)} of {len(lp_dates)} LP date(s) not mentioned"
            near = []
            for d in miss:
                if found:
                    c = min(found, key=lambda x: abs((x - d).days))
                    if abs((c - d).days) <= 60:
                        near.append(f"{d:%m/%d/%Y} vs {c:%m/%d/%Y} ({(c - d).days:+d} days)")
            if near:
                com += "; closest in D&C: " + "; ".join(near)
        else:
            res, com = "No Issue", ""
        out.append(dict(lid=lid, lp=fmt(sorted(lp_dates)) or "Blank in PRP", fcp="Yes" if has_fc else "No",
                        found=fmt(hit), miss=fmt(miss), res=res, com=com, full=sec or "None"))
    return out


FC_COLS = [("Investor Loan ID", "lid"), ("LP Filing Dates (PRP)", "lp"), ("FC Comments", "fcp"),
           ("Dates Found", "found"), ("Dates Missing", "miss"), ("Result", "res"),
           ("Comment", "com"), ("Foreclosure Comments (D&C)", "full")]
FC_WIDTHS = [9, 22, 8, 20, 20, 13, 32, 60]


# ---------------------------------------------------------------- Title Issue description vs findings
CAT_RE = re.compile(r"^([A-Za-z][A-Za-z \-]*?[A-Za-z])\s+-\s+([A-Z0-9][A-Z0-9\-]+)\s*:"   # "Severe - SOMD:" (any category)
                    r"|^([A-Z][A-Za-z0-9]*(?:-[A-Za-z0-9]+)+|[A-Z][A-Z0-9\-]{3,})\s*:")    # "CODEENF:" / "NONMTGLN:" / "MH-Defect1:"
TITLE_EXAM_RE = re.compile(r"please see title exam section", re.I)
CAT_LEVELS = {"Non-Issue": {2}, "Informational": {2}, "CODEENF": {4}, "NONMTGLN": {3, 4},
              "Severe": {4}, "Unresolved": {4}, "DataTape Integrity": None, "Title Exam": None}
def cat_level(cat):
    """Expected level by category; matches on prefix so variants ("Severe Defect") work on any deal."""
    if cat in CAT_LEVELS:
        return CAT_LEVELS[cat]
    c = cat.lower()
    for key, lv in (("non-issue", {2}), ("informational", {2}), ("severe", {4}), ("unresolved", {4}),
                    ("codeenf", {4}), ("nonmtgln", {3, 4}), ("datatape", None)):
        if c.startswith(key):
            return lv
    return None


OWNER = ["Title Rvw shows prop. owner of record is not borr.", "Deceased Borrower(s)"]
LIENS = ["HOA/COA lien against property", "HOA\\COA lien agaist property", "Municipal Lien against the property",
         "Real estate lien against property", "Notice or lien against subject property", "State Tax Judgment",
         "Active State Tax Lien Judgement.", "Tax Lien showing on the subject property", "Code Enforcement Lien",
         "Title Review shows outstanding delinquent taxes", "Water/Sewer Taxes", "Active Judgment Against Borrower",
         "Updated title review shows IRS / vehicle / federal / personal tax liens", "Title reports unpaid liens",
         "Title Review shows outstanding municipal liens", LOW, MAJ]
CODE_EXC = {
    "CODEENF": ["Code Enforcement Lien", "Notice or lien against subject property", "Municipal Lien against the property", LOW, MAJ],
    "NONMTGLN": LIENS,
    "NIFLT": OWNER, "INTPT": OWNER, "INEST": OWNER,
    "NINDM": ["Issue with the legal description or recorded instrument", "Title issue", "Title Issue", MAJ] + OWNER,
    "SDSFC": ["Property is foreclosed and sold to 3rd party", MAJ],
    "URHFC": ["Property is foreclosed and sold to 3rd party", MAJ, LOW],
}
MTG_EXC = {
    "MTG-NOREL": ["Title review shows no release for prior mortgage", "Updated title shows prior lien not released", "Release of mortgage"],
    "MTG-SBJ": ["Mortgage", "Mortgage Not Recorded", "Mortgage missing / unexecuted",
                "Issue with the legal description or recorded instrument", "Title issue", "Title Issue"],
    "MTG-HOA": ["HOA/COA lien against property", "Property is foreclosed and sold to 3rd party"],
    "MTG-WBORR": ["Title Rvw shows prop. owner of record is not borr.", "Signatures at closing - There is an issue with not all property owners signing the title.",
                  "Issue with the legal description or recorded instrument", "Title issue", "Title Issue"],
    "MTG-MBORR": ["Title Rvw shows prop. owner of record is not borr.", "Signatures at closing - There is an issue with not all property owners signing the title.",
                  "Issue with the legal description or recorded instrument", "Title issue", "Title Issue"],
    "MTG-SIGN": ["Signatures at closing - There is an issue with not all property owners signing the title."],
    "MTG-LEGA": ["Issue with the legal description or recorded instrument", "Mortgage"],
}
MH_EXC = ["Property is Manufactured Housing", "Subject property is a manufactured home"]   # MH-Defect codes
TITLE_EXAM_EXC = ["Title review shows no release for prior mortgage", "Updated title shows prior lien not released",
                  "Release of mortgage", "Mortgage", "Title issue", "Title Issue", "Missing Title evidence",
                  "Title Review shows unidentified junior lien", "Issue with the legal description or recorded instrument"]
DEFAULT_EXC = [MAJ, LOW, "Title issue", "Title Issue", "Signatures at closing - There is an issue with not all property owners signing the title.",
               "Issue with the legal description or recorded instrument"] + OWNER
STOP = set("the and for with was were which that this from have has are not but been into also per see field other "
           "property subject mortgage borrower title deed dated updated report according located".split())


def tokens(text):
    return {w for w in re.findall(r"[a-z0-9#]+", (text or "").lower()) if (len(w) >= 4 or w.isdigit()) and w not in STOP}


def parse_issue_desc(desc):
    """Split the PRP Issue Description into (category, code, alert comment) segments."""
    segs, cur = [], None
    for line in re.split(r"[\r\n]+|_x000D_", desc or ""):
        line = line.strip()
        if not line:
            continue
        if TITLE_EXAM_RE.search(line):
            # mortgage-related issue in the Title Exam section: checked as its own row
            if not any(sg["cat"] == "Title Exam" for sg in segs):
                segs.append({"cat": "Title Exam", "code": "TITLE-EXAM", "alert": []})
            line = TITLE_EXAM_RE.split(line)[0].strip(" .")
            if not line:
                continue
        m = CAT_RE.match(line)
        if m:
            cat = (m.group(1) or m.group(3)).strip()
            code = m.group(2) or m.group(3)
            cur = {"cat": cat, "code": code, "alert": [], "defn": line[m.end():].strip()}   # code definition on the same line
            segs.append(cur)
        elif cur is not None and cur["cat"] != "Title Exam":
            cur["alert"].append(line)
        elif segs:
            prev = [sg for sg in segs if sg["cat"] != "Title Exam"]
            if prev:
                prev[-1]["alert"].append(line)
    for sgm in segs:
        sgm["alert"] = " ".join(sgm["alert"])
    return segs


def title_rows(g, rows, dc):
    out = []
    for r in rows:
        segs = parse_issue_desc(str(g(r, "Issue Description") or ""))
        lid = int(g(r, "Investor Loan ID"))
        items = [x for x in dc.get(lid, {"items": []})["items"]]
        for sg in segs:
            exp = cat_level(sg["cat"])
            if sg["cat"] == "Title Exam":
                codes = list(dict.fromkeys(c for c in str(g(r, "Code") or "").split(";") if c.startswith("MTG-")))
                mapped = [e for c in codes for e in MTG_EXC.get(c, [])]
                # a mapped MTG code needs its own finding (or lower lien / major title concern); else generic list
                cand_list = (mapped + [LOW, MAJ]) if mapped else (TITLE_EXAM_EXC + [LOW, MAJ])
                sg["alert"] = "Mortgage related issue (Title Exam)" + (f": {', '.join(codes)}" if codes else "")
            else:
                cand_list = CODE_EXC.get(sg["code"], MH_EXC if sg["code"].upper().startswith("MH-") else DEFAULT_EXC)
            cands = {norm(e) for e in cand_list}
            at = set() if sg["cat"] == "Title Exam" else tokens(sg["alert"])
            scored = []
            for x in items:
                ov = len(at & tokens(x[2])) / len(at) if at else 0.0
                quoted = bool(at) and sg["alert"][:40].lower() in x[2].lower()
                score = ov + (0.5 if norm(x[0]) in cands else 0) + (1 if quoted else 0)
                if norm(x[0]) in cands or ((ov >= 0.4 or quoted) and sg["cat"] != "Title Exam"):
                    scored.append((score, ov, x))
            scored.sort(key=lambda t: (-t[0], -t[2][1]))
            row = dict(lid=lid, code=sg["code"], cat=sg["cat"].replace("DataTape Integrity", "DataTape"), alert=" ".join(x for x in (sg.get("defn", ""), sg["alert"]) if x) or "(no alert text)",
                       exp="/".join(f"L{x}" for x in sorted(exp)) if exp else "N/A")
            if sg["cat"].lower().startswith("datatape"):
                rel = [x for x in items if at and len(at & tokens(x[2])) >= 2][:3]
                row.update(exc=" | ".join(f"{x[0]} (Lvl {x[1]})" for x in rel), lvl="", verb="N/A", gc="N/A",
                           res="Manual Check", com="Compare tape data vs actual findings",
                           full=exception_text(rel) or "No related finding")
                out.append(row)
                continue
            if not scored and sg["cat"] == "Title Exam" and "DTI-MTG" in str(g(r, "Code") or ""):
                row.update(exc="", lvl="", verb="N/A", gc="N/A", res="Manual Check",
                           com="Subject mortgage date/amount differs from tape (DTI-MTG); compare tape vs findings",
                           full="No title finding; tape comparison needed")
                out.append(row)
                continue
            if not scored:
                other = [x for x in items if x[1] >= 2]
                row.update(exc="", lvl="", verb="", gc="", res="Not Raised",
                           com="No finding reflects this title issue",
                           full="No related exception. Other exceptions on this loan: " +
                                (", ".join(f"{x[0]} (Lvl {x[1]})" for x in other) or "None"))
                out.append(row)
                continue
            best = scored[0]
            top = [t for t in scored if t[0] >= best[0] - 0.25][:3]
            row["exc"] = " | ".join(f"{t[2][0]} (Lvl {t[2][1]})" for t in top)
            row["lvl"] = ", ".join(f"L{t[2][1]}" for t in top)
            row["full"] = exception_text([t[2] for t in top])
            # verbiage: is the alert comment reflected in our finding?
            ov = max(t[1] for t in top)
            pointer = sg["alert"].lower().startswith("see ") and sg["cat"] != "Title Exam"
            if pointer:
                # "See HOA lien in judgment section" -> check the pointed lien type was raised
                want = [k for k, words in POINTERS.items() if re.search(words, sg["alert"].lower())]
                names = " ".join(x[0].lower() for x in items)
                got = [k for k in want if re.search(POINTER_EXC[k], names)]
                verb_ok = bool(want) and len(got) == len(want)
                row["verb"] = "Pointer"
                pointer_note = f"Alert points to {', '.join(want) or 'n/a'}; raised: {', '.join(got) or 'none'}"
            elif sg["code"].upper().startswith("MH-"):
                # mobile home defect: finding must mention MH rider / affixation / VIN# / TPOL Sch B
                verb_ok = any(MH_KW_RE.search(t[2][2]) for t in top)
                row["verb"] = "MH wording" if verb_ok else "No MH wording"
            elif not at:
                verb_ok, row["verb"] = True, "N/A"
            else:
                in_cands = any(norm(t[2][0]) in cands for t in top)
                verb_ok = ov >= 0.4 or (in_cands and ov >= 0.2) or any(sg["alert"][:40].lower() in t[2][2].lower() for t in top)
                row["verb"] = f"{ov:.0%}"
            if sg["code"].upper().startswith("MH-"):
                exp, mh_note = mh_grade([t[2] for t in top])
                row["exp"] = "L4" if exp else "Any"
            grade_ok = exp is None or any(t[2][1] in exp for t in top)
            row["gc"] = "N/A" if exp is None else ("Match" if grade_ok else "Mismatch")
            if verb_ok and grade_ok:
                row["res"], row["com"] = "No Issue", (pointer_note if pointer else "")
            else:
                row["res"] = ("Verbiage & Grade Issue" if not verb_ok and not grade_ok else
                              "Verbiage Issue" if not verb_ok else "Grade Issue")
                bits = []
                if not verb_ok:
                    bits.append(pointer_note if pointer else "No MH rider / affixation affidavit / VIN# / TPOL Sch B mention" if sg["code"].upper().startswith("MH-") else f"Only {ov:.0%} of alert wording found in finding")
                if not grade_ok:
                    bits.append(f"{sg['cat']} expects {row['exp']}, raised {row['lvl']}")
                row["com"] = "; ".join(bits)
            out.append(row)
    return out


POINTERS = {"HOA": r"\bhoa|coa\b", "Municipal": r"muni|city", "Tax": r"\btax", "Code": r"\bcode",
            "Water/Sewer": r"water|sewer|utilit", "Judgment": r"judgment(?! section)"}
POINTER_EXC = {"HOA": r"hoa", "Municipal": r"municipal|water/sewer|notice or lien",
               "Tax": r"tax|real estate lien", "Code": r"code enforcement|notice or lien",
               "Water/Sewer": r"water/sewer|utilit|municipal", "Judgment": r"judgment"}


TI_COLS = [("Investor Loan ID", "lid"), ("Code", "code"), ("Category", "cat"), ("Alert Comment (PRP)", "alert"),
           ("Exp Lvl", "exp"), ("D&C Exception", "exc"), ("D&C Lvl", "lvl"), ("Verbiage", "verb"),
           ("Grade Check", "gc"), ("Result", "res"), ("Comment", "com"), ("Exception", "full")]
TI_WIDTHS = [9, 10, 11, 24, 6, 22, 6, 8, 8, 18, 28, 28]



# ---------------------------------------------------------------- Data consistency (PRP vs D&C text) and US spelling
STATES = {"AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas", "CA": "California", "CO": "Colorado",
          "CT": "Connecticut", "DE": "Delaware", "DC": "District of Columbia", "FL": "Florida", "GA": "Georgia",
          "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas",
          "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland", "MA": "Massachusetts",
          "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri", "MT": "Montana",
          "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico",
          "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio", "OK": "Oklahoma",
          "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island", "SC": "South Carolina", "SD": "South Dakota",
          "TN": "Tennessee", "TX": "Texas", "UT": "Utah", "VT": "Vermont", "VA": "Virginia", "WA": "Washington",
          "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming", "PR": "Puerto Rico"}
STATE_NAME2AB = {n.lower(): a for a, n in STATES.items()}
STATE_NAME_RE = re.compile(r"\b(" + "|".join(sorted(map(re.escape, STATES.values()), key=len, reverse=True)) + r")\b")
STATE_AB_RE = re.compile(r"(?:\b(?:property is (?:located )?in|is in|located in|in the state of|state of)\s+)(" + "|".join(STATES) + r")\b")
STREET_SFX = r"(?:St|Street|Ave|Avenue|Rd|Road|Dr|Drive|Blvd|Boulevard|Ln|Lane|Way|Ct|Court|Pl|Place|Cir|Circle|Trl|Trail|Ter|Terrace|Hwy|Highway|Pkwy|Parkway)"
COUNTY_AGENCY_RE = re.compile(r"\s+(Fire|Sheriff|School|Schools|Hospital|Health|Government|Public|Board|Police|Library|"
                              r"Transit|Community|Medical|Jail|Detention|EMS|Parks)\b")
UK_US = {"colour": "color", "colours": "colors", "neighbour": "neighbor", "neighbours": "neighbors",
         "neighbourhood": "neighborhood", "favour": "favor", "favourable": "favorable", "honour": "honor",
         "labour": "labor", "behaviour": "behavior", "counselling": "counseling", "counsellor": "counselor",
         "cancelled": "canceled", "cancelling": "canceling", "centre": "center", "metre": "meter",
         "licence": "license", "defence": "defense", "offence": "offense", "cheque": "check", "cheques": "checks",
         "grey": "gray", "judgement": "judgment", "judgements": "judgments", "programme": "program",
         "travelled": "traveled", "modelling": "modeling", "labelled": "labeled", "enrolment": "enrollment",
         "fulfil": "fulfill", "instalment": "installment", "instalments": "installments", "analyse": "analyze",
         "acknowledgement": "acknowledgment", "upto": "up to", "storey": "story", "aluminium": "aluminum",
         "mould": "mold", "tyre": "tire", "whilst": "while", "amongst": "among", "organise": "organize",
         "organisation": "organization", "realise": "realize", "recognise": "recognize", "authorise": "authorize",
         "authorised": "authorized", "utilise": "utilize", "finalise": "finalize", "finalised": "finalized",
         "itemised": "itemized", "summarise": "summarize", "emphasise": "emphasize", "capitalised": "capitalized",
         "amortisation": "amortization", "amortised": "amortized", "apologise": "apologize",
         "signalling": "signaling", "totalling": "totaling", "totalled": "totaled", "endorsment": "endorsement",
         "jewellery": "jewelry", "manoeuvre": "maneuver", "plough": "plow", "catalogue": "catalog",
         "dialogue": "dialog", "ageing": "aging", "fibre": "fiber", "theatre": "theater", "calibre": "caliber"}
UK_RE = re.compile(r"\b(" + "|".join(UK_US) + r")\b", re.I)
DATEPAT = r"(\d{1,2}/\d{1,2}/\d{2,4})"
SUBJ_RE = re.compile(r"subject mortgage was originated on " + DATEPAT + r"(?:\s+and recorded on " + DATEPAT + r")?"
                     r"(?P<mid>[^$]{0,200}?)in the amount of \$(?P<amt>[\d,]+(?:\.\d+)?)(?P<tail>[^.\n]*(?:\.[A-Z,][^.\n]*)*)", re.I)
CORP_WORDS = set("llc inc corp corporation company co na n a the of and dba fsb bank mortgage lending financial services group "
                 "lp ltd home loans loan".split())


def _d(s):
    try:
        m, dd, y = map(int, s.split("/"))
        return datetime.date(y + (2000 if y < 100 else 0), m, dd)
    except (ValueError, AttributeError):
        return None


def _f(x):
    return x.strftime("%m/%d/%Y") if hasattr(x, "strftime") else str(x)


def _core(name):
    """Distinctive words of a company name (LLC, Inc, Mortgage ... removed) for a loose comparison."""
    w = set(re.findall(r"[a-z0-9]+", str(name or "").lower()))
    core = w - CORP_WORDS
    return core or w


def same_company(a, b):
    ca, cb = _core(a), _core(b)
    return bool(ca & cb) or not ca or not cb


def data_checks(g, r, d):
    """PRP dashboard values vs what the D&C comments state. Returns findings:
    dict(where=<'Title'|'Servicing'|exception name>, check, dcv, prpv, kind='Data Mismatch'|'US Spelling', snip)."""
    out, seen = [], set()
    st, county, city = g(r, "State"), str(g(r, "County") or "").strip(), str(g(r, "City") or "").strip()
    texts = [("Title", d.get("title", "")), ("Servicing", d.get("serv", ""))] + [(x[0], x[2]) for x in d["items"]]

    def add(check, where, dcv, prpv, txt, pos, kind="Data Mismatch"):
        key = (check, where, str(dcv).lower())
        if key in seen:
            return
        # the comment itself documents the variation (and shows the PRP value too): not a copy error
        if kind == "Data Mismatch" and re.search(r"variation|wrong|inconsisten|differ|discrepan|mismatch|incorrect", f"{where} {txt}", re.I) \
                and re.sub(r"\W", "", str(prpv)).lower() in re.sub(r"\W", "", txt).lower() and check not in ("State", "City"):
            return
        seen.add(key)
        s = max(0, pos - 60)
        out.append(dict(where=where, check=check, dcv=str(dcv), prpv=str(prpv), kind=kind,
                        snip=("..." if s else "") + re.sub(r"\s+", " ", txt[s:pos + 110]) + "..."))

    for where, t in texts:
        if not t:
            continue
        # State: full names, "located in XX", and "City, ST 12345" addresses
        for m in STATE_NAME_RE.finditer(t):
            ab = STATE_NAME2AB[m.group(1).lower()]
            street = re.match(r"\s+" + STREET_SFX + r"\b", t[m.end():m.end() + 14])
            ctx = t[max(0, m.start() - 40):m.start()].lower()
            if st and ab != st and not street and not re.search(r"(bank|llc|inc|corp|university|court of|district of)\W*$", ctx):
                add("State", where, m.group(1), st, t, m.start())
        for m in STATE_AB_RE.finditer(t):
            if st and m.group(1) != st:
                add("State", where, m.group(1), st, t, m.start())
        for m in re.finditer(r",\s*([A-Z][A-Za-z .'-]{2,30}),\s*([A-Z]{2})\s+\d{5}", t):
            ci, s2 = m.group(1).strip(), m.group(2)
            if s2 in STATES and st and s2 != st:
                add("State", where, s2, st, t, m.start())
            if city and ci.lower() != city.lower() and s2 == st:
                add("City", where, ci, city, t, m.start())
        # County
        for m in re.finditer(r"\b([A-Z][a-zA-Z\.]+(?:\s[A-Z][a-zA-Z]+)?)\s+County\b", t):
            c = re.sub(r"^(The|In|Of|And)\s+", "", m.group(1))
            if COUNTY_AGENCY_RE.match(t[m.end():m.end() + 22]):
                continue                                   # employer / agency name, not the property county
            if county and c.lower() != county.lower() and county.lower() not in c.lower():
                add("County", where, c + " County", county, t, m.start())
        # Property street number (addresses written in the comment)
        pa = str(g(r, "Address") or "").strip()
        for m in re.finditer(r"\b(\d{1,6})\s+(?:[NSEW]\.?\s+)?[A-Z][A-Za-z]+(?:\s[A-Z][a-z]+){0,3}\s" + STREET_SFX + r"\b", t):
            if pa and re.match(r"\d", pa) and not pa.startswith(m.group(1) + " ") and m.group(1) != pa.split()[0]:
                if city and city.lower() in t[m.end():m.end() + 40].lower():   # same city, different house number
                    add("Property address", where, m.group(0), pa, t, m.start())
        # US spelling (comment text only; exception names come from the exception list)
        for m in UK_RE.finditer(t):
            add("US spelling", where, m.group(1), UK_US[m.group(1).lower()], t, m.start(), kind="US Spelling")
        # Maturity date stated
        for m in re.finditer(r"maturity date (?:of |is |as )?" + DATEPAT, t, re.I):
            pm = g(r, "Subject Mortgage Maturity Date")
            if hasattr(pm, "date") and pm.year > 1900 and _d(m.group(1)) and _d(m.group(1)) != pm.date():
                add("Maturity date", where, m.group(1), _f(pm), t, m.start())
        # Lien position stated for the subject
        for m in re.finditer(r"subject (?:mortgage|lien|loan) is (?:in |a |the )*(first|second|third|1st|2nd|3rd)\b", t, re.I):
            n = {"first": 1, "1st": 1, "second": 2, "2nd": 2, "third": 3, "3rd": 3}[m.group(1).lower()]
            pos = g(r, "Subject Mortgage Lien Position")
            if isinstance(pos, (int, float)) and pos and n != pos:
                add("Lien position", where, m.group(1), int(pos), t, m.start())
        # Assignment of the subject mortgage
        for m in re.finditer(r"assigned to ([A-Z][^.;\n]{3,90}?)(?:,| which| recorded| dated| on \d|\.|$)", t):
            assignees = [g(r, f"AOM{i}_Assignee") for i in range(1, 11)] + [g(r, "Subject Mortgage Last Assignee")]
            assignees = [a for a in assignees if a]
            if assignees and not any(same_company(m.group(1), a) for a in assignees):
                add("Assignee", where, m.group(1).strip(), g(r, "Subject Mortgage Last Assignee") or assignees[-1], t, m.start())
        # Parcel number
        for m in re.finditer(r"\b(?:parcel|APN|PIN|tax (?:parcel )?id)\s*(?:#|number|no\.?|id)?\s*:?\s*([0-9][\w\-\. ]{4,30}?)(?=[,;.)\s](?:\D|$)|$)", t, re.I):
            pp = re.sub(r"\W", "", str(g(r, "Parcel") or "")).lower()
            dv = re.sub(r"\W", "", m.group(1)).lower()
            if pp and dv and dv != pp and dv not in pp and pp not in dv:
                add("Parcel #", where, m.group(1).strip(), g(r, "Parcel"), t, m.start())
    # Deceased borrower
    alltxt = " ".join(x[1] or "" for x in texts)
    m = re.search(r"\b(deceased|death certificate|passed away|date of death)\b", alltxt, re.I)
    if m and str(g(r, "Death of Orig Borrower") or "").upper() not in ("Y", "YES"):
        add("Deceased borrower", "Title", m.group(1), f"Death of Orig Borrower = {g(r, 'Death of Orig Borrower')}", alltxt, m.start())
    # Subject mortgage sentence in the Title column
    t = d.get("title", "")
    m = SUBJ_RE.search(t)
    if m:
        P = lambda k: g(r, k).date() if hasattr(g(r, k), "date") else None
        od, rd = _d(m.group(1)), _d(m.group(2)) if m.group(2) else None
        if od and P("Date Of Mortgage") and od != P("Date Of Mortgage"):
            add("Mortgage date", "Title", m.group(1), _f(P("Date Of Mortgage")), t, m.start())
        if rd and P("Rec Date of Mortgage") and rd != P("Rec Date of Mortgage"):
            add("Recording date", "Title", m.group(2), _f(P("Rec Date of Mortgage")), t, m.start())
        amt = float(m.group("amt").replace(",", ""))
        ob = num(g(r, "Original Loan Amount")) or num(g(r, " Orig Bal"))
        if ob and abs(amt - ob) > 1:
            add("Mortgage amount", "Title", f"${amt:,.2f}", f"${ob:,.2f}", t, m.start())
        mid, tail = m.group("mid") or "", m.group("tail") or ""
        pi = str(g(r, "Subject Mortgage Inst#") or "").strip()
        im = re.search(r"instrument\s*(?:#|no\.?|number)\s*([\w\-]+(?:\s\d+)?)", mid, re.I)
        if re.search(r"instrument\s*(?:#|no\.?|number)\s*(?:in\b|with\b|,|$)", mid, re.I):
            add("Instrument #", "Title", "blank", pi or "blank in PRP", t, m.start())
        elif im and pi and re.sub(r"\D", "", im.group(1)) != re.sub(r"\D", "", pi):
            add("Instrument #", "Title", im.group(1), pi, t, m.start())
        bp = re.search(r"book\s*#?\s*(\w+)\s*,?\s*(?:and\s+)?page\s*#?\s*(\w+)", mid + tail, re.I)
        pb, pg = str(g(r, "Subject Mortgage Book") or "").strip(), str(g(r, "Subject Mortgage Page") or "").strip()
        if bp and pb and (bp.group(1).lstrip("0") != pb.lstrip("0") or (pg and bp.group(2).lstrip("0") != pg.lstrip("0"))):
            add("Book/Page", "Title", f"Book {bp.group(1)} Page {bp.group(2)}", f"Book {pb} Page {pg}", t, m.start())
        # lender / MERS
        lm = re.search(r"\bwith (MERS[^.]*?nominee for )?(.+?)(?:\.\s|\.$|$)", tail.strip(), re.I)
        if lm:
            mers_txt, lender = bool(lm.group(1)), lm.group(2).strip(" .")
            pl = g(r, "Original Lender") or g(r, "Original Beneficiary")
            if pl and lender and not same_company(lender, pl) and not same_company(lender, g(r, "Original Beneficiary")):
                add("Original lender", "Title", lender, pl, t, m.start())
            pm = str(g(r, "Is MERS the original Nominee") or g(r, "MERS") or "").upper()
            if mers_txt and pm in ("N", "NO"):
                add("MERS", "Title", "MERS as nominee", f"Is MERS the original Nominee = {pm}", t, m.start())
            if not mers_txt and pm in ("Y", "YES") and not re.search(r"\bMERS\b", t):
                add("MERS", "Title", "MERS not mentioned", f"Is MERS the original Nominee = {pm}", t, m.start())
    return out

# ---------------------------------------------------------------- writer
COLS = [("Investor Loan ID", "lid"), ("Dashboard Finding", "find"), ("Dash Amount", "damt"),
        ("Exp Lvl", "exp"), ("D&C Exception", "exc"), ("D&C Lvl", "lvl"),
        ("D&C Amount", "camt"), ("Amt Check", "ac"), ("Grade Check", "gc"),
        ("Result", "res"), ("Comment", "com"), ("Exception", "full")]
# compact widths so a sheet fits on one landscape page
WIDTHS = [9, 22, 11, 6, 24, 6, 16, 8, 7, 14, 30, 30]


def style_table(ws, nrows, ncols, top=1):
    for r in range(top, top + nrows + 1):
        for c in range(1, ncols + 1):
            cell = ws.cell(r, c)
            hdr = r == top
            cell.font = Font(name="Calibri", size=10, bold=hdr)
            if hdr:
                cell.fill = GREEN if norm(cell.value) in GREEN_HEADERS else YELLOW
                cell.border = Border(top=THICK, bottom=THICK, left=THICK if c == 1 else THIN,
                                     right=THICK if c == ncols else THIN)
                cell.alignment = Alignment(wrap_text=True, horizontal="center", vertical="center")
            else:
                cell.border = Border(top=THIN, bottom=THIN, left=THIN, right=THIN)
                cell.alignment = Alignment(wrap_text=False, horizontal="center", vertical="center")


TEXT_KEYS = {"exc", "com", "full", "alert", "fcp", "find"}


def write_sheet(wb, name, rows, cols=None, widths=None):
    cols, widths = cols or COLS, widths or WIDTHS
    keys = [k for _, k in cols]
    ws = wb.create_sheet(name[:31])
    for c, (h, _) in enumerate(cols, 1):
        ws.cell(1, c, h)
    for i, row in enumerate(rows, 2):
        for c, k in enumerate(keys, 1):
            ws.cell(i, c, row.get(k))
        if "damt" in keys:
            ws.cell(i, keys.index("damt") + 1).number_format = ACCT
        ws.cell(i, keys.index("res") + 1).fill = (OK_FILL if row["res"] == "No Issue" else
                                                   MANUAL_FILL if row["res"] == "Manual Check" else BAD_FILL)
    style_table(ws, len(rows), len(cols))
    for c, w in enumerate(widths, 1):
        ws.column_dimensions[openpyxl.utils.get_column_letter(c)].width = w
    # keep long text inside its column: a blank cell to the right stops the overflow
    last = len(cols)
    for i in range(2, len(rows) + 2):
        ws.cell(i, last + 1, " ")
        for c, k in enumerate(keys, 1):             # text columns read better left-aligned
            if k in TEXT_KEYS:
                ws.cell(i, c).alignment = Alignment(horizontal="left", vertical="center", wrap_text=False)
    ws.print_area = f"A1:{openpyxl.utils.get_column_letter(last)}{len(rows) + 1}"
    ws.freeze_panes = "B2"
    ws.row_dimensions[1].height = 27
    ws.page_setup.orientation = "landscape"
    ws.page_setup.fitToWidth = 1
    ws.page_setup.fitToHeight = 0
    ws.sheet_properties.pageSetUpPr.fitToPage = True
    ws.print_title_rows = "1:1"
    ws.auto_filter.ref = ws.dimensions


def run(prp, dcp, tmpl, out):
    idx, rows = load_prp(prp)
    g = lambda r, k: r[idx[norm(k)]] if norm(k) in idx else None
    dc = load_dc(dcp)
    tw = openpyxl.load_workbook(tmpl)["Worksheet"]
    superlien = {c.value for c in tw["N"] if c.value}
    checks = build_checks(g, superlien)
    global g_row
    g_row = g

    wb = openpyxl.Workbook()
    summ = wb.active
    summ.title = "Summary"
    results = []

    # ---- PRP vs D&C text consistency and US spelling: shown on the validation row that uses the exception
    findings = {}
    for r in rows:
        lid = int(g(r, "Investor Loan ID"))
        if lid in dc:
            findings[lid] = [dict(f, done=False) for f in data_checks(g, r, dc[lid])]

    def note(f):
        if f["kind"] == "US Spelling":
            return f"US spelling: '{f['dcv']}' should be '{f['prpv']}'"
        return f"Data mismatch ({f['check']}): D&C {f['dcv']} vs PRP {f['prpv']}"

    def attach(name, rs):
        for x in rs:
            for f in findings.get(x["lid"], []):
                if f["done"]:
                    continue
                full = x.get("full") or ""
                if (f["where"] not in ("Title", "Servicing") and f"] {f['where']}:" in full) or \
                        (f["where"] == "Title" and name == "Title Issue Desc" and x.get("code") == "TITLE-EXAM"):
                    f["done"] = True
                    x["com"] = "; ".join(b for b in (x.get("com"), note(f)) if b)
                    if x["res"] in ("No Issue", "Manual Check"):
                        x["res"] = f["kind"]

    def W(wb_, name, rs, *a):
        attach(name, rs)
        write_sheet(wb_, name, rs, *a)
    for chk in checks:
        rs = [evaluate(chk, r, g, dc) for r in rows if chk["trig"](r)]
        W(wb, chk["sheet"], rs)
        results.append((chk["sheet"], rs))
    mr = mod_rows(g, rows, dc)
    W(wb, "Mod Issues", mr)
    results.append(("Mod Issues", mr))
    lf = []
    for lid in sorted(dc):
        for x in dc[lid]["items"]:
            if is_lien_fc(x[0]):
                ok = x[1] == 4
                lf.append(dict(lid=lid, find="Lien started foreclosure", damt=None, exp="L4", exc=f"{x[0]} (Lvl {x[1]})",
                               lvl=f"L{x[1]}", camt=", ".join(f"${a:,.2f}" for a in amounts_in(x[2])[:4]), ac="N/A",
                               gc="Match" if ok else "Mismatch", res="No Issue" if ok else "Grade Issue",
                               com="" if ok else f"Lien FC must be L4, raised L{x[1]}", full=exception_text([x])))
    W(wb, "Lien FC (L4 Rule)", lf)
    results.append(("Lien FC (L4 Rule)", lf))
    ll = lien_level_rows(g, rows, dc, superlien)
    W(wb, "Lien Level", ll)
    results.append(("Lien Level", ll))
    fr = fc_rows(g, rows, dc)
    W(wb, "FC Filed (LP Dates)", fr, FC_COLS, FC_WIDTHS)
    results.append(("FC Filed (LP Dates)", fr))
    tr_ = title_rows(g, rows, dc)
    W(wb, "Title Issue Desc", tr_, TI_COLS, TI_WIDTHS)
    results.append(("Title Issue Desc", tr_))
    br = [dict(lid=lid, find="Exception has no wording", damt=None, exp="", exc=f"{x[0]} (Lvl {x[1]})", lvl=f"L{x[1]}",
               camt="", ac="", gc="", res="Verbiage Issue", com="Blank exception; add the description (excluded from all checks)",
               full=f"* {x[0]} (Lvl {x[1]}) (no description)") for lid in sorted(dc) for x in dc[lid].get("blank", [])]
    W(wb, "Blank Exceptions", br)
    results.append(("Blank Exceptions", br))
    lr = loanref_rows(dc)
    W(wb, "Other Loan Ref", lr)
    results.append(("Other Loan Ref", lr))

    # D&C only: primary exception raised but loan not flagged on that dashboard sheet
    on_sheets = {}
    for name, rs in results:
        if name in ("Lien FC (L4 Rule)", "Other Loan Ref", "Blank Exceptions"):
            continue
        for x in rs:
            if name not in on_sheets.setdefault(x["lid"], []):
                on_sheets[x["lid"]].append(name)
    rows_by_lid = {}
    for name, rs in results:
        if name in ("Lien FC (L4 Rule)", "Other Loan Ref", "Blank Exceptions"):
            continue                                # deal-wide sheet, not a dashboard finding
        for x in rs:
            rows_by_lid.setdefault(x["lid"], []).append(x)
    def dup_note(lid, x):
        """Same amount already raised in another exception used for this loan -> duplicate."""
        amts = set(amounts_in(x[2]))
        for row in rows_by_lid.get(lid, []):
            if amts and any(f"${a:,.2f}" in (row.get("full") or "") for a in amts) and x[0] not in (row.get("full") or ""):
                return f"Same amount also raised as {row['exc'].split(' (Lvl')[0]}; "
        return ""

    def mh_only_note(x):
        if norm(x[0]) not in {norm(e) for e in MH_EXC}:
            return ""
        e, note = mh_grade([x])
        return f"MH level {'OK' if not e or x[1] in e else 'should be L4'} ({note}); "

    only, seen = [], set()
    for chk in checks:
        trig = chk["trig"]
        if chk["sheet"] == "City-Municipal":          # either municipal section counts
            tw_trig = next(c["trig"] for c in checks if c["sheet"] == "Township Search")
            trig = lambda r, a=chk["trig"], b=tw_trig: a(r) or b(r)
        flagged = {int(g(r, "Investor Loan ID")) for r in rows if trig(r)}
        P = {norm(e) for e in chk.get("only", chk["prim"])} - {norm(LOW), norm(MAJ), norm("Missing Title evidence")}
        for lid, d in dc.items():
            for x in d["items"]:
                used = any(x[0] in (row.get("full") or "") for row in rows_by_lid.get(lid, []))
                if norm(x[0]) in P and lid not in flagged and (lid, x[0]) not in seen and not used:
                    seen.add((lid, x[0]))
                    only.append(dict(lid=lid, find=f"Not flagged on {chk['sheet']}", damt=None, exp="",
                                     exc=f"{x[0]} (Lvl {x[1]})", lvl=f"L{x[1]}",
                                     camt=", ".join(f"${a:,.2f}" for a in amounts_in(x[2])[:4]),
                                     ac="", gc="", res="Not on Dashboard",
                                     com=dup_note(lid, x) + mh_only_note(x) + "Dashboard shows Pass/N" + (
                                         f"; loan is on {', '.join(on_sheets.get(lid, []))}" if on_sheets.get(lid) else ""),
                                     full=exception_text([x])))
    W(wb, "D&C Only", only)

    # ---- All Issues: every non-green result from every sheet, one row each, grouped by loan
    order = {name: i for i, (name, _) in enumerate(results + [("D&C Only", only)])}
    allrows = []
    for name, rs in results + [("D&C Only", only)]:
        for x in rs:
            if x["res"] == "No Issue":
                continue
            if name == "FC Filed (LP Dates)":
                find, exc, lvl, exp = f"LP date(s): {x['lp']}", "Foreclosure Comments", "", ""
            elif name == "Title Issue Desc":
                find, exc, lvl, exp = (x['code'] if x['code'] == x['cat'] else f"{x['code']} ({x['cat']})") + f": {x['alert']}", x.get("exc"), x.get("lvl"), x.get("exp")
            else:
                find, exc, lvl, exp = x.get("find"), x.get("exc"), x.get("lvl"), x.get("exp")
                if x.get("damt"):
                    find = f"{find} (${x['damt']:,.2f})"
            allrows.append(dict(sheet=name, lid=x["lid"], find=find, exp=exp, exc=exc, lvl=lvl,
                                res=x["res"], com=x.get("com"), full=x.get("full"), _o=order[name]))
    # findings on exceptions that have no validation sheet (FEMA, disclosures, judgments, Title column ...)
    text_rows = []
    for lid in sorted(findings):
        for f in findings[lid]:
            if not f["done"]:
                text_rows.append(dict(sheet="Text Check", lid=lid, find=f"{f['check']}: D&C {f['dcv']} vs PRP {f['prpv']}"
                                      if f["kind"] == "Data Mismatch" else f"US spelling: {f['dcv']} -> {f['prpv']}",
                                      exp="", exc=f["where"], lvl="", res=f["kind"], com=note(f), full=f["snip"], _o=len(order)))
    allrows += text_rows
    allrows.sort(key=lambda r: (r["lid"], r["_o"]))
    AI_COLS = [("Investor Loan ID", "lid"), ("Sheet", "sheet"), ("Dashboard Finding", "find"), ("Exp Lvl", "exp"),
               ("D&C Exception", "exc"), ("D&C Lvl", "lvl"), ("Result", "res"), ("Comment", "com"),
               ("Exception", "full")]
    write_sheet(wb, "All Issues", allrows, AI_COLS, [9, 15, 28, 6, 26, 6, 16, 36, 36])
    # shade alternate loans so each loan's issues read as one group
    ws_ai = wb["All Issues"]
    band = PatternFill("solid", fgColor="FFF2F2F2")
    prev, shade = None, False
    for i, r_ in enumerate(allrows, 2):
        if r_["lid"] != prev:
            shade, prev = not shade, r_["lid"]
        if shade:
            for c in range(1, len(AI_COLS) + 1):
                if c != 7:
                    ws_ai.cell(i, c).fill = band
    summ.cell(len(results) + 5, 1, "All Issues (every non-green result, grouped by loan)")
    summ.cell(len(results) + 5, 2, len(allrows))

    heads = ["Sheet", "Dashboard Loans", "No Issue", "Amount inconsistent", "Grade inconsistent",
             "Amount & Grade inconsistent", "Exception not raised", "Date / Verbiage Issue", "Data / US Spelling", "Manual Check", "Total Issues"]
    for c, h in enumerate(heads, 1):
        summ.cell(1, c, h)
    tot = [0] * 10
    for i, (name, rs) in enumerate(results, 2):
        cnt = lambda s: sum(1 for x in rs if x["res"] == s)
        vals = [len(rs), cnt("No Issue"), cnt("Amount Issue"), cnt("Grade Issue") + cnt("Verbiage & Grade Issue"),
                cnt("Amt & Grade Issue"), cnt("Not Raised"),
                cnt("Date Missing") + cnt("Verbiage Issue") + cnt("Verbiage & Grade Issue"),
                cnt("Data Mismatch") + cnt("US Spelling"), cnt("Manual Check")]
        vals.append(len(rs) - vals[1] - vals[8])
        summ.cell(i, 1, name)
        for c, v in enumerate(vals, 2):
            summ.cell(i, c, v)
            tot[c - 2] += v
    tr = len(results) + 2
    summ.cell(tr, 1, "Total")
    for c, v in enumerate(tot, 2):
        summ.cell(tr, c, v)
    summ.cell(tr + 2, 1, "D&C Only (exception raised, loan not flagged on dashboard)")
    summ.cell(tr + 2, 2, len(only))
    summ.cell(tr + 4, 1, "Text Check (data mismatch / US spelling on exceptions without a validation sheet)")
    summ.cell(tr + 4, 2, len(text_rows))
    summ.cell(tr + 5, 1, "Data mismatch / US spelling noted on validation rows")
    summ.cell(tr + 5, 2, sum(1 for fl in findings.values() for f in fl if f["done"]))
    style_table(summ, tr - 1, len(heads))
    for c in range(1, len(heads) + 1):
        summ.cell(tr, c).font = Font(name="Calibri", size=10, bold=True)
    summ.column_dimensions["A"].width = 20
    for c in "BCDEFGHIJK":
        summ.column_dimensions[c].width = 14
    wb.save(out)
    return results, only


def deal_name(path):
    """Deal prefix from the input file name, e.g. '561-4884-4887-4880 DC.xlsx' -> '561-4884-4887-4880'."""
    import os
    stem = os.path.splitext(os.path.basename(path))[0]
    return re.sub(r"[\s_\-]*(d\s*&?\s*c|dc)(\s*report)?$", "", stem, flags=re.I).strip(" _-") or stem


if __name__ == "__main__":
    a = sys.argv[1:5]
    if len(a) == 3:                       # output name follows the deal: "<deal>-D&C Validation Report.xlsx"
        import os
        a.append(os.path.join(os.path.dirname(a[1]), f"{deal_name(a[1])}-D&C Validation Report.xlsx"))
        print("Output:", a[3])
    res, only = run(*a)
    for name, rs in res:
        from collections import Counter
        print(f"{name:18} {len(rs):4}  {dict(Counter(x['res'] for x in rs))}")
    print("D&C only:", len(only))
