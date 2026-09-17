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
                    var imgCounter = 0;
                    data.ImagePaths.forEach(p => {
                        mediaList.push({
                            type: 'img',
                            src: p,
                            title: (data.Titles && data.Titles[imgCounter]) ? data.Titles[imgCounter] : data.Title
                        });
                        imgCounter++;
                    });
                }

                if (data.VideoPaths) {
                    var vidCounter = 0;
                    data.VideoPaths.forEach(p => {
                        mediaList.push({
                            type: 'vid',
                            src: p,
                            title: (data.Titles && data.Titles[vidCounter]) ? data.Titles[vidCounter] : data.Title
                        });
                        vidCounter++;
                    });
                }

                if (mediaList.length > 0) {
                    showMedia(0, mediaList);
                    $('#adminimagePreviewModalpopup').modal('show');
                }
            }
        }
    });
});

function showMedia(idx, list) {
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