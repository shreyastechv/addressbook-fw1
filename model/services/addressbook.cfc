 component {
     function fetchContacts(integer userId = 0) {
        local.response = {
            "success" = true,
            "data" = [],
            "message" = ""
        };

        try{
            local.qryGetContacts = queryExecute(
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
                    createdBy = :userId
                    AND active = 1",
                {
                    userId = { value = arguments.userId, cfsqltype = "integer" }
                },
                {datasource = "addressbookdatasource"}
            );

            for (row in local.qryGetContacts) {
                arrayAppend(local.response.data, {
                    "contactId" = row.contactid,
                    "firstName" = row.firstname,
                    "lastName" = row.lastname,
                    "contactPicture" = row.contactpicture,
                    "email" = row.email,
                    "phone" = row.phone
                });
            }
        }
        catch (any e) {
            local.response.success = false;
            return local.response;
        }

        return local.response;
    }
}
