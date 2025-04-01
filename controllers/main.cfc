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
            userId = session.userId
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

    public string function modifyContacts(struct rc) {
        local.response = {
            "success" = false,
            "message" = ""
        }

        if (!structKeyExists(session, "isLoggedIn")) {
            local.response.success = false;
            local.response.message = "User not logged in!";
            variables.fw.renderData( "json", local.response );
            return;
        }

        local.response = variables.addressbookService.modifyContacts(
            contactId = rc.contactId,
            contactTitle = rc.contactTitle,
            contactFirstName = rc.contactFirstName,
            contactLastName = rc.contactLastName,
            contactGender = rc.contactGender,
            contactDOB = rc.contactDOB,
            contactImage = rc.contactImage,
            contactAddress = rc.contactAddress,
            contactStreet = rc.contactStreet,
            contactDistrict = rc.contactDistrict,
            contactState = rc.contactState,
            contactCountry = rc.contactCountry,
            contactPincode = rc.contactPincode,
            contactEmail = rc.contactEmail,
            contactPhone = rc.contactPhone,
            roleIdsToInsert = rc.roleIdsToInsert,
            roleIdsToDelete = rc.roleIdsToDelete
        );

        variables.fw.renderData( "json", local.response );
    }
}
