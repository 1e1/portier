const REFRESH_INTERVAL = 2500;
const REFRESH_SELECTOR = '*[data-connector]';


/* =================================== */


const xhr = new XMLHttpRequest();
xhr._lock = false;

const selfReload = url => {
    if (false === xhr._lock) {
        xhr._lock = true;

        xhr.open('GET', url.toString(), true);
        xhr.send();
    }
}

const parseResponse = (domXml, callback) => {
    const imgs = domXml.getElementsByTagName('img');
    const size = imgs.length;

    if (0 === size) {
        callback(domXml);
    } else {
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
}

const refreshNode = (currentNode, newNode) => {
    if (currentNode.childElementCount !== newNode.childElementCount) {
        currentNode.innerHTML = newNode.innerHTML;

        return true;
    }

    if (currentNode.textContent != newNode.textContent) {
        currentNode.innerHTML = newNode.innerHTML;

        return true;
    }

    return false;
}

const makeIcon = (size) => {
    const canvas   = document.createElement('canvas');
    const ctx      = canvas.getContext('2d');
    const textSize = Math.round(size / 2);
    const angle    = Math.round(1000 * Math.PI/4) / 1000;
    const date     = new Date();
    const hour     = date.getHours();
    const minute   = ('00' + date.getMinutes()).slice(-2);

    const x_text = size / 2;
    const y_text = size / 2;

    canvas.width = size;
    canvas.height = size;

    ctx.fillStyle='#EEE';
    ctx.fillRect(0, 0, size, size); 

    ctx.font = `${textSize}px mono`;
    ctx.fillStyle    = '#000';
    ctx.textAlign    = 'center';
    ctx.textBaseline = 'middle';
    ctx.translate(x_text, y_text);
    ctx.save();

    ctx.rotate(-angle);
    ctx.fillText(`${hour}:${minute}`, 0, 0);

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
            xhr._lock = false;

            const domXml = target.responseXML;

            if (null !== domXml) {
                parseResponse(domXml, setConnectors);
            }
        }
    }

    window.scrollTo(0, 1);
    window.setInterval(() => {
        //url.search = new Date().getTime();
        selfReload(url);
    }, REFRESH_INTERVAL);
});
