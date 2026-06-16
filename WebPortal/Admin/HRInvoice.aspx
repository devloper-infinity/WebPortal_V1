<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRInvoice.aspx.cs" Inherits="WebPortal.Admin.HRInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

    <style>
        /* Common container styling */
        .form-container {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            background-color: white;
        }

            .form-container .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 3px 25px; /* row-gap column-gap */
            }

            .form-container .form-group {
                display: flex;
                flex-direction: column; /* label above input */
            }

                /* Labels */
                .form-container .form-group label {
                    /*  font-weight: 600;*/
                    margin-bottom: 6px;
                    color: #6c757d;
                    font-weight: normal;
                }

                /* Inputs, selects, textareas */
                .form-container .form-group .form-control {
                    width: 100%;
                    border-radius: 8px;
                    border: 1px solid #ced4da;
                    padding: 9px 9px;
                    height: 35px;
                }

                /* Textareas: allow resizing vertically */
                .form-container .form-group textarea.form-control {
                    height: 150px;
                    resize: vertical;
                }

                /* File input styling (optional) */
                .form-container .form-group input[type="file"].form-control {
                    padding: 3px 6px;
                }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .form-container .form-grid {
                grid-template-columns: 1fr; /* single column on small screens */
            }
        }

        .form-container .form-group.colspan-2 {
            grid-column: span 2;
        }

        /* Button container: center buttons inline */
        .form-container .form-buttons {
            display: flex;
            justify-content: center; /* center horizontally */
            gap: 20px; /* space between buttons */
            margin-top: 20px; /* spacing above buttons */
            grid-column: 1 / -1; /* span full grid width */
        }

            /* Style for buttons to match form controls */
            .form-container .form-buttons button {
                padding: 8px 20px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
            }

                /* Submit button special color */
                .form-container .form-buttons button[type="submit"] {
                    background-color: #4CAF50;
                    color: white;
                    border-color: #4CAF50;
                }

                /* Reset button style */
                .form-container .form-buttons button[type="reset"] {
                    background-color: #f0f0f0;
                    color: #333;
                }

        .readonly {
            background-color: #f5f5f5; /* light gray */
            pointer-events: none; /* prevent clicks */
            opacity: 0.7; /* slightly faded */
        }

        #hrinv_btn {
            min-width: 160px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
        }
    </style>

    <script>
        var fd = new FormData();

        window.onload = function () {
            document.getElementById('hrinv_attachment').addEventListener('change', getFileName);
        };

        function getFileName(event) {

            var file = event.target.files[0]; // get single file

            if (!file) return;

            document.getElementById("hrinv_file").value = file.name;

            fd = new FormData(); // reset formdata
            fd.append("file", file);

            const xhr = new XMLHttpRequest();

            xhr.onload = function () {
                if (xhr.status >= 200 && xhr.status < 300) {
                    console.log("File uploaded successfully");
                }
            };

            var url = window.location.href;

            xhr.open("POST", url, true);
            xhr.send(fd);
        }


        $(document).ready(function () {

            hr_bindInvoice();

            hrinv_bindEmployees();
            hrinv_bindLocation();
            hrinv_bindAssignTo();
        });

    </script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="hrinv_file" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-file-invoice-dollar"></i>
                    HR Invoice
                </div>
                <div class="dashboard-subtitle">
                    Manage, and track HR-related invoices, payment details, and billing records.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12" style="background-color: white;">
        <%--  <div class="card"> </div>
            <div class="card-body"> </div>--%>
        <div class="card card-primary card-outline">

            <div class="card-header">
                <div class="card-title">
                    <i class="fas fa-edit"></i>
                    Employee Information:
                </div>
            </div>

            <div class="form-container">
                <div class="form-grid">

                    <!-- User dropdown (editable) -->
                    <div class="form-group">
                        <label><b>User</b></label>
                        <select id="hrinv_user" name="hrinv_user" class="form-control" onchange="return hrinv_bindemployeeInfo(this);">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <!-- Read-only fields -->
                    <div class="form-group">
                        <label><b>Joining Date</b></label>
                        <input type="text" id="hrinv_joiningdate" name="hrinv_joiningdate" class="form-control" readonly style="background-color: white;" />
                    </div>

                    <div class="form-group">
                        <label><b>Tenure</b></label>
                        <input type="text" id="hrinv_tenure" name="hrinv_tenure" class="form-control" readonly style="background-color: white;" />
                    </div>

                    <div class="form-group">
                        <label><b>Salary</b></label>
                        <input type="text" id="hrinv_salary" name="hrinv_salary" class="form-control" readonly style="background-color: white;" />
                    </div>

                    <div class="form-group">
                        <label><b>CTC</b></label>
                        <input type="text" id="hrinv_ctc" name="hrinv_ctc" class="form-control" readonly style="background-color: white;" />
                    </div>

                </div>
            </div>

        </div>

        <div class="card card-primary card-outline">

            <div class="card-header">
                <div class="card-title">
                    <i class="fas fa-edit"></i>
                    Invoice Details:
                </div>
            </div>

            <div class="form-container">
                <div class="form-grid">

                    <div class="form-group">
                        <label><strong>Location</strong></label>
                        <select id="hrinv_location" name="hrinv_user" class="form-control"></select>
                    </div>

                    <div class="form-group">
                        <label><strong>Invoice Type</strong></label>
                        <select id="hrinv_invtype" name="hrinv_invtype" class="form-control">
                            <option value="">Select</option>
                            <option value="Consultancy Charges">Consultancy Charges</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><strong>Invoice #</strong></label>
                        <input type="text" id="hrinv_invNo" name="hrinv_invNo" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Consultancy</strong></label>
                        <input type="text" id="hrinv_consultancy" name="hrinv_consultancy" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Account #</strong></label>
                        <input type="text" id="hrinv_accountNo" name="hrinv_accountNo" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Circuit ID</strong></label>
                        <input type="text" id="hrinv_circuitID" name="hrinv_circuitID" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>From Date</strong></label>
                        <input type="date" id="hrinv_fromdate" name="hrinv_fromdate" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>To Date</strong></label>
                        <input type="date" id="hrinv_todate" name="hrinv_todate" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Due Date</strong></label>
                        <input type="date" id="hrinv_duedate" name="hrinv_duedate" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Amount</strong></label>
                        <input type="number" id="hrinv_amount" name="hrinv_amount" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>GST #</strong></label>
                        <input type="text" id="hrinv_gstNo" name="hrinv_gstNo" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>PAN</strong></label>
                        <input type="text" id="hrinv_PAN" name="hrinv_PAN" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Assign To</strong></label>
                        <select id="hrinv_assignto" name="hrinv_assignto" class="form-control"></select>
                    </div>

                    <div class="form-group">
                        <label><strong>Category</strong></label>
                        <select id="hrinv_category" name="hrinv_category" class="form-control">
                            <option value="">Select</option>
                            <option value="Consultancy Billing">Consultancy Billing</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><strong>Invoice</strong></label>
                        <input type="file" id="hrinv_attachment" name="hrinv_attachment" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><strong>Remark</strong></label>
                        <textarea id="hrinv_remark" name="hrinv_remark" class="form-control" rows="4" placeholder="Enter remarks here..."></textarea>
                    </div>

                    <div class="form-group colspan-2">
                        <label><strong>Contract Condition in Brief</strong></label>
                        <textarea id="hrinv_contractCondition" name="hrinv_contractCondition" class="form-control" rows="4" placeholder="Enter contract conditions here..."></textarea>
                    </div>

                    <div class="form-group colspan-2">
                        <label><strong>Vendor Payment as per Contract</strong></label>
                        <textarea id="hrinv_vendorPayment" name="hrinv_vendorPayment" class="form-control" rows="4" placeholder="Enter vendor payment details..."></textarea>
                    </div>

                    <!-- Buttons row -->
                    <div class="form-buttons">
                        <button type="reset">Reset</button>
                        <button type="button" id="hrinv_btn" class="btn btn-primary" onclick="return hrinv_SubmitData();">Submit</button>
                    </div>
                </div>
            </div>

        </div>


        <div class="card-body">
            <table class="table" id="table_hrInvoice" style="width: 100%">
                <thead>
                    <tr>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attachment</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Invoice #</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Invoice Type</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Category</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Location</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Consultancy</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">GST #</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">PAN</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Circuit ID</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">From Date</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">To Date</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Due Date</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Invoice Amount</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Assign Department</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 400px; white-space: normal;">Contract condition in brief</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 400px; white-space: normal;">Vendor payment as per Contract</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">EmpID</th>
                        <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">AssignToDept</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

    </div>

</asp:Content>
