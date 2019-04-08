if (window.location.href == "https://www.reddit.com/r/philippines/") {
    var elements = document.getElementsByTagName("body");

    for (var i = 0; i < elements.length; i++) {
        elements[i].style.display = "none";
    }

    document.body.style.backgroundColor = "black";
}
