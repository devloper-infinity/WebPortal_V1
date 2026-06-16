
/************** Tab 1 - Order Entry ************** */

var edit_OrderID = 0;
var edit_projectID = 0;
var orderentry_table;

function OrderEntry_BindState() {

    var select = document.getElementById("orderentry_state");
    let options = select.getElementsByTagName('option');

    var select662 = document.getElementById("orderentry_state_662");
    let options662 = select662.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    for (var i = options662.length; i--;) {
        select662.removeChild(options[i]);
    }

    $("#orderentry_state").append($("<option></option>").val("").html("Select"));
    $("#orderentry_state_662").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetAllState", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_state").append($("<option></option>").val(value.StateCode).html(value.StateCode));
                $("#orderentry_state_662").append($("<option></option>").val(value.StateCode).html(value.StateCode));
            })
        }
    });
}

function OrderEntry_BindCounty(ddlstate) {

    var state = ddlstate.options[ddlstate.selectedIndex].value;

    var select = document.getElementById("orderentry_county");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#orderentry_county").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetCountyByState", dataType: "json",
        data: "{State:'" + state + "'}",
        contentType: "application/json",

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_county").append($("<option></option>").val(value.County).html(value.County));
            })
        }
    });
}

function OrderEntry_BindTemplate(ddlproject) {

    var project = ddlproject.options[ddlproject.selectedIndex].value;
    var projectname = ddlproject.options[ddlproject.selectedIndex].text;

    OrderEntry_BindProductType(projectname)
    OrderEntry_BindGrid(project)
    var select = document.getElementById("orderentry_template");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#orderentry_template").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetAllTemplateProject", dataType: "json",
        data: "{ProjectID:'" + project + "'}",
        contentType: "application/json",

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_template").append($("<option></option>").val(value.TemplateId).html(value.Template));
            })
        }
    });
}

function OrderEntry_BindUsers() {

    var select = document.getElementById("orderentry_searcher");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#orderentry_searcher").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetAllUsers", dataType: "json",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_searcher").append($("<option></option>").val(value.EmployeeID).html(value.EmpName));
            })
        }
    });
}

function OrderEntry_BindProjects() {

    var select = document.getElementById("orderentry_projectno");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#orderentry_projectno").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetUserWiseProject", dataType: "json",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_projectno").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })
        }
    });
}

function OrderEntry_BindProductType(projectname) {

    var select = document.getElementById("orderentry_producttype");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#orderentry_producttype").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetAllProductRelatedToProject", dataType: "json",
        data: "{ProjectNo:'" + projectname + "'}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_producttype").append($("<option></option>").val(value.ProductType).html(value.ProductType));
            })
        }
    });
}

