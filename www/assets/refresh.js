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

const parseResponse = (target) => {
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

    //xhr.responseType = 'document';
    xhr.overrideMimeType('application/xml');
    xhr.onreadystatechange = (rsc) => {
        const target = rsc.target;

        if (4 === target.readyState) {
            const domXml = target.responseXML;

            if (null !== domXml) {
                const hashCode = domXml.innerHTML.hashCode();
            
                if (previousHashCode !== hashCode) {
                    previousHashCode = hashCode;

                    parseResponse(target, previousHashCode);
                }
            }
        }
    }

    window.setInterval(() => {
        //url.search = new Date().getTime();
        selfReload(url);
    }, 2500);
});
