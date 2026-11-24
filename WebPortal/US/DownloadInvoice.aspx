<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="DownloadInvoice.aspx.cs" Inherits="WebPortal.US.DownloadInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script src="https://cloudflare.com" type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js" integrity="sha512-GsLlZN/3F2ErC5ifS5QtgpiJtWd43JWSuIgh7mbzZ8zBps+dvLusV+eNQATqgA/HdeKFVgA5v3S/cIrLF7QnIg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="../Scripts/US/DownloadInvoice.js" type="text/javascript"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
     <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.bundle.js"></script>
<script src="<%= ResolveUrl("~/plugins/sweetalert2/sweetalert2.all.min.js") %>"></script>
        <style>
            .ud-hero {
                position: relative;
                overflow: hidden;
                display: flex;
                align-items: center;
                gap: 18px;
                padding: 22px 28px;
                border-radius: 22px;
                color: #fff;
                background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
                box-shadow: var(--ud-shadow);
                margin-bottom: 20px;
            }

            .ud-hero:before,
            .ud-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .ud-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .ud-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .ud-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .ud-hero-content {
            position: relative;
            z-index: 1;
        }

        .ud-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .ud-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            opacity: .9;
            margin-right: 550px;
        }

        .ud-timezone-pill {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            min-width: 184px;
            padding: 10px 14px;
            border: 1px solid rgba(255, 255, 255, .28);
            border-radius: 999px;
            background: rgba(255, 255, 255, .14);
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
            backdrop-filter: blur(8px);
        }

        .card-header, .box-header, .modal-header {
            background: linear-gradient(271deg, #143961 0%, #0d67cd 100%) !important;
            border-bottom: 1px solid var(--dash-border) !important;
            color: var(--dash-text) !important;
            border-radius: 18px 18px 0 0 !important;
        }

        #osdlBreakModal .modal-title, #osdlBreakModal .card-title {
            color: #ffffff !important;
            font-weight: 700 !important;
            font-size: 17px !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }


        .card-title, .modal-title, .card-header h5, .card-header h3 {
    color: white;
    font-weight: 800 !important;
    letter-spacing: .1px;
}
    </style>
    <script>
    $(document).ready(function () {
        GetAllLogInOutDatafordownInvoice();
    });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="loading" id="load1">
        <div class="loading-card">
            <img src="../images/Load_1.gif" alt="Loading" />
            <span>One moment, please</span>
        </div>
    </div>
    <div class="daily-login-page">
        <section class="ud-hero">
            <div class="ud-hero-icon"><i class="fa-solid fa-download"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">Download Invoice</h1>
                <p class="ud-subtitle">View and download Invoices, Logs Details, Non-Productive Hour Details, and Production Details.</p>
            </div>
           
        </section>
        <div class="card daily-login-card">
            <div class="card-body" id="downloadinvoice">
    
    <section class="table-section">
       
        <div class="table-responsive">
            <table class="table table-hover" id="downloadinvoice_table">
                <thead>
                    <tr>
                      
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </section>
</div>
        </div>
    </div>

