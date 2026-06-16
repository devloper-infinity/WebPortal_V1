<%@ Page Title="" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="TrackingSheetConfiguration.aspx.cs" Inherits="WebPortal.Production.TrackingSheetConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <script>
        $(document).ready(function () {

            // Bind_Domain();
            //  BindDomainwiseColConfig_Grid(0);
            // BindProjectWiseColConfig_Domain();
            // BindProjectwiseColConfig_Grid(0);

            //---------- Mapping -----------
            BindColMapping_Project();
            BindColumnMapping_Grid();
        });
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Trackingsheet Configuration</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-domainWiseColumn-tab" data-toggle="pill" href="#custom-tabs-one-domainWiseColumn" role="tab" aria-controls="custom-tabs-one-domainWiseColumn" aria-selected="true"><b>Domainwise Column Master</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-ColumnConfig-tab" data-toggle="pill" href="#custom-tabs-one-ColumnConfig" role="tab" aria-controls="custom-tabs-one-ColumnConfig" aria-selected="false"><b>Projectwise Column Master</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-ColumnMapping-tab" data-toggle="pill" href="#custom-tabs-one-ColumnMapping" role="tab" aria-controls="custom-tabs-one-ColumnMapping" aria-selected="false"><b>Column Mapping</b></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent_addinvocie">
                            <div class="tab-pane fade show active" id="custom-tabs-one-domainWiseColumn" role="tabpanel" aria-labelledby="custom-tabs-one-domainWiseColumn-tab">
                                <div style="width: 100%; overflow: auto;">
                                    <table class="table">
                                        <tr>
                                            <td>
                                                <b>Domain :</b>
                                            </td>
                                            <td>
                                                <select id="track_domain" name="track_domain" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                            <td><b>Field Name :</b></td>
                                            <td>
                                                <input type="text" id="track_FieldName" name="track_FieldName" class="form-control" style="width: 250px;" />
                                            </td>
                                            <td>
                                                <input type="checkbox" class="form-control" id="chkNameColumn" style="display: inline!important; width: 70px;" name="chkNameColumn" title="Once you click the checkbox, the username will be auto-filled in this column, and five additional hidden columns will become visible: Assign Date, Start Time, End Time, TAT, and Status." />
                                                <b>Is Name Column:</b> </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <button class="btn btn-primary" type="button" id="btnDomainWise" onclick="btnSubmit_DomainWiseColConfg();">Submit</button>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <table class="table" id="table_DomainWiseColMaster" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th class="sort border-top ps-3" style="width: 80px; text-align: center;">Action</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 100px;">Sr. #</th>
                                                <th class="sort border-top">Field</th>
                                                <th class="sort border-top" style="width: 80px;">Name Column</th>
                                                <th class="sort border-top" style="text-align: center;">Domain</th>
                                                <th class="sort border-top" style="text-align: center;">Added By</th>
                                                <th class="sort border-top" style="text-align: center;">Added Date</th>
                                                <th class="sort border-top">Updated By</th>
                                                <th class="sort border-top" style="text-align: center;">Updated Date</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">DomainID</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">Chkstatus</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-ColumnConfig" role="tabpanel" aria-labelledby="custom-tabs-one-ColumnConfig-tab">
                                <div style="width: 100%; overflow: auto;">
                                    <table class="table">
                                        <tr>
                                            <td>
                                                <b>Domain :</b>
                                            </td>
                                            <td>
                                                <select id="track_PrjColConfigdomain" name="track_PrjColConfigdomain" onchange="return BindProjectWiseColConfig_Project(this);" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                            <td><b>Project :</b></td>
                                            <td>
                                                <select id="track_PrjColConfigProject" name="track_PrjColConfigProject" onchange="return BindProjectWiseColConfig_Field(this);" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                            <td><b>Field Name :</b></td>
                                            <td>
                                                <select id="track_PrjColConfigFieldName" name="track_PrjColConfigFieldName" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>Visible to user :</b>
                                            </td>
                                            <td>
                                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="track_PrjColConfigVisible" name="track_PrjColConfigVisible" title="When the checkbox is selected, the corresponding field becomes visible to the user." />
                                            </td>
                                            <td>
                                                <b>Editable to user :</b>
                                            </td>
                                            <td>
                                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="track_PrjColConfigEditable" name="track_PrjColConfigEditable" title="When the checkbox is selected, the corresponding field becomes editable to the user." />
                                            </td>
                                            <td></td>
                                            <td>
                                                <button class="btn btn-primary" type="button" id="btnPrjColumnConfig" onclick="btnSubmit_PrjColumnConfig();">Submit</button>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <table class="table" id="table_PrjWiseColMaster" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th class="sort border-top ps-3">Action</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                <th class="sort border-top" style="text-align: center;">Domain</th>
                                                <th class="sort border-top" style="text-align: center;">Project</th>
                                                <th class="sort border-top">Field</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Visible to user</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Editable to user</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Added By</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Added Date</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Updated By</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Updated Date</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">DomainId</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">DomainId</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">FieldName</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">Visible</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">Editable</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-ColumnMapping" role="tabpanel" aria-labelledby="custom-tabs-one-ColumnMapping-tab">
                                <div style="width: 100%; overflow: auto;">
                                    <table class="table">
                                        <tr>
                                            <td>
                                                <b>Project :</b>
                                            </td>
                                            <td>
                                                <select id="track_ColumnMappingProject" name="track_ColumnMappingProject" onchange="return BindColMapping_Column(this);" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                            <td><b>Column :</b></td>
                                            <td>
                                                <select id="track_ColumnMappingColumn" name="track_ColumnMappingColumn" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                            <td><b>Field :</b></td>
                                            <td>
                                                <select id="track_ColumnMappingFieldName" name="track_ColumnMappingFieldName" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>Sequence :</b>
                                            </td>
                                            <td>
                                                <select id="track_ColumnMappingSequence" name="track_ColumnMappingSequence" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                </select>
                                            </td>
                                            <td>
                                                <b>Date :</b>
                                            </td>
                                            <td>
                                                <select id="track_ColumnMappingDate" name="track_ColumnMappingDate" class="form-control" style="width: 250px;">
                                                    <option value="Select">Select</option>
                                                    <option value="Select">mm/dd/yyyy</option>
                                                    <option value="Select">dd-MMM-yyyy</option>
                                                    <option value="Select">mm/dd/yyyy hh:mm:ss</option>
                                                    <option value="Select">dd-MMM-yyyy hh:mm:ss</option>
                                                </select>
                                            </td>
                                            <td><b>Field Length :</b></td>
                                            <td>
                                                <input type="number" id="track_ColumnMappingFieldLength" name="track_ColumnMappingFieldLength" min="1" class="form-control" style="width: 250px;" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>For Billing :</b>
                                            </td>
                                            <td>
                                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="track_ColumnMappingBilling" name="track_ColumnMappingBilling" title="Check this box to apply this column for billing purposes." />
                                            </td>
                                            <td>
                                                <b>For Import :</b>
                                            </td>
                                            <td>
                                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="track_ColumnMappingImport" name="track_ColumnMappingImport" title="By selecting this checkbox, the column becomes available for import." />
                                            </td>
                                            <td><b>For Unique Column :</b></td>
                                            <td>
                                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="track_ColumnMappingUnique" name="track_ColumnMappingUnique" title="Once you check this box, the column will be set to Unique." />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <button class="btn btn-primary" type="button" id="btnColumnMapping" onclick="btnSubmit_ColumnMapping();">Submit</button>
                                            </td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <table class="table" id="table_ColumnMapping" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th class="sort border-top ps-3">Action</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                <th class="sort border-top" style="text-align: center;">Project</th>
                                                <th class="sort border-top" style="text-align: center;">Column</th>
                                                <th class="sort border-top" style="width: 200px;">Field</th>
                                                <th class="sort border-top" style="text-align: center;">Sequence</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">For Billing</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">For Import</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">For Unique Column</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Date Format</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Field Length</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Added By</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Added Date</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Updated By</th>
                                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Updated Date</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">ProjectID</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">ProjectFieldID</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">ColumnID</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">Billing</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">Unique</th>
                                                <th class="sort border-top" style="text-align: center; display: none;">Import</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="PopUptrack_UpdateColConfiguration">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Domainwise Column Configuration</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td>
                                <b>Domain :</b>
                            </td>
                            <td>
                                <select id="PopUptrack_domain" name="PopUptrack_domain" class="form-control" style="width: 300px;">
                                    <option value="Select">Select</option>
                                </select>
                            </td>
                            <td><b>Field Name :</b></td>
                            <td>
                                <input type="text" id="PopUptrack_FieldName" name="PopUptrack_FieldName" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Is Name Column:</b>
                            </td>
                            <td>
                                <input type="checkbox" class="form-control" id="PopUpchkNameColumn" name="PopUpchkNameColumn" title="Once you click on this check box , you will get auto username in this column and other 5 hidden column will be followed by it(Assign date, start time ,End time ,TAT , Status)." />
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnUpdate_ColConfiguration" onclick="Update_ColConfiguration();">Update</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="PopUp_DeleteColConfiguration">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Configuration</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete configuration?</p>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="ColConfiguration_btnYes" onclick="return delete_ColConfiguration();">Yes</button>
                </div>
                <div style="display: none;">
                    <label id="lblConfigType" name="lblConfigType"></label>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="PopUptrack_UpdateProjectColConfiguration">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Projectwise Column Configuration</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td>
                                <b>Domain :</b>
                            </td>
                            <td>
                                <select id="PopUptrackProject_domain" name="PopUptrackProject_domain" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                </select>
                            </td>
                            <td>
                                <b>Project :</b>
                            </td>
                            <td>
                                <select id="PopUptrackProject_project" name="PopUptrackProject_project" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                </select>
                            </td>
                            <td><b>Field Name :</b></td>
                            <td>
                                <select id="PopUptrackProject_FieldName" name="PopUptrackProject_FieldName" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Visible to user:</b>
                            </td>
                            <td>
                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="PopUptrack_PrjColConfigVisible" name="PopUptrack_PrjColConfigVisible" title="When the checkbox is selected, the corresponding field becomes visible to the user." />
                            </td>
                            <td>
                                <b>Editable to user:</b>
                            </td>
                            <td>
                                <input type="checkbox" class="form-control" style="text-align: left; width: 25px!important;" id="PopUptrack_PrjColConfigEditable" name="PopUptrack_PrjColConfigEditable" title="When the checkbox is selected, the corresponding field becomes editable to the user." />
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnUpdate_ColProjectConfiguration" onclick="Update_ColConfiguration();">Update</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="tracking_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="roam_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="tracking_btnMessage" onclick="return tracking_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
