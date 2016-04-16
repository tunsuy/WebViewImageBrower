function setImages () {
	var images = document.getElementsByTagName("img");
	for (var i = 0; i < images.length; i++) {
		images[i].setAttribute("onClick", "imageClick("+i+")");
	}
    return images[0].getAttribute("onClick").toString();
}

function imageClick (i) {
	var url = "com.sangfor.pocket::"+i;
	window.location.hash = url;
}

function getAllImageUrl () {
	var imgs = document.getElementsByTagName("img");
    var urlArray = [];
    for (var i=0;i<imgs.length;i++){
       var src = imgs[i].src;
       urlArray.push(src);
    }
    return urlArray.toString();
}