<cfcomponent displayname="addressbookComponent" hint="This contains functions that are used by addressbook website">
    <cffunction name="fetchContacts" access="public" returntype="struct">
        <cfargument name="userId" type="integer" default="0">

        <cfset local.response = {
            "success" = true,
            "data" = []
        }>

        <cftry>
            <cfquery name="local.qryGetRoles" datasource="addressbookdatasource">
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
            </cfquery>

            <cfloop query="local.qryGetRoles">
                <cfset arrayAppend(local.response.data, {
                    "contactId" = local.qryGetRoles.contactid,
                    "firstName" = local.qryGetRoles.firstname,
                    "lastName" = local.qryGetRoles.lastname,
                    "contactPicture" = local.qryGetRoles.contactpicture,
                    "email" = local.qryGetRoles.email,
                    "phone" = local.qryGetRoles.phone
                })>
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
            <cfquery name="local.qryGetRoles">
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