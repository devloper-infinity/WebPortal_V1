<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="TDSSection.aspx.cs" Inherits="WebPortal.Admin.TDSSection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .table > :not(caption) > * > * {
            padding: .15rem .5rem;
            border-bottom-color: var(--phoenix-input-border-color) !important;
        }
    </style>
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <style>
        #tdsdeduction {
    width: 100%;
    font-size:12px;
    border-collapse: collapse;
}

#tdsdeduction th {
    background: #eaf3f8;
    color: #000;
    font-weight: bold;
    text-transform: uppercase;
    border: 1px solid #cfd8dc;
}

#tdsdeduction td {
    vertical-align: middle;
}

#tdsdeduction td:nth-child(2) {
    text-align: left;
    font-weight: 500;
}

#tdsdeduction .summary-row td {
    background-color: #eaf1f5!important;
    color: #000;
    font-weight: bold;
}

#tdsdeduction .section-gap td {
    height: 12px;
    background: #f8f9fa;
}
    </style>
    <script>

        $(document).ready(function () {
            BindTDSDeduction("New");


        });

     

        var edittable;
        var html;

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        function BindTDSDeduction(slab) {
            let html = '';

            const summaryRows = [
                "Total Salary(Approx)",
                "Balance Salary",
                "Net Taxable Salary",
                "Net Total Income",
                "Gross Total Income",
                "Total Eligible Deductions",
                "Net Taxble Income",
                "Income Tax Liability",
                "Income Tax after rebate u/s 87A",
                "Total Tax Liability",
                "BalancePayble"
            ];

            $.ajax({
                url: "TDSSection.aspx/GetDeductionDetails",
                type: "POST",
                data: JSON.stringify({ TaxSlab: slab }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {
                    const dataArray = JSON.parse(data.d);

                    $.each(dataArray, function (index, value) {
                        const desc = blankForNull(value.Description);
                        const rowClass = summaryRows.includes(desc) ? 'summary-row' : '';

                        html += `
                    <tr class="${rowClass}">
                        <td>${desc}</td>
                        <td>${blankForNull(value.Value)}</td>
                        <td>${blankForNull(value.Details)}</td>
                    </tr>`;
                    });

                    if ($.fn.dataTable.isDataTable('#tdsdeduction')) {
                        $('#tdsdeduction').DataTable().destroy();
                    }

                    $('#tdsdeduction tbody').html(html);

                    edittable = $('#tdsdeduction').DataTable({
                        dom: 'rt',
                        scrollX: true,
                        destroy: true,
                        paging: false,
                        searching: false,
                        ordering: false,
                        info: false,
                        autoWidth: false,
                        processing: true,
                        initComplete: function () {
                            $('#load1').hide();
                        }
                    });
                },

                error: function (error) {
                    alert('error: ' + error.responseText);
                }
            });
        }

      
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>TDS Deduction</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" id="tdsdeduction" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="background-color: cornflowerblue; color: white;">Description</th>
                            <th class="sort border-top" style="background-color: cornflowerblue; color: white;">Value</th>
                            <th class="sort border-top" style="background-color: cornflowerblue; color: white;">Details</th>
                        </tr>
                    </thead>
                    <tbody></tbody>

                </table>
                <div class="card card-tabs" style="display: none;">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Declaration</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Deduction</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Category:</b></td>
                                        <td>
                                            <select id="category" name="category" class="form-control" style="width: 250px;" onchange="getdocuments();">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Document Name:</b></td>
                                        <td>
                                            <select id="documentname" name="documentname" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Document Type:</b></td>
                                        <td>
                                            <select id="doctype" name="doctype" class="form-control" style="width: 250px;" onchange="DocTypeValidation()">
                                                <option value="">Select</option>
                                                <option value="Provisional">Provisional</option>
                                                <option value="Original">Original</option>
                                            </select>

                                            <%--  <asp:RequiredFieldValidator ID="rfvDocType" runat="server" ControlToValidate="ddlDocType" Style="color: Red;"
                                ErrorMessage="Please Select Document Type." InitialValue="Select" SetFocusOnError="true" ValidationGroup="user" Font-Size="12px" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr id="trDocumentNo" style="display: none;">
                                        <td><b>Document No:</b></td>
                                        <td>
                                            <input type="text" id="documentno" name="documentno" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Document Amount:</b></td>
                                        <td>
                                            <input type="number" id="documentamount" name="documentamount" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr id="trOrgDate" style="display: none;">
                                        <td><b>Original Document Submission Date:</b></td>
                                        <td>
                                            <input type="date" id="originaldocumentdate" name="originaldocumentdate" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Document Date:</b></td>
                                        <td>
                                            <input type="date" id="documentdate" name="documentdate" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="attachment" name="attachment" class="form-control" style="width: 250px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">

                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                                        <div class="dropdown font-sans-serif">
                                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Remark:</b></td>
                                        <td>
                                            <textarea id="remark" name="remark" class="form-control" style="width: 250px;"></textarea>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <button id="btnSubmit" class="btn btn-primary">Submit</button>

                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table table-responsive">
                                    <tr>
                                        <td style="width: 100px!important;"><b>Tax Slab:</b></td>
                                        <td style="width: 200px!important;">
                                            <select id="taxslab" name="taxslab" class="form-control" style="width: 150px;">
                                                <option value="">Select</option>
                                                <option value="Old">Old Tax Slab</option>
                                                <option value="New">New Tax Slab</option>
                                            </select>

                                        </td>
                                        <td>
                                            <button id="btnsubmit" class="btn btn-primary" onclick="submitdata();">Submit</button>

                                        </td>
                                    </tr>
                                </table>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
