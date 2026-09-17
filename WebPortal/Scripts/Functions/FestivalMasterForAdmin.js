function adminfestWish_SubmitData() {
    var title = $.trim($('#adminfestWish_title').val() || '');
    var date = $.trim($('#adminfestWish_date').val() || '');
    var fileInput = document.getElementById('adminfestWish_attachment');
    var locations = festivalGetCheckedValues('.location_checkbox');
    var VideofileInput = document.getElementById('adminfestWish_Video');

    if (title === '') {
        festivalShowAlert({ icon: 'warning', title: 'Title Required', text: 'Please select title.' });
        $('#adminfestWish_title').focus();
        return false;
    }

    if (date === '') {
        festivalShowAlert({ icon: 'warning', title: 'Date Required', text: 'Please select date.' });
        $('#adminfestWish_date').focus();
        return false;
    }

    if (locations.length === 0) {
        festivalShowAlert({ icon: 'warning', title: 'Location Required', text: 'Please select at least one location.' });
        return false;
    }


    var videoFile = VideofileInput.files[0];
    var videoName = videoFile ? videoFile.name : null;

    var files = fileInput.files;
    var imagesData = [];
    var fileNames = [];
    var index = 0;

    function readNextFile() {
        if (index >= files.length) {
            if (videoFile) {
                var videoReader = new FileReader();
                videoReader.onload = function (ev) {
                    var base64Video = ev.target.result;
                    sendDataToServer(title, date, locations, imagesData, fileNames, base64Video, videoName);
                };
                videoReader.readAsDataURL(videoFile);
            } else {
                sendDataToServer(title, date, locations, imagesData, fileNames, null, null);
            }
            return;
        }

        var file = files[index];
        var reader = new FileReader();
        reader.onload = function (e) {
            imagesData.push(e.target.result);
            fileNames.push(file.name);
            index++;
            readNextFile();
        };
        reader.readAsDataURL(file);
    }

    readNextFile();
    return false;
}

