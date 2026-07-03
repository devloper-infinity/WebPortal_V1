var funfriday_table;
var funfriday_selectedrow;

function funFridayBlank(value) {
    if (value === null || value === undefined) {
        return '';
    }

    return value;
}

function funFridayEscapeHtml(value) {
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

function funFridayJsString(value) {
    if (value === null || value === undefined) {
        return '';
    }

    return String(value)
        .replace(/\\/g, '\\\\')
        .replace(/'/g, "\\'")
        .replace(/\r/g, '')
        .replace(/\n/g, ' ');
}

function funFridayShowMessage(message, isError) {
    $('#funfriday_errmsg')
        .text(message)
        .css('color', isError ? '#be123c' : '#172033');

    $('#funfriday_dverror').modal('show');
}

function funfriday_bindlocation() {
    var select = document.getElementById('funfriday_location');
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $('#funfriday_location').append($('<option></option>').val('').html('Select'));

    $.ajax({
        type: 'POST',
        url: 'FunFriday.aspx/GetBranches',
        dataType: 'json',
        contentType: 'application/json',
        success: function (res) {
            $.each(res.d, function (data, value) {
                $('#funfriday_location').append(
                    $('<option></option>').val(value.BranchID).html(funFridayEscapeHtml(value.BranchName))
                );
            });
        }
    });
}

function funfriday_binddata() {
    $('#load1').show();

    $.ajax({
        url: 'FunFriday.aspx/GetFunFridayData',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        success: function (data) {
            var dataArray = JSON.parse(data.d || '[]');
            var html = '';

            $.each(dataArray, function (index, value) {
                var imageCount = parseInt(funFridayBlank(value.ImgCount), 10) || 0;
                var imagePath = funFridayJsString(value.Path1);

                html += '<tr>';
                if (imageCount > 0) {
                    html += "<td class=\"text-center\"><button type=\"button\" class=\"ff-image-action\" title=\"View Images\" onclick=\"return display_funfridayImages('" + imagePath + "');\"><i class=\"uil uil-images\" aria-hidden=\"true\"></i></button></td>";
                }
                else {
                    html += '<td class="text-center"><span class="ff-image-action-disabled" title="No Images"><i class="uil uil-images" aria-hidden="true"></i></span></td>';
                }

                html += '<td>' + funFridayEscapeHtml(value.Date1) + '</td>';
                html += '<td>' + funFridayEscapeHtml(value.Activity) + '</td>';
                html += '<td>' + funFridayEscapeHtml(value.Location1) + '</td>';
                html += '<td>' + funFridayEscapeHtml(value.Details) + '</td>';
                html += '<td>' + funFridayEscapeHtml(imageCount) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#funfriday_table')) {
                funfriday_table.destroy();
            }

            $('#funfriday_table tbody').html(html);

            funfriday_table = $('#funfriday_table').DataTable({
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
                    emptyTable: 'No Fun Friday activities found'
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Fun Friday Report',
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
            funFridayShowMessage(error && error.responseText ? error.responseText : 'Fun Friday data could not be loaded.', true);
        }
    });

    return false;
}

function display_funfridayImages(imgpath) {
    var parts = (imgpath || '').split(',').filter(function (item) {
        return $.trim(item) !== '';
    });

    var title = 'Fun Friday Snaps';
    var images = parts;

    if (parts.length > 1 && parts[0].indexOf('\\') === -1 && parts[0].indexOf('/') === -1) {
        title = parts[0];
        images = parts.slice(1);
    }

    $('#displayfunfriday_Header').text(title);

    var dvmain = document.getElementById('dvslidermain');
    dvmain.innerHTML = '';

    if (images.length === 0) {
        dvmain.innerHTML = '<div class="text-center text-muted py-4">No images available.</div>';
        $('#funfriday_displayimages').modal('show');
        $('#load1').hide();
        return false;
    }

    var carousel = document.createElement('div');
    carousel.id = 'carouselFunFridayImages';
    carousel.setAttribute('data-ride', 'carousel');
    carousel.className = 'carousel slide';

    var inner = document.createElement('div');
    inner.className = 'carousel-inner';
    inner.setAttribute('role', 'listbox');

    for (var index = 0; index < images.length; index++) {
        var slide = document.createElement('div');
        slide.className = 'carousel-item' + (index === 0 ? ' active' : '');

        var img = document.createElement('img');
        img.className = 'ff-carousel-image';
        img.setAttribute('src', $.trim(images[index]).replace(/\\/g, '/'));
        img.setAttribute('alt', title);

        slide.appendChild(img);
        inner.appendChild(slide);
    }

    carousel.appendChild(inner);

    if (images.length > 1) {
        var prev = document.createElement('a');
        prev.className = 'carousel-control-prev';
        prev.setAttribute('href', '#carouselFunFridayImages');
        prev.setAttribute('role', 'button');
        prev.setAttribute('data-slide', 'prev');
        prev.innerHTML = '<span class="carousel-control-prev-icon" aria-hidden="true"></span><span class="sr-only">Previous</span>';

        var next = document.createElement('a');
        next.className = 'carousel-control-next';
        next.setAttribute('href', '#carouselFunFridayImages');
        next.setAttribute('role', 'button');
        next.setAttribute('data-slide', 'next');
        next.innerHTML = '<span class="carousel-control-next-icon" aria-hidden="true"></span><span class="sr-only">Next</span>';

        carousel.appendChild(prev);
        carousel.appendChild(next);
    }

    dvmain.appendChild(carousel);
    $('#funfriday_displayimages').modal('show');
    $('#load1').hide();

    return false;
}

function funfriday_SubmitData() {
    var funfriday_date = $.trim($('#funfriday_date').val() || '');
    var funfriday_activity = $.trim($('#funfriday_activity').val() || '');
    var funfriday_location = $('#funfriday_location').val();
    var funfriday_details = $.trim($('#funfriday_details').val() || '');

    if (funfriday_date === '') {
        funFridayShowMessage('Please select date.', true);
        $('#funfriday_date').focus();
        return false;
    }

    if (funfriday_activity === '') {
        funFridayShowMessage('Please enter activity.', true);
        $('#funfriday_activity').focus();
        return false;
    }

    if (!funfriday_location) {
        funFridayShowMessage('Please select location.', true);
        $('#funfriday_location').focus();
        return false;
    }

    if (funfriday_details === '') {
        funFridayShowMessage('Please enter details.', true);
        $('#funfriday_details').focus();
        return false;
    }

    PageMethods.InsertFunFridayData(funfriday_date, funfriday_activity, funfriday_location, funfriday_details, funriday_OnSuccess, funfriday_OnError);
    return false;
}

function funriday_OnSuccess(result) {
    if (result > 0) {
        funFridayShowMessage('Data saved successfully!', false);
    }
    else {
        funFridayShowMessage('Oops! Error occurred while submitting data. Please contact administrator!', true);
    }

    return false;
}

function funfriday_OnError(error) {
    var message = error && error.get_message ? error.get_message() : error;
    funFridayShowMessage(message, true);
}

function funfriday_Message() {
    location.reload();
}

