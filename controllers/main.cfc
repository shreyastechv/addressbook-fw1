component accessors=true {
    property addressbookService;
    function default() {
        param name="rc.contacts" default=[];
        param name="rc.roles" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            userId = 1
        );

        local.roles = variables.addressbookService.fetchRoles();

        rc.contacts = local.contacts.data;
        rc.roles = local.roles.data;
    }
}