function OrderEntry_BindGrid(project) {

    //var ddlproject = document.getElementById("orderentry_projectno");
    //var project = ddlproject.options[ddlproject.selectedIndex].value;

    $.ajax({
        type: "POST",
        url: "OrderEntry.aspx/GetAllInfinityOrderByProjectAndUser",
        dataType: "json",
        data: "{ProjectID:" + project + "}",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            var rowCount = data.d.length;

            if ($.fn.DataTable.isDataTable('#table_orderentry')) {
                $('#table_orderentry').DataTable().clear().destroy();
            }

            var table = $('#table_orderentry').DataTable({
                dom: 'ftp',
                data: dataArray,
                scrollX: false,
                paging: true,

                //autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return `
            <a title="Edit Order"
               href="#!"
               data-bs-toggle="tooltip"
               data-bs-placement="top"
               onclick="edit_order(${row.OrderID}, ${meta.row});">
                <span style="color: DodgerBlue;">
                    <i class="uil uil-edit-alt" style="font-size:16px;"></i>
                </span>
            </a>`

                                //<a title="Delete Order"
                                //   href="#!"
                                //     data-bs-toggle="tooltip"
                                //   data-bs-placement="top"
                                //   onclick="delete_order(${row.OrderID}, ${meta.row});">
                                //    <span style="color: Crimson;">
                                //        <i class="uil uil-trash-alt" style="font-size:16px;"></i>
                                //    </span>
                                //</a>
                                ;
                        }
                    },
                    { data: "SrNo" },
                    { data: "OrderDateTime" },
                    { data: "ProjectNumber" },
                    { data: "ClientOrderNo" },
                    { data: "ProductType" },
                    { data: "BName" },
                    { data: "PropertyAddress" },
                    { data: "State" },
                    { data: "County" },
                    { data: "CreatedBy" },
                    { data: "AddedDate" },
                    { data: "OrderID" }
                ],
                columnDefs: [
                    {
                        targets: 0,
                        orderable: false,
                        className: "text-center",
                    },
                    {
                        targets: 12, visible: false
                    },
                ],
                initComplete: function () {
                    $('#load1').hide();

                    orderentry_table = $('#table_orderentry').DataTable();
                }
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

function edit_order(orderid, index) {

    edit_OrderID = orderid;

    orderentry_table.$('tr').removeClass('selected-row');
    document.getElementById("orderentry_orderdate").focus();

    var rowNode = orderentry_table.row(index).node();

    $(rowNode).addClass('selected-row');

    $('#orderentry_btnreset').show();

    OrderEntry_BindOrderDetails(orderid);
}

function orderentry_reset() {

    // Clear all input fields
    document.querySelectorAll('#orderentry_orderdate, #orderentry_receiveddate,#orderentry_clientorderno, #orderentry_borrowername, #orderentry_salesprice,#orderentry_sellername, #orderentry_clientid, #orderentry_pinno').forEach(el => el.value = '');

    // Clear textareas
    document.querySelectorAll('#orderentry_propertyaddress, #orderentry_instruction, #orderentry_legaldescription').forEach(el => el.value = '');

    // Reset all dropdowns
    document.querySelectorAll('select[id^="orderentry_"]').forEach(el => el.selectedIndex = 0);


    // 🔥 FIX for dynamically bound dropdowns
    $("#orderentry_producttype").val('Select');
    $("#orderentry_template").val('Select');

    // Clear file upload
    document.getElementById('orderentry_attachment').value = '';

    document.getElementById('orderentry_btnsubmit').innerText = 'Submit';
    orderentry_table.$('tr').removeClass('selected-row');
    document.getElementById('orderentry_orderdate').focus();
    $('#orderentry_btnreset').hide();
}

function OrderEntry_BindOrderDetails(orderid) {

    $('#orderentry_btnsubmit').text('Update');

    $.ajax({
        type: "POST",
        url: "OrderEntry.aspx/GetOrderByID",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ OrderID: orderid }),

        success: function (data) {

            var dataArray = JSON.parse(data.d);
            if (!dataArray || dataArray.length === 0) return;

            var d = dataArray[0];

            // ---------- Text / Date Fields ----------
            $("#orderentry_orderdate").val(formatdate(d.OrderDate));
            $("#orderentry_receiveddate").val(formatdate(d.ReceivedDate));
            $("#orderentry_clientorderno").val(d.ClientOrderNo);
            $("#orderentry_borrowername").val(d.BName);
            $("#orderentry_propertyaddress").val(d.PropertyAddress);
            $("#orderentry_salesprice").val(d.SalesPurchaseAmount);
            $("#orderentry_sellername").val(d.SellerName);
            $("#orderentry_clientid").val(d.ClientIDNew);
            $("#orderentry_pinno").val(d.APNNo);
            $("#orderentry_instruction").val(d.Instruction);
            $("#orderentry_legaldescription").val(d.LegalDescription);

            // ---------- Simple Dropdowns ----------
            $("#orderentry_orderpriority").val(d.OrderPriority);
            $("#orderentry_expectedtat").val(d.ExpectedTime);
            $("#orderentry_onoffline").val(d.OnOffLine);
            $("#orderentry_exhibit").val(d.Exhibit);
            $("#orderentry_transaction").val(d.TransactionType);
            $("#orderentry_customertype").val(d.CustomerType);

            /*Project*/
            $(document).ready(function () {
                $.ajax({
                    type: "POST", url: "OrderEntry.aspx/GetUserWiseProject", dataType: "json", contentType: "application/json",
                    success: function (res) {
                        var dataArray = JSON.parse(res.d);
                        $("#orderentry_projectno").append($("<option></option>").val("").html("Select"));

                        $.each(dataArray, function (data, value) {

                            $("#orderentry_projectno").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));

                        })
                        $("#orderentry_projectno").val(d.ProjectID);
                    }
                });
            })

            /*State*/
            $(document).ready(function () {
                $.ajax({
                    type: "POST", url: "OrderEntry.aspx/GetAllState", dataType: "json", contentType: "application/json",
                    success: function (res) {

                        var dataArray = JSON.parse(res.d);
                        $("#orderentry_state").append($("<option></option>").val("").html("Select"));

                        $.each(dataArray, function (data, value) {

                            $("#orderentry_state").append($("<option></option>").val(value.StateCode).html(value.StateCode));
                        })
                        $("#orderentry_state").val(d.State);
                    }
                });
            })

            /*County*/
            $(document).ready(function () {
                $.ajax({
                    type: "POST", url: "OrderEntry.aspx/GetCountyByState", dataType: "json",
                    data: "{State:'" + d.State + "'}",
                    contentType: "application/json",
                    success: function (res) {

                        var dataArray = JSON.parse(res.d);
                        $("#orderentry_county").append($("<option></option>").val("").html("Select"));

                        $.each(dataArray, function (data, value) {

                            $("#orderentry_county").append($("<option></option>").val(value.County).html(value.County));
                        })
                        $("#orderentry_county").val(d.County);
                    }
                });
            })

            /*Searcher*/
            $(document).ready(function () {
                $.ajax({
                    type: "POST", url: "OrderEntry.aspx/GetAllUsers", dataType: "json",
                    contentType: "application/json",
                    success: function (res) {

                        var dataArray = JSON.parse(res.d);
                        $("#orderentry_searcher").append($("<option></option>").val("").html("Select"));

                        $.each(dataArray, function (data, value) {

                            $("#orderentry_searcher").append($("<option></option>").val(value.EmployeeID).html(value.EmpName));
                        })
                        $("#orderentry_searcher").val(d.TaskAssignedId);
                    }
                });
            })

            /*Template*/
            $(document).ready(function () {

                $.ajax({
                    type: "POST", url: "OrderEntry.aspx/GetAllTemplateProject", dataType: "json",
                    data: "{ProjectID:'" + d.ProjectID + "'}",
                    contentType: "application/json",
                    success: function (res) {

                        var dataArray = JSON.parse(res.d);
                        $("#orderentry_template").append($("<option></option>").val("").html("Select"));

                        $.each(dataArray, function (data, value) {

                            $("#orderentry_template").append($("<option></option>").val(value.TemplateId).html(value.Template));
                        })
                        $("#orderentry_template").val(d.OrderTemplateId);
                    }
                });
            })

            /*Product*/
            $(document).ready(function () {

                $.ajax({
                    type: "POST", url: "OrderEntry.aspx/GetAllProductRelatedToProject", dataType: "json",
                    data: "{ProjectNo:'" + d.ProjectNumber + "'}",
                    contentType: "application/json",
                    success: function (res) {

                        var dataArray = JSON.parse(res.d);
                        $("#orderentry_producttype").append($("<option></option>").val("").html("Select"));

                        $.each(dataArray, function (data, value) {

                            $("#orderentry_producttype").append($("<option></option>").val(value.ProductType).html(value.ProductType));
                        })
                        $("#orderentry_producttype").val(d.ProductType);
                    }
                });
            })
        },

        error: function (err) {
            console.error("Order bind failed:", err);
        }
    });
}

function formatdate(prv_date) {

    var date = new Date(prv_date);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);

    return actualdate;
}

function orderentry_submit() {

    var orderid = 0;
    var ddlProject = document.getElementById("orderentry_projectno");
    var projectid = ddlProject.options[ddlProject.selectedIndex].value;
    var projectno = ddlProject.options[ddlProject.selectedIndex].text;
    edit_projectID = projectid;

    var ddlorderpriority = document.getElementById("orderentry_orderpriority");
    var orderpriority = ddlorderpriority.options[ddlorderpriority.selectedIndex].value;

    var ddlexpectedtat = document.getElementById("orderentry_expectedtat");
    var expectedtat = ddlexpectedtat.options[ddlexpectedtat.selectedIndex].value;

    var ddlonoffline = document.getElementById("orderentry_onoffline");
    var onoffline = ddlonoffline.options[ddlonoffline.selectedIndex].value;

    var ddlexhibit = document.getElementById("orderentry_exhibit");
    var exhibit = ddlexhibit.options[ddlexhibit.selectedIndex].value;

    var ddltransaction = document.getElementById("orderentry_transaction");
    var transaction = ddltransaction.options[ddltransaction.selectedIndex].value;

    var ddlcustomertype = document.getElementById("orderentry_customertype");
    var customertype = ddlcustomertype.options[ddlcustomertype.selectedIndex].value;

    var ddlstate = document.getElementById("orderentry_state");
    var state = ddlstate.options[ddlstate.selectedIndex].value;

    var ddlcounty = document.getElementById("orderentry_county");
    var county = ddlcounty.options[ddlcounty.selectedIndex].value;

    var ddlsearcher = document.getElementById("orderentry_searcher");
    var searcher = ddlsearcher.options[ddlsearcher.selectedIndex].value;

    var ddltemplate = document.getElementById("orderentry_template");
    var template = ddltemplate.options[ddltemplate.selectedIndex].value;

    var ddlproducttype = document.getElementById("orderentry_producttype");
    var producttype = ddlproducttype.options[ddlproducttype.selectedIndex].value;

    var orderdate = document.getElementById("orderentry_orderdate").value;
    var receiveddate = document.getElementById("orderentry_receiveddate").value;
    var clientorderno = document.getElementById("orderentry_clientorderno").value;
    var borrowername = document.getElementById("orderentry_borrowername").value;
    var propertyaddress = document.getElementById("orderentry_propertyaddress").value;
    var salesprice = document.getElementById("orderentry_salesprice").value;
    var sellername = document.getElementById("orderentry_sellername").value;
    var clientid = document.getElementById("orderentry_clientid").value;
    var pinno = document.getElementById("orderentry_pinno").value;
    var instruction = document.getElementById("orderentry_instruction").value;
    var legaldescription = document.getElementById("orderentry_legaldescription").value;

    if (orderdate == "") {
        alert("Please enter order date.");
        document.getElementById("orderentry_orderdate").focus();
        return false;
    }
    if (receiveddate == "") {
        alert("Please enter received order date.");
        document.getElementById("orderentry_receiveddate").focus();
        return false;
    }
    if (projectid == "") {
        alert("Please select project #.");
        document.getElementById("orderentry_projectno").focus();
        return false;
    }
    if (clientorderno == "") {
        alert("Please enter client order no.");
        document.getElementById("orderentry_clientorderno").focus();
        return false;
    }
    if (borrowername == "") {
        alert("Please enter Borrower Name.");
        document.getElementById("orderentry_borrowername").focus();
        return false;
    }
    if (propertyaddress == "") {
        alert("Please enter property address.");
        document.getElementById("orderentry_propertyaddress").focus();
        return false;
    }
    if (state == "") {
        alert("Please select state.");
        document.getElementById("orderentry_state").focus();
        return false;
    }
    if (county == "") {
        alert("Please select county.");
        document.getElementById("orderentry_county").focus();
        return false;
    }
    if (producttype == "") {
        alert("Please select Product Type.");
        document.getElementById("orderentry_producttype").focus();
        return false;
    }
    if (expectedtat == "") {
        alert("Please select expected TAT.");
        document.getElementById("orderentry_expectedtat").focus();
        return false;
    }
    if (onoffline == "") {
        alert("Please select On/Offline.");
        document.getElementById("orderentry_onoffline").focus();
        return false;
    }
    if (transaction == "") {
        alert("Please select Transaction.");
        document.getElementById("orderentry_transaction").focus();
        return false;
    }
    if (clientid == "") {
        alert("Please enter Client ID.");
        document.getElementById("orderentry_clientid").focus();
        return false;
    }
    if (customertype == "") {
        alert("Please select Customer Type.");
        document.getElementById("orderentry_customertype").focus();
        return false;
    }

    PageMethods.InsertOrder(orderid, projectid, projectno, orderpriority, expectedtat, onoffline, exhibit, transaction, customertype, state, county, searcher, template, producttype, orderdate, receiveddate, clientorderno, borrowername, propertyaddress, salesprice, sellername, clientid, pinno, instruction, legaldescription, OnSuccess_InsertOrder, OnError_InsertOrder);
}

function OnSuccess_InsertOrder(result) {

    if (result > 0) {

        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: 'Order created successfully.',
            zIndex: 999999
        });

        location.reload();
    }
    else if (result == -1) {
        Swal.fire({
            icon: 'warning',
            title: 'Duplicate Order',
            text: 'Order alrady exists.',
            zIndex: 999999
        });
    }
    else {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Error creating order.',
            zIndex: 999999
        });
    }

    return false;
}

function OnError_InsertOrder(error) {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: error.get_message()
    });
    return false;
}

function delete_order(orderid, index) {

    $('#table_orderentry tr').css('background-color', '');
    $('#table_orderentry tr').css('font-weight', 'normal');

    var rows = orderentry_table.row(index).data();
    var rowNode = orderentry_table.row(index).node();

    $(rowNode).css({ 'background-color': '#07cdae', 'font-weight': 'bold' });

    edit_OrderID = orderid;
    $('#orderentry_deleteOrder').modal('show');
}

function orderentry_deleteOrder() {
    PageMethods.DeleteOrder(edit_OrderID, orderentry_DeleteOnSuccess, orderentry_DeleteOnError);
    return false;
}

function orderentry_DeleteOnSuccess(result) {

    $('#orderentry_deleteOrder').modal('hide');

    if (result > 0) {

        edit_OrderID = 0;

        alert("Order deleted successfully!");
    }
    else {
        alert("Oops! Error occured while deleting roaming branch. Please contact administrator!");
    }
    return false;
}

function orderentry_DeleteOnError(error) {
    alert(error);
}


/************** Tab 2 - Import Excel ************** */



/************** Tab 3 - 662-002 ************** */

function OrderEntry662_BindCounty(ddlstate) {

    var state = ddlstate.options[ddlstate.selectedIndex].value;

    var select = document.getElementById("orderentry_county_662");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#orderentry_county_662").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OrderEntry.aspx/GetCountyByState", dataType: "json",
        data: "{State:'" + state + "'}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#orderentry_county_662").append($("<option></option>").val(value.County).html(value.County));
            })
        }
    });
}

function orderentry_submit_662() {

    var ddlProject = document.getElementById("orderentry_projectno");
    var projectid = ddlProject.options[ddlProject.selectedIndex].value;

    var legaldescription = document.getElementById("orderentry_legaldescription").value;

    if (orderdate == "") {
        alert("Please enter order date.");
        document.getElementById("orderentry_orderdate").focus();
        return false;
    }
    if (receiveddate == "") {
        alert("Please enter received order date.");
        document.getElementById("orderentry_receiveddate").focus();
        return false;
    }
}