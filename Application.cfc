component extends="framework.one" {
    this.sessionManagement = true;

    function setupRequest() {
        /* Page redirects are handled in the below controller */
        controller('security.checkAuthorization');
    }
}