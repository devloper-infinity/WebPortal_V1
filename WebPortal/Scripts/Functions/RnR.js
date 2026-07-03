var rnr_table;
var rnr_snap_table;

function blankForNull(value) {
    return value === 'null' || value === null || value === undefined ? '' : value;
}

function rnrEscapeHtml(value) {
    if (value === null || value === undefined) {
        return '';
    }

    return String(value).replace(/[&<>"']/g, function (character) {
        return {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        }[character];
    });
}

function rnrJsString(value) {
    if (value === null || value === undefined) {
        return '';
    }

    return String(value)
        .replace(/\\/g, '\\\\')
        .replace(/'/g, "\\'")
        .replace(/\r/g, '')
        .replace(/\n/g, ' ');
}

function rnrShowMessage(message, isError) {
    $('#rnr_errmsg')
        .text(message)
        .css('color', isError ? '#b42318' : '#172033');

    $('#rnr_dverror').modal('show');
}

function rnr_BindYear() {
    var start = new Date().getFullYear();
    var select = document.getElementById('rnr_year');
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var selectSnap = document.getElementById('rnrSnap_year');
    var optionsSnap = selectSnap.getElementsByTagName('option');

    for (var j = optionsSnap.length; j--;) {
        selectSnap.removeChild(optionsSnap[j]);
    }

    $('#rnr_year').append($('<option></option>').val('').html('Select'));
    $('#rnrSnap_year').append($('<option></option>').val('').html('Select'));

    for (var year = start; year > start - 5; year--) {
        $('#rnr_year').append($('<option></option>').val(year).html(year));
        $('#rnrSnap_year').append($('<option></option>').val(year).html(year));
    }
}

function rnr_bindusers() {
    var select = document.getElementById('rnr_employee');
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $('#rnr_employee').append($('<option></option>').val('').html('Select'));

    $.ajax({
        type: 'POST',
        url: 'RewardAndRecognition.aspx/GetAllEmployees',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res1) {
            var dataArray = JSON.parse(res1.d || '[]');
            $.each(dataArray, function (data1, value1) {
                $('#rnr_employee').append($('<option></option>').val(value1.EmployeeID).html(rnrEscapeHtml(value1.Code1)));
            });
        }
    });
}

function rnr_bindbranches() {
    var select = document.getElementById('rnrSnap_location');
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $('#rnrSnap_location').append($('<option></option>').val('').html('Select'));

    $.ajax({
        type: 'POST',
        url: 'CreateProfile.aspx/GetBranches',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res) {
            $.each(res.d, function (data, value) {
                $('#rnrSnap_location').append($('<option></option>').val(value.BranchID).html(rnrEscapeHtml(value.BranchName)));
            });
        }
    });
}

function rnr_bidgrid() {
    $('#load1').show();

    $.ajax({
        url: 'RewardAndRecognition.aspx/GetGridData',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        success: function (data) {
            var dataArray = JSON.parse(data.d || '[]');
            var html = '';

            $.each(dataArray, function (index, value) {
                html += '<tr>';
                html += '<td>' + rnrEscapeHtml(value.Quarter) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Code) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Name) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.JoiningDate) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.DateofBirth) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Branch) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Domain) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Subdomain) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Department) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Designation) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.ReportingManager) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.CurrentStatus) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.LatestLoginDate) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.DailyTaskProductivity) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.FinalStatus) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#rnr_table')) {
                rnr_table.destroy();
            }

            $('#rnr_table tbody').html(html);

            rnr_table = $('#rnr_table').DataTable({
                dom: 'lBftip',
                scrollX: true,
                destroy: true,
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },
                language: {
                    emptyTable: 'No recognition records found'
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Reward and Recognition',
                        autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
                        }
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (error) {
            $('#load1').hide();
            rnrShowMessage(error && error.responseText ? error.responseText : 'Recognition records could not be loaded.', true);
        }
    });

    return false;
}

function rnr_Submit() {
    var rnr_year = $('#rnr_year').val();
    var rnr_quarter = $('#rnr_quarter').val();
    var rnr_employee = $('#rnr_employee').val();

    if (!rnr_year) {
        rnrShowMessage('Please select year.', true);
        $('#rnr_year').focus();
        return false;
    }

    if (!rnr_quarter) {
        rnrShowMessage('Please select quarter.', true);
        $('#rnr_quarter').focus();
        return false;
    }

    if (!rnr_employee) {
        rnrShowMessage('Please select employee.', true);
        $('#rnr_employee').focus();
        return false;
    }

    PageMethods.InsertRewardDetails(rnr_year, rnr_quarter, 'Completed', rnr_employee, rnr_OnSuccess, rnr_OnError);
    return false;
}

function rnr_OnSuccess(result) {
    if (result > 0) {
        rnrShowMessage('Data saved successfully!', false);
    }
    else {
        rnrShowMessage('Error occurred while saving data. Please contact administrator!', true);
    }

    return false;
}

function rnr_OnError(error) {
    var message = error && error.get_message ? error.get_message() : error;
    rnrShowMessage(message, true);
}

