component accessors=true {
    property addressbookService;
    function default() {
        param name="rc.contacts" default=queryNew("");
        rc.contacts = variables.addressbookService.fetchContacts();
    }
}
