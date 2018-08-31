function refreshContent(domXml) {
    const article = domXml.querySelector('article');
    const body = document.querySelector('body');
    
    body.innerHTML = article.outerHTML;
}

function selfReload(url) {
    const xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function() {
        if (4 === this.readyState) {
            const domXml = this.responseXML;
            const imgs = domXml.getElementsByTagName('img');
            const size = imgs.length;
            let count = 0;

            for (let i=0; i<size; ++i) {
                const img = imgs.item(i);
                const href = img.getAttribute('src');
                const cache = new Image();
                cache.onload = function() {
                    if (++count === size) {
                        refreshContent(domXml);
                    }
                }
                cache.src = href;
            }
        }
    }

    xhr.open('GET', url.toString(), true);
    xhr.send();
}


window.addEventListener('load', function(ev) {
    const url = new URL(window.location.href);

    url.search = new Date().getTime();

    window.setInterval(function() {
        selfReload(url);
    }, 10000);
});