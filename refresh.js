window.addEventListener('load', function(ev) {
    const nextUrl = './index.html?' + new Date().getTime();

    window.setTimeout(function() {
        const prerender = document.createElement('link');
        
        prerender.setAttribute('rel', 'prerender');
        prerender.setAttribute('href', nextUrl);

        document.head.appendChild(prerender);

        window.setTimeout(function() {
            window.top.location.href = nextUrl;
        }, 5000)
    }, 25000);
});