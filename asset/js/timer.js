(function() {
    const LOCK_AFTER = 5 * 60;
    const LOGOUT_AFTER = 10 * 60;

    let idleTime = 0;
    let isLocked = false;

    function resetTimer() {
        idleTime = 0;
        sessionStorage.removeItem('locked');
    }
    ['mousemove', 'keypress', 'click', 'scroll', 'touchstart'].forEach(event => {
        document.addEventListener(event, resetTimer);
    });
    
    setInterval(() => {
        idleTime++;

        if (idleTime >= LOCK_AFTER && !isLocked) {
            isLocked = true;
            sessionStorage.setItem('locked', 'true');
            window.location.href = "request.php?tkn=" + window.encodedLockPage;
        }

        if (idleTime >= LOGOUT_AFTER) {
            sessionStorage.removeItem('locked');
            window.location.href = "request.php?tkn=" + window.encodedLogoutPage + "&info=You were logged out for inactivity.";
        }
    }, 1000);

    setInterval(() => {
        fetch('timeout-check.php')
            .then(r => r.json())
            .then(res => {
                if (res.action === 'logout') {
                    window.location.href = "request.php?tkn=" + window.encodedLogoutPage + "&info=You were logged out for inactivity.";
                } else if (res.action === 'lock') {
                    window.location.href = "request.php?tkn=" + window.encodedLockPage;
                }
            })
            .catch(() => {});
    }, 120000);
})();