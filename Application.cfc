component extends="framework.one" {
    this.sessionManagement = true;
    this.sessiontimeout = CreateTimeSpan(0, 1, 0, 0);

    function setupRequest() {
        /* Page redirects are handled in the below controller */
        controller('security.checkAuthorization');
    }

    variables.framework = {
        defaultItem = "default",
        reloadApplicationOnEveryRequest = true,
        trace = false,
        generateSES = false
    }
}