/*
window.addEventListener('load', function(ev) {
    const xhr = new XMLHttpRequest();
    const body = document.body;

    xhr.onreadystatechange = function() {
        if(4 === xhr.readyState && 200 === xhr.status) {
            const xmlDoc = xhr.responseXML;
            const imgs = xmlDoc.getElementsByTagName('img');
            const imgsSize = imgs.length;
            const articles = xmlDoc.getElementsByTagName('article');
            const articlesSize = articles.length;

            let imagesLeft = imgsSize;

            for (let i=0; i<imgsSize; i++) {
                const img = imgs.item(i);
                const cache = new Image();

                cache.onload = function() {
                    if (0 === --imagesLeft) {
                        for (let j=0; j<articlesSize; j++) {
                            const article = articles.item(j);
                            body.appendChild(article);
                        }

                        console.log("refresh");
            
                        while (body.childNodes.length > articlesSize) {
                            body.removeChild(body.firstChild);
                        }
                    }
                }

                console.log("src="+img.getAttribute("src"));

                cache.src = img.getAttribute("src");
            }
        }
    }

    window.setInterval(function() {
        xhr.open('GET', './index.html', true);
        xhr.send();
    }, 3000);
});
*/