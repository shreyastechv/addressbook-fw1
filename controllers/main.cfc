component accessors=true {
    property addressbookService;

    function init(fw) {
        variables.fw=arguments.fw;
        return this;
    }

    function default() {
        param name="rc.contacts.data" default=[];
        param name="rc.roles.data" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            userId = 1
        );

        local.roles = variables.addressbookService.fetchRoles();

        rc.contacts = local.contacts.data;
        rc.roles = local.roles.data;
    }

    function login(struct rc) {
        param name="rc.loginMsg" default="";
        param name="rc.username" default="";
        param name="rc.password" default="";

        if(structKeyExists(rc, "loginBtn")) {
            local.loginResult = variables.addressbookService.login(
                username = rc.username,
                password = rc.password
            );

            rc.loginMsg = local.loginResult.message;
            if (local.loginResult.success) {
                variables.fw.redirect('main.default');
            }
        }
    }

    public string function fetchContacts(struct rc) {
        param name="local.contacts.data" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            contactId = rc.contactId
        );

        variables.fw.renderData( "json", local.contacts );
    }

    public string function logout() {
        local.response = { "success" = false };

        structClear(session);
        local.response.success = true;

        variables.fw.renderData( "json", local.response );
    }
}
