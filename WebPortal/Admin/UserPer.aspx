<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPer.aspx.cs" Inherits="WebPortal.Admin.UserPer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        /* CARD */
        .premium-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }

        /* FILTER BAR */
        .filter-bar {
            background: #f8fafc;
            padding: 20px;
            border-radius: 12px;
        }

        /* INPUT */
        .premium-input {
            border-radius: 10px;
            border: 1px solid #ddd;
            transition: 0.3s;
        }

            .premium-input:focus {
                border-color: #6366f1;
                box-shadow: 0 0 0 2px rgba(99,102,241,0.2);
            }

        /* BUTTON */
        .btn-gradient {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 8px 18px;
            transition: 0.3s;
        }

            .btn-gradient:hover {
                transform: translateY(-1px);
                box-shadow: 0 5px 15px rgba(99,102,241,0.4);
            }

        /* TABS */
        .premium-tabs .nav-link,
        .premium-subtabs .nav-link {
            border-radius: 20px;
            padding: 6px 16px;
            margin-right: 5px;
            color: #555;
        }

            .premium-tabs .nav-link.active,
            .premium-subtabs .nav-link.active {
                background: #6366f1;
                color: #fff;
            }

        /* TABLE */
        .premium-table thead {
            background: #f1f5f9;
            position: sticky;
            top: 0;
            z-index: 2;
        }

        .premium-table th {
            font-weight: 600;
            white-space: nowrap;
        }

        .premium-table tbody tr:hover {
            background-color: #f9fafb;
        }

        /* SCROLL */
        .premium-table-wrapper {
            max-height: 500px;
            overflow: auto;
        }
    </style>

    <script>
        
    $(document).on("click", "#btnShow", function() {
        handleShowClick();
    });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="col-lg-12">
        <div class="card premium-card">
            <div class="card-body">




                <!-- 🔷 HEADER -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold mb-0">HR Performance Dashboard</h4>
                    <span class="badge bg-light text-dark px-3 py-2">Live Report</span>
                </div>

                <!-- 🔷 FILTER BAR -->
                <div class="filter-bar">

                    <div class="row g-3 align-items-end">

                        <div class="col-md-3">
                            <label class="form-label">From Date</label>
                            <input type="date" id="hrUser_fromDate" class="form-control premium-input">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">To Date</label>
                            <input type="date" id="hrUser_toDate" class="form-control premium-input">
                        </div>

                        <div class="col-md-6 text-end">
                            <button class="btn btn-gradient me-2" onclick="handleShowClick()">
                                🔍 Show Data
                            </button>

                            <button class="btn btn-outline-success" onclick="exportAllToExcel()">
                                ⬇ Export All
                            </button>
                        </div>

                    </div>
                </div>

                <!-- 🔷 MAIN TABS -->
                <ul class="nav nav-pills premium-tabs mt-4">
                    <li class="nav-item">
                        <a class="nav-link active mainTab" data-type="nondd">Non-DD</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mainTab" data-type="credit">Credit</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mainTab" data-type="servicing">Servicing</a>
                    </li>
                </ul>

                <!-- 🔷 SUB TABS -->
                <ul class="nav nav-pills premium-subtabs mt-2">
                    <li class="nav-item"><a class="nav-link active subTab" data-tab="summary">Summary</a></li>
                    <li class="nav-item"><a class="nav-link subTab" data-tab="production">Production</a></li>
                    <li class="nav-item"><a class="nav-link subTab" data-tab="feedback">Feedback</a></li>
                    <li class="nav-item"><a class="nav-link subTab" data-tab="attendance">Attendance</a></li>
                </ul>

                <!-- 🔷 ACTION BAR -->
                <div class="d-flex justify-content-between mt-4 mb-2">
                    <button class="btn btn-light btn-sm" onclick="toggleColumns()">⚙ Columns</button>
                    <button class="btn btn-light btn-sm" onclick="exportTableToExcel()">📊 Export Table</button>
                </div>

                <!-- 🔷 LOADER -->
                <div id="loader" class="text-center py-4" style="display: none;">
                    <div class="spinner-border text-primary"></div>
                </div>

                <!-- 🔷 TABLE -->
                <div class="table-responsive premium-table-wrapper">
                    <%--      
                <table id="testTable" class="table">
    <thead>
        <tr>
            <th>Month</th>
            <th>Year</th>
        </tr>
    </thead>
</table>--%>

                    <table id="dynamicTable" class="table premium-table">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <!-- Buttons -->
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css">
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.colVis.min.js"></script>
</asp:Content>
