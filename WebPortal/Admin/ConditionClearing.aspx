<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ConditionClearing.aspx.cs" Inherits="WebPortal.Admin.ConditionClearing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .main-container {
            width: 100%;
            padding: 15px 25px;
        }

        /* Custom Grid */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
            width: 100%;
        }

        .my-col-4 {
            width: 33.33%;
            padding-right: 15px;
        }

        .my-col-12 {
            width: 100%;
        }

        .my-input:focus, .my-select:focus {
            border-color: #b5d3ff;
            box-shadow: 0 0 4px rgba(181, 211, 255, 0.6);
            outline: none;
        }
        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 34px;
            border: 1px solid #dcdcdc;
            padding: 6px;
            border-radius: 5px;
            font-size: 12px;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        textarea.my-input {
            height: 70px;
            resize: none;
        }

        label {
            font-size: 12px;
            margin-bottom: 4px;
            display: block;
        }

        .my-btn {
            padding: 6px 18px;
            border-radius: 4px;
            border: none;
            color: #fff;
            font-size: 14px;
            margin-right: 8px;
        }

        .primary {
            background: #2f7ed8;
        }

        .success {
            background: #28a745;
        }

        .warning {
            background: #f0ad4e;
        }

        .my-btn:hover {
            opacity: 0.9;
        }

        .req {
            color: red;
            font-weight: bold;
            margin-left: 3px;
        }


        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
        }
    </style>

    <style>
        .custom-dropdown {
            position: relative;
            width: 200px;
            font-family: Arial, sans-serif;
        }

        .selected {
            border: 1px solid #ccc;
            padding: 8px;
            cursor: pointer;
            user-select: none;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            border: 1px solid #ccc;
            border-top: none;
            background: #fff;
            max-height: 200px;
            overflow-y: auto;
            z-index: 10;
        }

            .dropdown-menu.hidden {
                display: none;
            }

        .search-box {
            width: 100%;
            box-sizing: border-box;
            padding: 6px 8px;
            border: none;
            border-bottom: 1px solid #ccc;
        }

        .options div {
            padding: 8px;
            cursor: pointer;
        }

            .options div:hover {
                background-color: #eee;
            }

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
    </style>

    <script>

        $(document).ready(function () {

            bindProjects();
            condclearing_bindGrid();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add New Condition</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="main-container">

                    <!-- Row 1 -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Project # <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_project" onchange="bindDeals(this);"></select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Deal # <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_dealNo" onchange="bindLoans(this);"></select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Loan # <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_loanNo"></select>
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Received Date <span class="req">*</span></b></label>
                            <input type="date" class="my-input" id="concl_receiveddate">
                        </div>

                        <div class="my-col-4">
                            <label><b>Initial Exception Grade <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_expgrade">
                                <option value="">Select Grade</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Process <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_process">
                                <option value="">Select Process</option>
                                <option value="Loan Setup">Loan Setup</option>
                                <option value="Credit">Credit</option>
                                <option value="Compliance">Compliance</option>
                            </select>
                        </div>
                    </div>

                    <!-- Row 3 -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Infinity Condition <span class="req">*</span></b></label>
                            <textarea class="my-input" id="concl_infcondition"></textarea>
                        </div>
                    </div>

                    <!-- Row 4 -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Clients Rebuttal <span class="req">*</span></b></label>
                            <textarea class="my-input" id="concl_rebuttal"></textarea>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <button class="my-btn primary" onclick="return concl_SaveData();">Add</button>
                            <%-- <button class="my-btn success">Export to Excel</button>
                            <button class="my-btn success">Import Data</button>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table" id="table_condclear" style="width: 100%;">
                    <thead>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

</asp:Content>
