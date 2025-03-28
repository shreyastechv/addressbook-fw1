component accessors=true {
    property addressbookService;

    function init( fw ) {
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
        rc.contactsAll = local.contacts;
        rc.roles = local.roles.data;
    }

    public string function fetchContacts(struct rc) {
        param name="local.contacts.data" default=[];
        local.contacts = variables.addressbookService.fetchContacts(
            contactId = rc.contactId
        );

        variables.fw.renderData( "json", local.contacts );
    }
}
