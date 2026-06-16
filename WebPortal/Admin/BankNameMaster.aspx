<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BankNameMaster.aspx.cs" Inherits="WebPortal.Admin.BankNameMaster" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            bank_Binddata();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .bank-page {
            background: white;
            /* padding: 0 12px 24px;*/
        }

        .bank-header-card {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .bank-header-card:after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .bank-header-icon {
            width: 50px;
            height: 50px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.18);
            margin-right: 14px;
        }

        .bank-shell-card {
            background: white;
            border: 0;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
        }

        .bank-form-panel {
            border: 1px solid #e9eef5;
            border-radius: 16px;
            background: #f8fafc;
            padding: 18px;
        }

        .bank-form-label {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 8px;
        }

        .bank-input {
            min-height: 42px;
            border-radius: 10px;
            border-color: #d9e2ec;
        }

            .bank-input:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.12);
            }

        .bank-submit-btn {
            min-height: 42px;
            border-radius: 10px;
            font-weight: 700;
            padding-left: 24px;
            padding-right: 24px;
            box-shadow: 0 8px 18px rgba(13, 110, 253, 0.22);
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;
        }

        .bank-table-wrap {
            border: 1px solid #e9eef5;
            border-radius: 16px;
            overflow: hidden;
        }

        #bank_table {
            margin-bottom: 0;
        }

            #bank_table thead th {
                background: #f1f5f9;
                color: #475569;
                font-size: 12px;
                letter-spacing: 0.04em;
                text-transform: uppercase;
                border-bottom: 1px solid #e2e8f0;
                padding-top: 14px;
                padding-bottom: 14px;
                white-space: nowrap;
            }

            #bank_table tbody td {
                vertical-align: middle;
                padding-top: 13px;
                padding-bottom: 13px;
                color: #334155;
            }

        .loading {
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            background: rgba(255, 255, 255, 0.78);
            backdrop-filter: blur(3px);
            color: #334155;
        }

            .loading img {
                width: 52px;
                height: 52px;
                margin-bottom: 10px;
            }

        .bank-modal-content {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.20);
        }

        .bank-modal-header {
            border-bottom: 1px solid #edf2f7;
            padding: 18px 20px;
        }

        .bank-modal-footer {
            border-top: 0;
            justify-content: center;
            padding-bottom: 20px;
        }

        @media (max-width: 767.98px) {
            .bank-page {
                padding-left: 0;
                padding-right: 0;
            }

            .bank-form-panel {
                padding: 14px;
            }

            .bank-submit-btn {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="container-fluid">
        <div class="card bank-header-card mb-4">
            <div class="card-body d-flex align-items-center justify-content-between flex-wrap">
                <div class="d-flex align-items-center">
                    <span class="bank-header-icon"><i style="font-size:30px;" class="fas fa-university"></i></span>
                    <div>
                        <h4 class="mb-1 font-weight-bold">Bank Name Master</h4>
                        <div class="small" style="opacity: .88;">Add and manage bank names from one place</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card bank-shell-card" style="background: white;">
        <div class="card-body p-3 p-md-4">
            <div class="bank-form-panel mb-4">
                <div class="row align-items-end">
                    <div class="col-lg-6 col-md-8 mb-3 mb-md-0">
                        <label for="bank_name" class="bank-form-label">Bank Name</label>
                        <input type="text" id="bank_name" name="bank_name" class="form-control bank-input" placeholder="Enter bank name" required />
                    </div>
                    <div class="col-lg-3 col-md-4">
                        <button id="bank_btnSubmit" class="btn btn-primary bank-submit-btn" onclick="return bank_submit();">
                            <i class="fas fa-save mr-1"></i>Submit
                               
                        </button>
                    </div>
                </div>
            </div>

            <div class="d-flex align-items-center justify-content-between flex-wrap mb-3">
                <div>
                    <h5 class="mb-1 font-weight-bold">Bank List</h5>
                    <div class="text-muted small">Recently added bank records appear below.</div>
                </div>
            </div>

            <div class="table-responsive bank-table-wrap">
                <table class="table table-hover" id="bank_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort ps-3 text-center" style="width: 90px;">Sr. #</th>
                            <th class="sort ps-3">Bank Name</th>
                            <th class="sort ps-3">Added By</th>
                            <th class="sort ps-3">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="bank_dverror" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content bank-modal-content">
                <div class="modal-header bank-modal-header">
                    <h6 class="modal-title font-weight-bold" id="bank_errmsg"></h6>
                </div>
                <div class="modal-footer bank-modal-footer">
                    <button class="btn btn-primary bank-submit-btn" type="button" id="bank_btnMessage" onclick="return bank_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