function rnrSnap_Submit() {
    var rnrS_year = $('#rnrSnap_year').val();
    var rnrS_quarter = $('#rnrSnap_quarter').val();
    var rnr_Location = $('#rnrSnap_location').val();
    var locationName = $('#rnrSnap_location option:selected').text();

    if (!rnrS_year) {
        rnrShowMessage('Please select year.', true);
        $('#rnrSnap_year').focus();
        return false;
    }

    if (!rnrS_quarter) {
        rnrShowMessage('Please select quarter.', true);
        $('#rnrSnap_quarter').focus();
        return false;
    }

    if (!rnr_Location) {
        rnrShowMessage('Please select location.', true);
        $('#rnrSnap_location').focus();
        return false;
    }

    if (!$('#RewardRecg_file').val()) {
        rnrShowMessage('Please select snaps to upload.', true);
        return false;
    }

    PageMethods.InsertRnRSnaps(rnrS_year, rnrS_quarter, rnr_Location, locationName, rnrSnap_OnSuccess, rnrSnap_OnError);
    return false;
}

function rnrSnap_OnSuccess(result) {
    if (result > 0) {
        rnrShowMessage('Snaps uploaded successfully!', false);
    }
    else {
        rnrShowMessage('Error occurred while uploading snaps. Please contact administrator!', true);
    }

    return false;
}

function rnrSnap_OnError(error) {
    var message = error && error.get_message ? error.get_message() : error;
    rnrShowMessage(message, true);
}

function rnr_Message() {
    location.reload();
}

function rnr_snap_binddata() {
    $('#load1').show();

    $.ajax({
        url: 'RewardAndRecognition.aspx/GetAllRnRSnaps',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        success: function (data) {
            var dataArray = JSON.parse(data.d || '[]');
            var html = '';

            $.each(dataArray, function (index, value) {
                var imageCount = parseInt(blankForNull(value.ImgCount), 10) || 0;
                var imagePath = rnrJsString(value.Path1);

                html += '<tr>';
                if (imageCount > 0) {
                    html += "<td class=\"text-center\"><button type=\"button\" class=\"rnr-image-action\" title=\"View Images\" onclick=\"return display_rnr_snap('" + imagePath + "');\"><i class=\"uil uil-images\" aria-hidden=\"true\"></i></button></td>";
                }
                else {
                    html += '<td class="text-center"><span class="rnr-image-action-disabled" title="No Images"><i class="uil uil-images" aria-hidden="true"></i></span></td>';
                }

                html += '<td>' + rnrEscapeHtml(value.LocationName) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Year) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.Quarter) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.UploadedBy) + '</td>';
                html += '<td>' + rnrEscapeHtml(value.UploadedDate) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_rnr_snap')) {
                rnr_snap_table.destroy();
            }

            $('#table_rnr_snap tbody').html(html);

            rnr_snap_table = $('#table_rnr_snap').DataTable({
                dom: 'lBftip',
                scrollX: true,
                destroy: true,
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },
                language: {
                    emptyTable: 'No snap records found'
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Reward And Recognition Report',
                        autoFilter: true,
                        exportOptions: {
                            columns: [1, 2, 3, 4, 5]
                        }
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (error) {
            $('#load1').hide();
            rnrShowMessage(error && error.responseText ? error.responseText : 'Snap records could not be loaded.', true);
        }
    });

    return false;
}

function display_rnr_snap(imgpath) {
    var parts = (imgpath || '').split(',').filter(function (item) {
        return $.trim(item) !== '';
    });

    var title = 'Recognition Snaps';
    var images = parts;

    if (parts.length > 1 && parts[0].indexOf('\\') === -1 && parts[0].indexOf('/') === -1) {
        title = parts[0];
        images = parts.slice(1);
    }

    $('#displayrnr_snap_Header').text(title);

    var dvmain = document.getElementById('dvslidermain');
    dvmain.innerHTML = '';

    if (images.length === 0) {
        dvmain.innerHTML = '<div class="text-center text-muted py-4">No images available.</div>';
        $('#rnr_snap_display').modal('show');
        $('#load1').hide();
        return false;
    }

    var carousel = document.createElement('div');
    carousel.id = 'carouselRnrImages';
    carousel.setAttribute('data-ride', 'carousel');
    carousel.className = 'carousel slide';

    var inner = document.createElement('div');
    inner.className = 'carousel-inner';
    inner.setAttribute('role', 'listbox');

    for (var index = 0; index < images.length; index++) {
        var slide = document.createElement('div');
        slide.className = 'carousel-item' + (index === 0 ? ' active' : '');

        var img = document.createElement('img');
        img.className = 'rnr-carousel-image';
        img.setAttribute('src', $.trim(images[index]).replace(/\\/g, '/'));
        img.setAttribute('alt', title);

        slide.appendChild(img);
        inner.appendChild(slide);
    }

    carousel.appendChild(inner);

    if (images.length > 1) {
        var prev = document.createElement('a');
        prev.className = 'carousel-control-prev';
        prev.setAttribute('href', '#carouselRnrImages');
        prev.setAttribute('role', 'button');
        prev.setAttribute('data-slide', 'prev');
        prev.innerHTML = '<span class="carousel-control-prev-icon" aria-hidden="true"></span><span class="sr-only">Previous</span>';

        var next = document.createElement('a');
        next.className = 'carousel-control-next';
        next.setAttribute('href', '#carouselRnrImages');
        next.setAttribute('role', 'button');
        next.setAttribute('data-slide', 'next');
        next.innerHTML = '<span class="carousel-control-next-icon" aria-hidden="true"></span><span class="sr-only">Next</span>';

        carousel.appendChild(prev);
        carousel.appendChild(next);
    }

    dvmain.appendChild(carousel);
    $('#rnr_snap_display').modal('show');
    $('#load1').hide();

    return false;
}
