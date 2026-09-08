<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="DownloadForm16.aspx.cs" Inherits="WebPortal.Salary.DownloadForm16" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --f16-primary: #2457e6;
            --f16-accent: #25bfd4;
            --f16-bg: #f4f7fb;
            --f16-card: #ffffff;
            --f16-text: #172033;
            --f16-muted: #68738a;
            --f16-border: #dfe6f1;
            --f16-shadow: 0 14px 35px rgba(31, 51, 94, .10);
        }

        .f16-page {
            background: var(--f16-bg);
            min-height: calc(100vh - 110px);
            padding: 18px;
        }

        .f16-container {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .f16-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
            padding: 22px 24px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 15px 36px rgba(37, 99, 235, .22);
        }

        .f16-hero::after {
            content: "";
            position: absolute;
            right: -65px;
            top: -85px;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .12);
        }

        .f16-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .f16-hero-icon {
            width: 52px;
            height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 52px;
            border-radius: 15px;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            font-size: 23px;
        }

        .f16-hero h1 {
            margin: 0 0 4px;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 700;
        }

        .f16-hero p {
            margin: 0;
            font-size: 13px;
            color: rgba(255, 255, 255, .88);
        }

        .f16-hero-chip {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            white-space: nowrap;
            padding: 8px 13px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .28);
            font-size: 12px;
            font-weight: 600;
        }

        .f16-section {
            background: var(--f16-card);
            border: 1px solid var(--f16-border);
            border-radius: 17px;
            box-shadow: var(--f16-shadow);
            overflow: hidden;
        }

        .f16-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 15px 18px;
            border-bottom: 1px solid var(--f16-border);
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .f16-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--f16-text);
            font-size: 14px;
            font-weight: 700;
        }

        .f16-section-title .icon-box {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            color: var(--f16-primary);
            background: #eaf0ff;
        }

        .f16-section-note {
            margin: 0;
            color: var(--f16-muted);
            font-size: 11px;
        }

        .f16-section-body {
            padding: 22px 18px;
        }

        .f16-form-row {
            display: grid;
            grid-template-columns: minmax(280px, 520px) auto;
            gap: 14px;
            align-items: end;
        }

        .f16-field label {
            display: block;
            margin-bottom: 7px;
            color: #34405a;
            font-size: 12px;
            font-weight: 700;
        }

        .f16-field .form-control {
            width: 100%;
            height: 42px;
            border: 1px solid #d5deeb;
            border-radius: 10px;
            background: #fff;
            color: var(--f16-text);
            font-size: 13px;
            box-shadow: none;
        }

        .f16-field .form-control:focus {
            border-color: var(--f16-primary);
            box-shadow: 0 0 0 3px rgba(36, 87, 230, .10);
        }

        .f16-btn-download {
            min-width: 150px;
            min-height: 42px;
            padding: 0 22px;
            border: 0;
            border-radius: 10px;
            color: #fff;
            font-weight: 700;
            background: linear-gradient(120deg, var(--f16-primary) 0%, var(--f16-accent) 100%);
            box-shadow: 0 10px 22px rgba(36, 87, 230, .22);
            transition: transform .2s ease, box-shadow .2s ease, opacity .2s ease;
        }

        .f16-btn-download:hover {
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 12px 24px rgba(31, 51, 94, .18);
        }

        .f16-btn-download:disabled {
            opacity: .65;
            cursor: not-allowed;
            transform: none;
        }

        @media (max-width: 767px) {
            .f16-page { padding: 12px; }
            .f16-hero { padding: 18px; }
            .f16-hero-chip { display: none; }
            .f16-form-row { grid-template-columns: 1fr; }
            .f16-btn-download { width: 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="f16-page">
        <div class="f16-container">
            <div class="f16-hero">
                <div class="f16-hero-content">
                    <div class="f16-hero-icon"><i class="fas fa-file-pdf"></i></div>
                    <div>
                        <h1>Download Form 16</h1>
                        <p>Select an employee to download the available Form 16 PDF.</p>
                    </div>
                </div>
                <div class="f16-hero-chip"><i class="fas fa-shield-alt"></i> Employee Documents</div>
            </div>

            <section class="f16-section">
                <div class="f16-section-header">
                    <h2 class="f16-section-title">
                        <span class="icon-box"><i class="fas fa-download"></i></span>
                        Form 16 Download
                    </h2>
                    <p class="f16-section-note">PDF is matched using employee PAN</p>
                </div>
                <div class="f16-section-body">
                    <div class="f16-form-row">
                        <div class="f16-field">
                            <label for="f16_employee">Employee</label>
                            <select id="f16_employee" class="form-control">
                                <option value="">Select Employee</option>
                            </select>
                        </div>
                        <div>
                            <button type="button" id="f16_btndownload" class="f16-btn-download" onclick="return f16_download();">
                                <i class="fas fa-download mr-1"></i> Download
                            </button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <div class="modal fade" id="f16_messageModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Download Form 16</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body" id="f16_message"></div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            f16_loadEmployees();
        });

        function f16_loadEmployees() {
            $.ajax({
                type: 'POST',
                url: 'DownloadForm16.aspx/GetEmployees',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: '{}',
                success: function (response) {
                    var rows = JSON.parse(response.d || '[]');
                    var $ddl = $('#f16_employee');
                    $ddl.empty().append($('<option/>').val('').text('Select Employee'));

                    $.each(rows, function (_, item) {
                        $ddl.append($('<option/>').val(item.EmployeeID).text(item.EmpName));
                    });
                },
                error: function () {
                    f16_showMessage('Unable to load employees. Please try again.');
                }
            });
        }

        function f16_download() {
            var employeeId = $('#f16_employee').val();
            if (!employeeId) {
                f16_showMessage('Please select an employee.');
                return false;
            }

            var $btn = $('#f16_btndownload');
            $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-1"></i> Checking...');

            $.ajax({
                type: 'POST',
                url: 'DownloadForm16.aspx/GetDownloadStatus',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({ employeeId: parseInt(employeeId, 10) }),
                success: function (response) {
                    var result = response.d;
                    if (result && result.Success) {
                        window.location.href = 'DownloadForm16.aspx?action=download&employeeId=' + encodeURIComponent(employeeId);
                        $('#f16_employee').val('');
                    } else {
                        f16_showMessage(result && result.Message ? result.Message : 'Your Form 16 is not available in system please contact Account Department.');
                    }
                },
                error: function () {
                    f16_showMessage('Unable to process the request. Please try again.');
                },
                complete: function () {
                    $btn.prop('disabled', false).html('<i class="fas fa-download mr-1"></i> Download');
                }
            });

            return false;
        }

        function f16_showMessage(message) {
            $('#f16_message').text(message);
            $('#f16_messageModal').modal('show');
        }
    </script>
</asp:Content>
