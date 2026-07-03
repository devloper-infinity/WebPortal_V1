function festivalEscapeHtml(value) {
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

function festivalShowAlert(options) {
    if (window.Swal) {
        return Swal.fire(options);
    }

    alert((options.title || '') + (options.text ? '\n' + options.text : ''));
    return {
        then: function (callback) {
            if (callback) {
                callback({ isConfirmed: true });
            }
        }
    };
}

function festivalGetCheckedValues(selector) {
    var values = [];

    $(selector + ':checked').each(function () {
        values.push($(this).val());
    });

    return values;
}

function festivalUpdateDropdownText(buttonSelector, itemSelector, defaultText) {
    var total = $(itemSelector).length;
    var checked = $(itemSelector + ':checked').length;

    if (checked === 0) {
        $(buttonSelector).text(defaultText);
    }
    else if (total > 0 && checked === total) {
        $(buttonSelector).text('All Selected');
    }
    else {
        $(buttonSelector).text(checked + ' Selected');
    }
}

function festivalBuildCheckbox(cssClass, value, text) {
    return '<label>' +
        '<input type="checkbox" class="' + cssClass + '" value="' + festivalEscapeHtml(value) + '">' +
        '<span>' + festivalEscapeHtml(text) + '</span>' +
        '</label>';
}

function festival_bindGrid() {
    $('#load1').show();

    $.ajax({
        url: 'FestivalWishesMaster.aspx/GetFestivalMaster',
        type: 'POST',
        contentType: 'application/json',
        success: function (data) {
            var dataArray = JSON.parse(data.d || '[]');

            if ($.fn.DataTable.isDataTable('#table_festival')) {
                $('#table_festival').DataTable().clear().destroy();
            }

            $('#table_festival').DataTable({
                dom: 'lfrtip',
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,
                language: {
                    emptyTable: 'No festival wishes found'
                },
                columns: [
                    {
                        data: 'FestivalId',
                        className: 'text-center',
                        render: function (data) {
                            var festivalId = parseInt(data, 10) || 0;
                            return '<button type="button" title="Delete Record" class="festival-delete-action" onclick="return festWish_delete(' + festivalId + ');">' +
                                '<i class="uil uil-trash-alt" aria-hidden="true"></i>' +
                                '</button>';
                        }
                    },
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    {
                        data: 'Title',
                        render: function (data) {
                            return festivalEscapeHtml(data);
                        }
                    },
                    {
                        data: 'Path1',
                        className: 'text-center',
                        render: function (data, type, row) {
                            if (!data) {
                                return '';
                            }

                            var imagePath = festivalEscapeHtml(data);
                            var title = festivalEscapeHtml(row.Title || 'Festival Preview');

                            return '<img src="../FestivalWishesImages/' + imagePath + '" alt="' + title + '" class="festivalImg" data-title="' + title + '">';
                        }
                    },
                    { data: 'OnDate' },
                    { data: 'UploadedBy' },
                    { data: 'UploadedDate' }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (error) {
            $('#load1').hide();
            festivalShowAlert({
                icon: 'error',
                title: 'Load Error',
                text: error && error.responseText ? error.responseText : 'Festival wishes could not be loaded.'
            });
        }
    });
}

function festWish_SubmitData() {
    var title = $.trim($('#festWish_title').val() || '');
    var date = $.trim($('#festWish_date').val() || '');
    var gender = $('#festWish_gender').val();
    var fileInput = document.getElementById('festWish_attachment');
    var locations = festivalGetCheckedValues('.location_checkbox');
    var departments = festivalGetCheckedValues('.department_checkbox');
    var designations = festivalGetCheckedValues('.designation_checkbox');
    var users = festivalGetCheckedValues('.user_checkbox');

    if (title === '') {
        festivalShowAlert({ icon: 'warning', title: 'Title Required', text: 'Please select title.' });
        $('#festWish_title').focus();
        return false;
    }

    if (date === '') {
        festivalShowAlert({ icon: 'warning', title: 'Date Required', text: 'Please select date.' });
        $('#festWish_date').focus();
        return false;
    }

    if (!gender) {
        festivalShowAlert({ icon: 'warning', title: 'Gender Required', text: 'Please select gender.' });
        $('#festWish_gender').focus();
        return false;
    }

    if (!fileInput || fileInput.files.length === 0) {
        festivalShowAlert({ icon: 'warning', title: 'File Required', text: 'Please select attachment file.' });
        return false;
    }

    if (locations.length === 0) {
        festivalShowAlert({ icon: 'warning', title: 'Location Required', text: 'Please select at least one location.' });
        return false;
    }

    if (departments.length === 0) {
        festivalShowAlert({ icon: 'warning', title: 'Department Required', text: 'Please select at least one department.' });
        return false;
    }

    if (designations.length === 0) {
        festivalShowAlert({ icon: 'warning', title: 'Designation Required', text: 'Please select at least one designation.' });
        return false;
    }

    if (users.length === 0) {
        festivalShowAlert({ icon: 'warning', title: 'User Required', text: 'Please select at least one user.' });
        return false;
    }

    PageMethods.InsertFestiveData(
        title,
        date,
        locations.join(','),
        departments.join(','),
        designations.join(','),
        users.join(','),
        gender,
        function (response) {
            festivalShowAlert({
                icon: 'success',
                title: 'Success',
                text: response
            }).then(function () {
                location.reload();
            });
        },
        function (error) {
            festivalShowAlert({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );

    return false;
}

function festWish_delete(id) {
    festivalShowAlert({
        title: 'Confirm Action',
        html: 'Are you sure you want to delete this festival wish?',
        icon: 'question',
        allowOutsideClick: false,
        showCancelButton: true,
        confirmButtonText: 'Yes',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#be123c',
        cancelButtonColor: '#64748b'
    }).then(function (result) {
        if (!result.isConfirmed) {
            return;
        }

        PageMethods.DeleteFestivalImages(
            id,
            function (response) {
                festivalShowAlert({
                    icon: 'success',
                    title: 'Deleted',
                    text: response
                }).then(function () {
                    festival_bindGrid();
                });
            },
            function (error) {
                festivalShowAlert({
                    icon: 'error',
                    title: 'Server Error',
                    text: error.get_message()
                });
            }
        );
    });

    return false;
}

$(document).on('click', '.multi-dropdown-menu', function (event) {
    event.stopPropagation();
});

$(document).on('click', '.festivalImg', function () {
    var imgSrc = $(this).attr('src');
    var title = $(this).data('title') || 'Festival Preview';

    $('#festivalTitle').text(title);
    $('#previewImage').attr('src', imgSrc);
    $('#imagePreviewModal').modal('show');
});

function festWish_bindlocation() {
    $('#locationList').html('');

    $.ajax({
        type: 'POST',
        url: 'CreateProfile.aspx/GetBranches',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res) {
            $.each(res.d, function (i, value) {
                $('#locationList').append(festivalBuildCheckbox('location_checkbox', value.BranchID, value.BranchName));
            });
        }
    });
}

$(document).on('change', '#select_all_location', function () {
    $('.location_checkbox').prop('checked', this.checked);
    updateLocationText();
});

$(document).on('change', '.location_checkbox', function () {
    var total = $('.location_checkbox').length;
    var checked = $('.location_checkbox:checked').length;

    $('#select_all_location').prop('checked', total > 0 && total === checked);
    updateLocationText();
});

function updateLocationText() {
    festivalUpdateDropdownText('#locationDropdownBtn', '.location_checkbox', 'Select Location');
}

function festWish_bindDepartment() {
    $('#departmentList').html('');

    $.ajax({
        type: 'POST',
        url: 'CreateProfile.aspx/GetDepartment',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res) {
            $.each(res.d, function (i, value) {
                $('#departmentList').append(festivalBuildCheckbox('department_checkbox', value.DepartmentID, value.DepartmentName));
            });
        }
    });
}

$(document).on('change', '#select_all_department', function () {
    $('.department_checkbox').prop('checked', this.checked);
    updateDepartmentText();
});

$(document).on('change', '.department_checkbox', function () {
    var total = $('.department_checkbox').length;
    var checked = $('.department_checkbox:checked').length;

    $('#select_all_department').prop('checked', total > 0 && total === checked);
    updateDepartmentText();
});

function updateDepartmentText() {
    festivalUpdateDropdownText('#departmentDropdownBtn', '.department_checkbox', 'Select Department');
}

function festWish_bindDesignation() {
    $('#designationList').html('');

    $.ajax({
        type: 'POST',
        url: 'CreateProfile.aspx/GetDesignation',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res) {
            $.each(res.d, function (i, value) {
                $('#designationList').append(festivalBuildCheckbox('designation_checkbox', value.DesignationID, value.DesignationName));
            });
        }
    });
}

$(document).on('change', '#select_all_designation', function () {
    $('.designation_checkbox').prop('checked', this.checked);
    updateDesignationText();
});

$(document).on('change', '.designation_checkbox', function () {
    var total = $('.designation_checkbox').length;
    var checked = $('.designation_checkbox:checked').length;

    $('#select_all_designation').prop('checked', total > 0 && total === checked);
    updateDesignationText();
});

function updateDesignationText() {
    festivalUpdateDropdownText('#designationDropdownBtn', '.designation_checkbox', 'Select Designation');
}

function festWish_bindEmployee() {
    $('#userList').html('');

    $.ajax({
        type: 'POST',
        url: 'RoamingBranch.aspx/GetCodes',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res) {
            var dataArray = JSON.parse(res.d || '[]');

            $.each(dataArray, function (i, value) {
                $('#userList').append(festivalBuildCheckbox('user_checkbox', value.EmployeeID, value.FullName));
            });
        }
    });
}

$(document).on('change', '#select_all_user', function () {
    $('.user_checkbox').prop('checked', this.checked);
    updateUserText();
});

$(document).on('change', '.user_checkbox', function () {
    var total = $('.user_checkbox').length;
    var checked = $('.user_checkbox:checked').length;

    $('#select_all_user').prop('checked', total > 0 && total === checked);
    updateUserText();
});

function updateUserText() {
    festivalUpdateDropdownText('#userDropdownBtn', '.user_checkbox', 'Select Employee');
}
