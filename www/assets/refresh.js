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

        cache.onload = () => {
            if (++count === size) {
                callback(domXml);
            }
        }
        cache.src = href;
    }
}

const refreshNode = (currentNode, newNode) => {
    if (currentNode.textContent != newNode.textContent) {
        currentNode.innerHTML = newNode.innerHTML;

        return true;
    }

    return false;
}

const makeIcon = (size) => {
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const textSize = Math.round(size * 0.75);
    const text = (new Date()).getMinutes();

    canvas.width = size;
    canvas.height = size;

    ctx.fillStyle='#EEE';
    ctx.fillRect(0, 0, size, size); 

    ctx.font = `${textSize}px mono`;
    ctx.fillStyle    = '#000';
    ctx.textAlign    = 'center';
    ctx.textBaseline = 'middle'; 
    ctx.fillText(text, canvas.width/2, canvas.height/2);

    return canvas.toDataURL('image/png');
}

const updateFavicon = () => {
    const head = document.querySelector('head');

    let link = head.querySelector('link[rel="icon"]');

    if (null===link) {
        link = document.createElement('link');
        link.setAttribute('rel', 'icon');

        head.appendChild(link);
    }

    link.href = makeIcon(64);
}

const setConnectors = (domXml) => {
    const currentNodes = document.querySelectorAll(REFRESH_SELECTOR);
    const newNodes = domXml.querySelectorAll(REFRESH_SELECTOR);

    if (currentNodes.length !== newNodes.length) {
        window.top.location.reload(true);
    }

    let hasUpdate = false;

    for (let i=0; i<currentNodes.length; ++i) {
        const currentNode = currentNodes[i];
        const newNode = newNodes[i];
        const isUpdated = refreshNode(currentNode, newNode);

        hasUpdate |= isUpdated;
    }

    if (hasUpdate) {
        updateFavicon();
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
