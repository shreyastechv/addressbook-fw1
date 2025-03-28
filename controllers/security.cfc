component {
    function init(fw) {
        variables.fw=arguments.fw;
        return this;
    }

    function checkAuthorization(struct rc) {
        /* Define page types */
        local.initialPages = ["main.login", "main.signup"];
        local.loginUserPages = ["main.default"];

        /* Handle page redirects */
        if (arrayFindNoCase(local.initialPages, rc.action)) {
            if (structKeyExists(session, "isLoggedIn") && session.isLoggedIn) {
                variables.fw.redirect('main.default');
            }
        } else if (arrayFindNoCase(local.loginUserPages, rc.action)) {
            if (structKeyExists(session, "isLoggedIn") == false || session.isLoggedIn == false) {
                variables.fw.redirect('main.login');
            }
        }
    }
}