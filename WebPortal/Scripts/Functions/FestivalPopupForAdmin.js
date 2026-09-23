//<--------------(Arti Changes(YTU))Admin Festival Wish PopUp------------->
$(document).ready(function () {
    var todayDate = new Date().toISOString().split('T')[0];

    $.ajax({
        type: "POST",
        url: "FestivalsWishesMasterForAdmin.aspx/GetPopupWishForCurrentUser",
        data: JSON.stringify({ currentDate: todayDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = response.d;
            if (data != null) {
                var mediaList = [];
                
                if (data.ImagePaths) {
                    for (var i = 0; i < data.ImagePaths.length; i++) {
                        mediaList.push({
                            type: 'img',
                            src: data.ImagePaths[i],
                            title: (data.Titles && data.Titles[i]) ? data.Titles[i] : data.Title
                        });
                    }
                }

                if (data.VideoPaths) {
                    for (var j = 0; j < data.VideoPaths.length; j++) {
                        mediaList.push({
                            type: 'vid',
                            src: data.VideoPaths[j],
                            title: (data.VideoTitles && data.VideoTitles[j]) ? data.VideoTitles[j] : data.Title
                        });
                    }
                }

                if (mediaList.length > 0) {
                    showMedia(0, mediaList);
                    $('#adminimagePreviewModalpopup').modal('show');
                }
            }
        }
    });
});
var globalMediaList = [];
var adminfestival_currentIndex = 0;
function showMedia(idx, list) {
    globalMediaList = list; 
    adminfestival_currentIndex = idx;
    var box = $('#adminMediaBox').empty();
    var dots = $('#adminDotsBox').empty();

    var curr = list[idx];
    $('#adminfestivalTitlepopup').text(curr.title);

    if (curr.type === 'img') {
        box.html('<img src="' + curr.src + '" class="rounded" style="width: 100%; height: 100%; object-fit: contain;" />');
    } else {
        box.html('<video controls class="rounded" style="width: 100%; height: 100%; object-fit: contain;"><source src="' + curr.src + '" type="video/mp4" /></video>');
    }

    if (list.length > 1) {
        for (var i = 0; i < list.length; i++) {
            var color = (i === idx) ? '#007bff' : '#ccc';
            var dot = $('<span style="width:10px;height:10px;background:' + color + ';border-radius:50%;display:inline-block;cursor:pointer;" data-i="' + i + '"></span>');
            dot.click(function () { showMedia(parseInt($(this).attr('data-i')), list); });
            dots.append(dot);
        }
    }
}

function changeMedia(direction) {
    if (globalMediaList.length > 1) {
        adminfestival_currentIndex = (adminfestival_currentIndex + direction + globalMediaList.length) % globalMediaList.length;
        showMedia(adminfestival_currentIndex, globalMediaList);
    }
}