component accessors=true {
    property addressbookService;
    function default() {
        param name="rc.contacts" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            userId = 1
        );

        rc.contacts = local.contacts.data;
    }
}