<!-- Invoice View Modal -->
<div class="modal fade" id="invoiceModal" tabindex="-1" aria-labelledby="invoiceModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl" style="max-width: 75%; width: 75%;">
    <div class="modal-content" style="border-radius: 4px; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
      <div class="modal-header bg-light border-bottom-0 py-2">
       <button type="button" class="btn p-0 ms-auto" data-bs-dismiss="modal" aria-label="Close" style="background: transparent; border: none; color: #dc3545; font-size: 26px; font-weight: bold; line-height: 1;">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
            <div class="modal-body px-5 pb-5 pt-2" style="font-family: Arial, sans-serif; color: #333; max-height: 80vh; overflow-y: auto;">
        
        <!-- ==================== PART 1: INVOICE SECTION ==================== -->
        <div class="row mb-5">
          <div class="col-6">
            <h4 id="modalVendorName" style="font-weight: bold; margin-bottom: 2px;">RJOstrom LLC</h4>
           <div id="modalVendorAddress" style="font-size: 14px; line-height: 1.4; color: #444;">
             <br>
            <br>
            
          </div>
              <div style="font-size: 14px; line-height: 1.4; color: #444; margin-top: 4px;">
            Phone: <span id="modalVendorPhone">612-358-0115</span><br>
            Email: <a href="mailto:rjostromllc@gmail.com" id="modalVendorEmailLink" style="color: #0d6efd; text-decoration: none;"><span id="modalVendorEmail">rjostromllc@gmail.com</span></a>
          </div>
          </div>
          <div class="col-6 text-end d-flex flex-column align-items-end justify-content-between">
            <h1 style="font-size: 36px; font-weight: bold; color: #5b73a7; letter-spacing: 1px; margin-bottom: 20px;">INVOICE</h1>
            
            <table class="table table-bordered text-center mb-0" style="width: 250px; font-size: 13px;">
              <thead style="background-color: #d9e1f2; color: #000; font-weight: bold;">
                <tr>
                  <th class="py-1" style="border-color: #b4c6e7;">INVOICE #</th>
                  <th class="py-1" style="border-color: #b4c6e7;">DATE</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="py-1" style="border-color: #b4c6e7;" id="modalInvoiceNo">1</td>
                  <td class="py-1" style="border-color: #b4c6e7;" id="modalInvoiceDate">10/16/2026</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="row mb-5">
          <div class="col-6">
            <table class="table table-bordered mb-0" style="font-size: 14px;">
              <thead style="background-color: #d9e1f2; color: #000; font-weight: bold;">
                <tr>
                  <th class="py-1" style="border-color: #b4c6e7;">BILL TO</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="py-2 px-3" style="border-color: #b4c6e7; line-height: 1.5;">
                    <strong id="modalClientName">Infinity IPS</strong><br>
                    1 Research Court, Suite 450<br>
                    Rockville, MD 20850<br>
                    Phone: (877)-463-8485
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <table class="table table-bordered mb-4" style="font-size: 14px; border-color: #b4c6e7;">
          <thead style="background-color: #d9e1f2; color: #000; font-weight: bold;">
            <tr>
              <th class="py-2 px-3" style="width: 75%; border-color: #b4c6e7;">DESCRIPTION</th>
              <th class="py-2 px-3 text-end" style="width: 25%; border-color: #b4c6e7;">AMOUNT</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="p-3" style="height: 120px; vertical-align: top; border-color: #b4c6e7; line-height: 1.6;">
                Hours: <strong id="modalHours"></strong> <span style="background-color: #ffff00; padding: 2px 4px;">Hours worked</span> hours at $<span id="modalRate">35.00</span> hr.<br>
                Period: <strong id="modalPeriod">10/01/2026 To 10/15/2026</strong><br><br><br><br><br>
                <strong>Please provide payment within our agreed upon contract period, thank you!</strong><br>
                See 1099 Tracker and Feedback Worksheets for productivity details
              </td>
            <td class="p-3 text-end" style="vertical-align: top; font-weight: bold; border-color: #b4c6e7; font-size: 16px;" id="modalAmount">
        $0.00
      </td>
            </tr>
            <tr class="total-row">
                <td class="text-center">Thank you for your business!</td>
<td class="text-left" style="vertical-align: top; font-weight: bold; border-color: #b4c6e7; font-size: 16px;" id="modalTotalAmount">$0.00</td>            </tr>
            <tr class="total-row">
                <td colspan="2"><small>If you have any questions about this invoice, please contact me.</small></td>
            </tr>
          </tbody>
        </table>

        <!-- Divider line -->
        <hr class="my-5" style="border-top: 2px dashed #b4c6e7;">

        <!-- ==================== PART 2: DAILY LOG DETAILS TABLE ==================== -->
        <div id="tabDetailsContent">
           <div class="d-flex justify-content-between align-items-center mb-3 p-3 rounded" style="background-color: #143961">
    <h6 class="mb-0 text-white"><i class="fas fa-calendar-alt text-info"></i> Daily Log-In/Out (<span id="modalEmpNameSpan"></span>)</h6>
</div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered text-center" id="modalDetailedTable" style="font-size: 13px;">
                    <thead style="background-color: #143961; color: white;">
                        <tr>
                            <th>Date</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Break Time</th>
                            <th>Total Time</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
<hr class="my-5" id="nonProductiveDivider" style="border-top: 2px dashed #b4c6e7; display: none;">
                <!-- ==================== PART 2.5: NON-PRODUCTIVE HOURS TABLE ==================== -->
        <div id="tabNonProductiveContent" style="display: none;">
           <div class="d-flex justify-content-between align-items-center mb-3 p-3 rounded" style="background-color: #143961">
              <h6 class="mb-0 text-white"><i class="fas fa-clock text-info"></i> Non-Productive Hours</h6>
           </div>
           <div class="table-responsive">
               <table class="table table-striped table-bordered text-center" id="modalNonProductiveTable" style="font-size: 13px;">
                   <thead style="background-color: #143961; color: white;">
                       <tr>
                           <th>Entry Date</th>
                           <th>Start Time</th>
                           <th>End Time</th>
                           <th>Total Duration</th>
                           <th>Reason</th>
                       </tr>
                   </thead>
                   <tbody>
                   </tbody>
               </table>
           </div>
        </div>



                  <!-- Divider line -->
        <hr class="my-5" style="border-top: 2px dashed #b4c6e7;">

        <!-- ==================== PART 3: Production Track DETAILS TABLE ==================== -->
        <div id="tabUSLoanProductionTrackContent">
           <div class="d-flex justify-content-between align-items-center mb-3 p-3 rounded" style="background-color: #143961">
    <h6 class="mb-0 text-white"><i class="fas fa-chart-line text-info"></i> Production Track</h6>
</div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered text-center" id="LoanProductionTrackTable" style="font-size: 13px;">
                    <thead style="background-color: #143961; color: white;">
                        <tr>
                         
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
      </div>
    </div>
  </div>
</div>

</asp:Content>
