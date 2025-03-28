<cfcomponent displayname="addressbookComponent" hint="This contains functions that are used by addressbook website">
    <cffunction name="fetchContacts" access="public" returntype="struct">
        <cfargument name="userId" type="integer" required="false" default="0">
        <cfargument name="contactId" type="integer" required="false" default="0">

        <cfset local.response = {
            "success" = true,
            "data" = []
        }>

        <cftry>
            <cfquery name="local.qryGetContacts" datasource="addressbookdatasource">
                <cfif val(arguments.contactId) EQ 0>
                    SELECT
                        contactid,
                        firstname,
                        lastname,
                        contactpicture,
                        email,
                        phone
                    FROM
                        contactDetails
                    WHERE
                        createdBy = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
                        AND active = 1
                <cfelse>
                    SELECT
                        cd.contactid,
                        cd.title,
                        cd.firstname,
                        cd.lastname,
                        cd.gender,
                        cd.dob,
                        cd.contactpicture,
                        cd.address,
                        cd.street,
                        cd.district,
                        cd.state,
                        cd.country,
                        cd.pincode,
                        cd.email,
                        cd.phone,
                        ISNULL(STRING_AGG(CONVERT(VARCHAR(36), cr.roleId), ','), '') AS roleIds,
                        ISNULL(STRING_AGG(rd.roleName, ','), '') AS roleNames
                    FROM
                        contactDetails cd
                        LEFT JOIN contactRoles cr ON cd.contactid = cr.contactId AND cr.active = 1
                        LEFT JOIN roleDetails rd ON cr.roleId = rd.roleId
                    WHERE
                        cd.contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "cf_sql_integer">
                    GROUP BY
                        cd.contactid,
                        cd.title,
                        cd.firstname,
                        cd.lastname,
                        cd.gender,
                        cd.dob,
                        cd.contactpicture,
                        cd.address,
                        cd.street,
                        cd.district,
                        cd.state,
                        cd.country,
                        cd.pincode,
                        cd.email,
                        cd.phone
                </cfif>
            </cfquery>

            <cfloop query="local.qryGetContacts">
                <cfif val(arguments.contactId) EQ 0>
                    <cfset arrayAppend(local.response.data, {
                        "contactId" = local.qryGetContacts.contactid,
                        "firstName" = local.qryGetContacts.firstname,
                        "lastName" = local.qryGetContacts.lastname,
                        "contactPicture" = local.qryGetContacts.contactpicture,
                        "email" = local.qryGetContacts.email,
                        "phone" = local.qryGetContacts.phone
                    })>
                <cfelse>
                    <cfset arrayAppend(local.response.data, {
                        "contactid" = local.qryGetContacts.contactid,
                        "title" = local.qryGetContacts.title,
                        "firstname" = local.qryGetContacts.firstname,
                        "lastname" = local.qryGetContacts.lastname,
                        "gender" = local.qryGetContacts.gender,
                        "dob" = local.qryGetContacts.dob,
                        "contactpicture" = local.qryGetContacts.contactpicture,
                        "address" = local.qryGetContacts.address,
                        "street" = local.qryGetContacts.street,
                        "district" = local.qryGetContacts.district,
                        "state" = local.qryGetContacts.state,
                        "country" = local.qryGetContacts.country,
                        "pincode" = local.qryGetContacts.pincode,
                        "email" = local.qryGetContacts.email,
                        "phone" = local.qryGetContacts.phone,
                        "roleIds" = listToArray(local.qryGetContacts.roleIds),
                        "roleNames" = local.qryGetContacts.roleNames
                    })>
                </cfif>
            </cfloop>

            <cfcatch type="any">
                <cfset local.response.success = false>
                <cfreturn local.response>
            </cfcatch>
        </cftry>

        <cfreturn local.response>
    </cffunction>

    <cffunction  name="fetchRoles" returnType="struct" access="public">
        <cfset local.response = {
            "success" = true,
            "data" = []
        }>

        <cftry>
            <cfquery name="local.qryGetRoles" datasource="addressbookdatasource">
                SELECT
                    roleId,
                    roleName
                FROM
                    roleDetails
            </cfquery>

            <cfloop query="local.qryGetRoles">
                <cfset arrayAppend(local.response.data, {
                    "roleId" = local.qryGetRoles.roleId,
                    "roleName" = local.qryGetRoles.roleName
                })>
            </cfloop>

            <cfcatch type="any">
                <cfset local.response.success = false>
                <cfreturn local.response>
            </cfcatch>
        </cftry>

        <cfreturn local.response>
    </cffunction>
</cfcomponent>