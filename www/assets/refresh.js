const xhr = new XMLHttpRequest();

const refreshContent = (domXml) => {
    const article = domXml.querySelector('article');
    const body = document.querySelector('body');
    
    body.innerHTML = article.outerHTML;
}

const selfReload = url => {
    xhr.open('GET', url.toString(), true);
    xhr.send();
}

String.prototype.hashCode = function() {
    let hash = 0;
    for (let i = 0; i < this.length; i++) {
        const chr   = this.charCodeAt(i);
        hash  = ((hash << 5) - hash) + chr;
        hash |= 0; // Convert to 32bit integer
    }

    return hash;
}

window.addEventListener('load', ev => {
    const url = new URL(window.location.href);
    let previousHashCode = 0;

    xhr.onreadystatechange = (rsc) => {
        const target = rsc.target;

        if (4 === target.readyState) {
            const hashCode = target.responseText.hashCode();

            if (previousHashCode !== hashCode) {
                previousHashCode = hashCode;

                const domXml = target.responseXML;
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
    }

    window.setInterval(() => {
        //url.search = new Date().getTime();
        selfReload(url);
    }, 2500);
});
