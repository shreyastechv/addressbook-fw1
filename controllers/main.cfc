component accessors=true {
    property addressbookService;

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

    remote array function fetchContacts(integer contactId = 0) returnFormat = "JSON" {
        param name="local.contacts.data" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            contactId = contactId
        );

        return local.contacts.data;
    }
}
