const REFRESH_INTERVAL = 2500;
const REFRESH_SELECTOR = '*[data-connector]';


/* =================================== */


const xhr = new XMLHttpRequest();

const selfReload = url => {
    xhr.open('GET', url.toString(), true);
    xhr.send();
}

const parseResponse = (domXml, callback) => {
    const imgs = domXml.getElementsByTagName('img');
    const size = imgs.length;
    let count = 0;

    for (let i=0; i<size; ++i) {
        const img = imgs.item(i);
        const href = img.getAttribute('src');
        const cache = new Image();

        cache.onload = function() {
            if (++count === size) {
                callback(domXml);
            }
        }
        cache.src = href;
    }
}

const setConnectors = (domXml) => {
    const currentNodes = document.querySelectorAll(REFRESH_SELECTOR);
    const newNodes = domXml.querySelectorAll(REFRESH_SELECTOR);

    if (currentNodes.length !== newNodes.length) {
        window.top.location.reload(true);
    }

    for (let i=0; i<currentNodes.length; ++i) {
        const currentNode = currentNodes[i];
        const newNode = newNodes[i];

        if (currentNode.innerHTML !== newNode.innerHTML) {
            currentNode.innerHTML = newNode.innerHTML;
        }
    }
}

window.addEventListener('load', ev => {
    const url = new URL(window.location.href);

    //xhr.responseType = 'document';
    xhr.overrideMimeType('application/xml');
    xhr.onreadystatechange = (rsc) => {
        const target = rsc.target;

        if (4 === target.readyState) {
            const domXml = target.responseXML;

            if (null !== domXml) {
                parseResponse(domXml, setConnectors);
            }
        }
    }

    window.setInterval(() => {
        //url.search = new Date().getTime();
        selfReload(url);
    }, REFRESH_INTERVAL);
});
