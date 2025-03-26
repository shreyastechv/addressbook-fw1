 component {
     function fetchContacts() {
        myQuery = queryExecute(
            "SELECT
                contactid,
                firstname,
                lastname,
                contactpicture,
                email,
                phone
            FROM
                contactDetails
            WHERE
                createdBy = 1
                AND active = 1",
            {},
            {datasource = "addressbookdatasource"}
        );

        return myQuery;
    }
}