function sendDataToServer(title, date, locations, imagesData, fileNames, base64Video, videoName) {
    $.ajax({
        type: "POST",
        url: "FestivalsWishesMasterForAdmin.aspx/InsertAdminFestiveData",
        data: JSON.stringify({
            Title: title,
            Date: date,
            Location: locations.join(','),
            ImagesBase64: imagesData,
            FileNames: fileNames,
            VideoBase64: base64Video,
            VideoName: videoName
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var resText = response.d;
            if (resText.indexOf("already exists") !== -1 || resText.indexOf("Error") !== -1) {
                festivalShowAlert({
                    icon: 'warning',
                    title: 'Warning',
                    text: resText
                });
            } else {
                festivalShowAlert({
                    icon: 'success',
                    title: 'Success',
                    text: resText
                }).then(function () {

                    $('.festival-card input, .festival-card select').val('').prop('checked', false); $('#locationDropdownBtn').text('Select Location'); $('#selectedFilesWrapper').hide(); $('#noFilesPlaceholder').show(); festivaladmin_bindGrid();
                });
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr.responseText);
            festivalShowAlert({
                icon: 'error',
                title: 'Error',
                text: "Something went wrong: " + error
            });
        }
    });
}


function festivaladmin_bindGrid() {
    $('#load1').show();

    $.ajax({
        url: 'FestivalsWishesMasterForAdmin.aspx/GetAdminFestivalMaster',
        type: 'POST',
        contentType: 'application/json',
        success: function (data) {
            var dataArray = JSON.parse(data.d || '[]');
            var currentPreviewImages = [];
            var currentImageIndex = 0;
            if ($.fn.DataTable.isDataTable('#admintable_festival')) {
                $('#admintable_festival').DataTable().clear().destroy();
            }

            $('#admintable_festival').DataTable({
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
                            return '<button type="button" title="Delete Record" class="festival-delete-action" onclick="return adminfestWish_delete(' + festivalId + ');">' +
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
                            if (!data) { return ''; }

                            var imagesArray = data.split(',');
                            var firstImage = festivalEscapeHtml(imagesArray[0].trim());
                            var title = festivalEscapeHtml(row.Title || 'Festival Preview');

                            var cleanArray = imagesArray.map(function (img) { return '../FestivalWishesImagesandVideos_Admin/' + img.trim(); });
                            var allImagesJson = JSON.stringify(cleanArray).replace(/'/g, "&#39;");

                            return '<img src="' + cleanArray[0] + '" ' +
                                'alt="' + title + '" ' +
                                'class="festivalImg" ' +
                                'data-title="' + title + '" ' +
                                'data-images="' + festivalEscapeHtml(JSON.stringify(cleanArray)) + '" ' +
                                'style="max-height: 80px; width: 50px; cursor: pointer;" />';
                        }
                    },
                    {
                        data: 'videoPath1',
                        className: 'text-center',
                        render: function (data, type, row) {
                            if (!data) { return ''; }
                            var videoPath = festivalEscapeHtml(data);
                            var title = festivalEscapeHtml(row.Title || 'Festival Preview');
                            return '<div class="festivalVideoWrapper" style="cursor: pointer; display: inline-block;">' +
                                '<video src="../FestivalWishesImagesandVideos_Admin/' + videoPath + '" class="festivalVideo" data-title="' + title + '" style="width: 100px; height: 80px; border-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); pointer-events: none;"></video>' +
                                '</div>';
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

$(document).on('click', '.festivalImg', function () {
    var title = $(this).data('title') || 'Festival Preview';
    var imagesJson = $(this).attr('data-images');
    try {
        currentPreviewImages = JSON.parse(imagesJson);
    } catch (e) {
        console.error("JSON Parse Error:", e);
        currentPreviewImages = [$(this.src || $(this).attr('src'))];
    }

    if (!Array.isArray(currentPreviewImages) || currentPreviewImages.length === 0) {
        currentPreviewImages = [$(this).attr('src')];
    }

    currentImageIndex = 0;

    $('#adminfestivalTitle').text(title);
    $('#adminpreviewVideo').hide().attr('src', '');
    $('#adminpreviewImage').show();

    updateModalImageView();

    if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
        var myModal = new bootstrap.Modal(document.getElementById('adminimagePreviewModal'));
        myModal.show();
    } else {
        $('#adminimagePreviewModal').modal('show');
    }
});

function updateModalImageView() {
    if (currentPreviewImages.length === 0) return;

    $('#adminpreviewImage').attr('src', currentPreviewImages[currentImageIndex]);

    var dotsContainer = $('#imageDotsContainer');
    dotsContainer.empty();

    if (currentPreviewImages.length > 1) {
        dotsContainer.css({ 'display': 'flex', 'flex-wrap': 'wrap', 'justify-content': 'center', 'gap': '8px' });

        currentPreviewImages.forEach(function (imgUrl, i) {
            var isActive = (i === currentImageIndex);
            var dotStyle = 'cursor: pointer; width: 12px; height: 12px; border-radius: 50%; border: none; background-color: ' + (isActive ? '#0d6efd' : '#ccc') + '; transition: 0.2s;';

            var dotButton = $('<button type="button" class="img-dot" style="' + dotStyle + '"></button>');
            dotButton.on('click', function () {
                switchPreviewImage(i);
            });
            dotsContainer.append(dotButton);
        });
    } else {
        dotsContainer.hide();
    }
}

function switchPreviewImage(index) {
    currentImageIndex = index;
    updateModalImageView();
}

$(document).on('click', '.festivalVideoWrapper', function () {
    var videoTag = $(this).find('.festivalVideo');
    var videoSrc = videoTag.attr('src');
    var title = videoTag.data('title') || 'Festival Preview';

    $('#adminfestivalTitle').text(title);
    $('#imageDotsContainer').hide();

    $('#adminpreviewImage').hide().attr('src', '');
    $('#adminpreviewVideo').attr('src', videoSrc).show();

    $('#adminimagePreviewModal').modal('show');

    setTimeout(function () {
        $('#adminpreviewVideo')[0].play();
    }, 300);
});

$('#adminimagePreviewModal').on('hidden.bs.modal', function () {
    var videoElement = $('#adminpreviewVideo')[0];
    if (videoElement) {
        videoElement.pause();
        videoElement.src = "";
    }
    $('#imageDotsContainer').hide();
});

function adminfestWish_delete(id) {
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

        PageMethods.DeleteAdminFestivalData(
            id,
            function (response) {
                festivalShowAlert({
                    icon: 'error',
                    title: 'Deleted',
                    text: response
                }).then(function () {
                    festivaladmin_bindGrid();

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



let dataTransfer = new DataTransfer();

function previewSelectedFiles(input) {
    const maxFiles = 3;

    if (dataTransfer.files.length + input.files.length > maxFiles) {
        festivalShowAlert({
            icon: 'error',
            title: 'Error',
            text: `You can only upload a maximum of ${maxFiles} images.`
        });
        input.value = '';
        return;
    }

    for (let i = 0; i < input.files.length; i++) {
        dataTransfer.items.add(input.files[i]);
    }

    input.files = dataTransfer.files;

    renderFileList();
}

function renderFileList() {
    const input = document.getElementById('adminfestWish_attachment');
    const fileListContainer = document.getElementById('fileListContainer');
    const selectedFilesWrapper = document.getElementById('selectedFilesWrapper');
    const noFilesPlaceholder = document.getElementById('noFilesPlaceholder');
    const fileCountHeader = document.getElementById('fileCountHeader');

    fileListContainer.innerHTML = '';

    if (input.files.length === 0) {
        noFilesPlaceholder.style.display = 'flex';
        selectedFilesWrapper.style.display = 'none';
        return;
    }
    noFilesPlaceholder.style.display = 'none';
    selectedFilesWrapper.style.display = 'block';
    fileCountHeader.innerText = `UPLOADED FILES (${input.files.length})`;

    for (let i = 0; i < input.files.length; i++) {
        let file = input.files[i];
        let fileSizeKB = (file.size / 1024).toFixed(1);

        let cardHTML = `<div class="d-flex align-items-center justify-content-between p-2 mb-2 border rounded bg-white"><div><span>📄 <strong>${file.name}</strong></span><span class="badge bg-secondary ms-2">${fileSizeKB} KB</span></div><button type="button" class="btn btn-sm btn-danger" onclick="removeSingleFile(${i})">✕</button></div>`;
        fileListContainer.innerHTML += cardHTML;
    }
}

function removeSingleFile(index) {
    let input = document.getElementById('adminfestWish_attachment');
    let dt = new DataTransfer();

    for (let i = 0; i < input.files.length; i++) {
        if (i !== index) {
            dt.items.add(input.files[i]);
        }
    }
    dataTransfer = dt;
    input.files = dataTransfer.files;
    renderFileList();
}

function clearAllFiles() {
    let input = document.getElementById('adminfestWish_attachment');
    dataTransfer = new DataTransfer();
    input.files = dataTransfer.files;
    renderFileList();
}