<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ChildPages.aspx.cs" Inherits="WebPortal.Admin.ChildPages" %>

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

        .dataTables_paginate {
            float: left !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
    font-size: 11px !important;
}*/
    </style>
    <script>
        $(document).ready(function () {
            $.ajax({
                type: "POST",
                url: "ChildPages.aspx/GetParentMenus",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (res) {

                    var data = res.d;

                    $("#ddlParentMenu").append('<option value="0">Root Menu</option>');

                    $.each(data, function (i, item) {

                        $("#ddlParentMenu").append(
                            '<option value="' + item.MenuId + '">' + item.MenuName + '</option>'
                        );

                    });

                }

            });

        });

        function saveMenu() {

            var obj = {
                MenuType: $("#ddlMenuType").val(),
                ParentMenuId: $("#ddlParentMenu").val(),
                MenuName: $("#txtMenuName").val(),
                Url: $("#txtUrl").val()
                /*SortOrder: $("#txtSortOrder").val()*/
            };

            $.ajax({

                type: "POST",
                url: "ChildPages.aspx/InsertMenu",
                data: JSON.stringify({ menu: obj }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function () {

                    alert("Menu saved");
                    location.reload();

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add Child Pages</b></h6>
                </div>
              <%--  <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="Log.aspx" id="aBack" runat="server" style="color: saddlebrown"><< Go back </a></li>

                    </ol>
                </div>--%>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="row">

                    <div class="col-md-3">
                        <label>Menu Type</label>
                        <select id="ddlMenuType" class="form-control">
                            <option value="menu">Menu</option>
                            <option value="section">Section</option>
                            <option value="page">Page</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label>Parent Menu</label>
                        <select id="ddlParentMenu" class="form-control"></select>
                    </div>

                    <div class="col-md-3">
                        <label>Menu Name</label>
                        <input type="text" id="txtMenuName" class="form-control">
                    </div>

                    <div class="col-md-3">
                        <label>URL (Only for Page)</label>
                        <input type="text" id="txtUrl" class="form-control">
                    </div>

                    <div class="col-md-3 mt-3" style="display: none;">
                        <label>Sort Order</label>
                        <input type="number" id="txtSortOrder" class="form-control">
                    </div>

                </div>

                <br>

                <button class="btn btn-primary" onclick="saveMenu()">Save</button>
            </div>
        </div>
    </div>
</asp:Content>
