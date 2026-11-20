<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HousekeepingShell.ascx.cs" Inherits="WebPortal.Admin.HousekeepingShell" %>
<div id="hkApp" class="hk-app" data-module="<%= System.IO.Path.GetFileNameWithoutExtension(Request.Path) %>">
  <header class="hk-hero"><div><div class="hk-eyebrow">OPERATIONS MANAGEMENT</div><h1 id="hkTitle">Housekeeping</h1><p>Attendance, cleaning work, quality checks, inventory and performance in one place.</p></div><a class="hk-button hk-button-light" href="HousekeepingDashboard.aspx">Dashboard</a></header>
  <nav id="hkNav" class="hk-nav" aria-label="Housekeeping modules"></nav>
  <section id="hkFilters" class="hk-card hk-filters" hidden></section>
  <section id="hkKpis" class="hk-kpis" hidden></section>
  <section id="hkEditor" class="hk-card" hidden><h2 id="hkEditorTitle">New record</h2><form id="hkForm" class="hk-form" novalidate></form><div class="hk-form-actions"><button type="button" class="hk-button hk-button-muted" id="hkReset">Clear</button><button type="submit" form="hkForm" class="hk-button" id="hkSave">Save</button></div></section>
  <section class="hk-card"><div class="hk-table-heading"><div><h2 id="hkTableTitle">Records</h2><p id="hkTableHint"></p></div><button type="button" class="hk-button" id="hkNew">New record</button></div><div class="table-responsive"><table id="hkTable" class="table table-striped table-hover hk-table"><thead></thead><tbody></tbody></table></div></section>
  <div id="hkChartGrid" class="hk-chart-grid"></div>
</div>
