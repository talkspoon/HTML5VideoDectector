var h5vd_init = function() {
    var h5vd = document.createElement('script');
    h5vd.type = 'text/javascript';
    h5vd.async = true;
    h5vd.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.alanz.org/h5vd/detector.js';
    var s = document.getElementsByTagName('script')[0];
    if (s) {
        s.parentNode.insertBefore(h5vd, s);
    } else {
        setTimeout(function(){h5vd_init();}, 100);
    }
};
h5vd_init();