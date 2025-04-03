<cfcomponent displayname="addressbookComponent" hint="This contains functions that are used by addressbook website">
    <cffunction name="signup" returnType="struct" access="public">
        <cfargument required="true" name="fullName" type="string">
        <cfargument required="true" name="email" type="string">
        <cfargument required="true" name="userName" type="string">
        <cfargument required="true" name="password" type="string">

        <cfset local.hashedPassword = Hash(password, "SHA-256")>
        <cfset local.response = {
            "success" = false,
            "message" = ""
        }>

       <cfquery name="local.checkUsernameAndEmail" datasource="addressbookdatasource">
            SELECT
				username
			FROM
				users
			WHERE
				username = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
				OR email = <cfqueryparam value = "#arguments.email#" cfsqltype = "cf_sql_varchar">
        </cfquery>

		<cfif local.checkUsernameAndEmail.RecordCount>
            <cfset local.response.message = "Email or Username already exists!">
		<cfelse>
            <cffile action="upload" destination="#expandpath("/assets/profilePictures")#" fileField="profilePicture" nameconflict="MakeUnique">
            <cfset local.profilePictureName = cffile.serverFile>
            <cfquery name="local.addUser" datasource="addressbookdatasource">
                INSERT INTO
					users (
						fullname,
						email,
						username,
						pwd,
						profilePicture
					)
				VALUES (
					<cfqueryparam value = "#arguments.fullName#" cfsqltype = "cf_sql_varchar">,
					<cfqueryparam value = "#arguments.email#" cfsqltype = "cf_sql_varchar">,
					<cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">,
					<cfqueryparam value = "#local.hashedPassword#" cfsqltype = "cf_sql_char">,
					<cfqueryparam value = "#local.profilePictureName#" cfsqltype = "cf_sql_varchar">
				)
            </cfquery>
            <cfset local.response.success = true>
        </cfif>

        <cfreturn local.response>
    </cffunction>

    <cffunction name="login" returnType="struct" access="public">
        <cfargument required="true" name="userName" type="string">
        <cfargument required="true" name="password" type="string">

        <cfset local.response = {
            "success" = false,
            "message" = ""
        }>

        <cftry>
            <cfquery name="local.getUserDetails" datasource="addressbookdatasource">
                SELECT
                    userid,
                    username,
                    fullname,
                    profilepicture
                FROM
                    users
                WHERE
                    username = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
                    AND pwd = <cfqueryparam value = "#Hash(password, "SHA-256")#" cfsqltype = "cf_sql_varchar">
            </cfquery>

            <cfif local.getUserDetails.RecordCount EQ 0>
                <cfset local.response.message = "Wrong username or password!">
            <cfelse>
                <cfset session.isLoggedIn = true>
                <cfset session.userId = local.getUserDetails.userId>
                <cfset session.fullName = local.getUserDetails.fullname>
                <cfset session.profilePicture = local.getUserDetails.profilepicture>
            </cfif>

            <cfcatch type="any">
                <cfreturn local.response>
            </cfcatch>
        </cftry>

        <cfset local.response.success = true>
        <cfreturn local.response>
    </cffunction>

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
                        "contactId" = local.qryGetContacts.contactid,
                        "title" = local.qryGetContacts.title,
                        "firstName" = local.qryGetContacts.firstname,
                        "lastName" = local.qryGetContacts.lastname,
                        "gender" = local.qryGetContacts.gender,
                        "dob" = local.qryGetContacts.dob,
                        "contactPicture" = local.qryGetContacts.contactpicture,
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

    <cffunction name="modifyContacts" returnType="struct" access="public">
        <cfargument required="true" name="contactId" type="string">
        <cfargument required="true" name="contactTitle" type="string">
        <cfargument required="true" name="contactFirstName" type="string">
        <cfargument required="true" name="contactLastName" type="string">
        <cfargument required="true" name="contactGender" type="string">
        <cfargument required="true" name="contactDOB" type="string">
        <cfargument required="true" name="contactImage" type="string">
        <cfargument required="true" name="contactAddress" type="string">
        <cfargument required="true" name="contactStreet" type="string">
        <cfargument required="true" name="contactDistrict" type="string">
        <cfargument required="true" name="contactState" type="string">
        <cfargument required="true" name="contactCountry" type="string">
        <cfargument required="true" name="contactPincode" type="string">
        <cfargument required="true" name="contactEmail" type="string">
        <cfargument required="true" name="contactPhone" type="string">
        <cfargument required="true" name="roleIdsToInsert" type="string">
        <cfargument required="true" name="roleIdsToDelete" type="string">

        <cfset local.response = {
            "success" = false,
            "message" = ""
        }>
        <cfset local.contactImage = "demo-contact-image.jpg">

        <cfquery name="local.getEmailPhoneQuery" datasource="addressbookdatasource">
            SELECT
                contactid
            FROM
                contactDetails
            WHERE
                createdBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                AND email = <cfqueryparam value = "#arguments.contactEmail#" cfsqltype = "cf_sql_varchar">
                AND active = 1
        </cfquery>

        <cfif local.getEmailPhoneQuery.RecordCount AND local.getEmailPhoneQuery.contactid NEQ arguments.contactId>
            <cfset local.response["message"] = "Email id already exists">
        <cfelse>
            <cfif arguments.contactImage NEQ "">
                <cffile action="upload" destination="#expandpath("/assets/contactImages")#" fileField="contactImage" nameconflict="MakeUnique">
                <cfset local.contactImage = cffile.serverFile>
            </cfif>
            <cfif len(trim(arguments.contactId)) EQ 0>
                <cfquery name="local.insertContactsQuery" result="local.insertContactsResult" datasource="addressbookdatasource">
                    INSERT INTO
                        contactDetails (
                            title,
                            firstname,
                            lastname,
                            gender,
                            dob,
                            contactpicture,
                            address,
                            street,
                            district,
                            state,
                            country,
                            pincode,
                            email,
                            phone,
                            createdBy
                        )
                    VALUES (
                        <cfqueryparam value = "#arguments.contactTitle#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactFirstName#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactLastName#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactGender#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactDOB#" cfsqltype = "cf_sql_date">,
                        <cfqueryparam value = "#local.contactImage#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactAddress#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactStreet#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactDistrict#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactState#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactCountry#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactPincode#" cfsqltype = "cf_sql_char">,
                        <cfqueryparam value = "#arguments.contactEmail#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.contactPhone#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                    );
                </cfquery>

                <cfif len(trim(arguments.roleIdsToInsert))>
                    <cfquery name="local.addRolesQuery" datasource="addressbookdatasource">
                        INSERT INTO
                            contactRoles (
                                contactId,
                                roleId
                            )
                        VALUES
                        <cfloop list="#arguments.roleIdsToInsert#" index="local.i" item="local.roleId">
                            (
                                <cfqueryparam value="#local.insertContactsResult.GENERATEDKEY#" cfsqltype="cf_sql_integer">,
                                <cfqueryparam value="#trim(local.roleId)#" cfsqltype="cf_sql_integer">
                            )
                            <cfif local.i LT listLen(arguments.roleIdsToInsert)>,</cfif>
                        </cfloop>
                    </cfquery>
                </cfif>

                <cfset local.response["message"] = "Contact Added Successfully">
            <cfelse>
                <cfquery name="local.updateContactDetailsQuery" datasource="addressbookdatasource">
                    UPDATE
                        contactDetails
                    SET
                        title = <cfqueryparam value = "#arguments.contactTitle#" cfsqltype = "cf_sql_varchar">,
                        firstName = <cfqueryparam value = "#arguments.contactFirstName#" cfsqltype = "cf_sql_varchar">,
                        lastName = <cfqueryparam value = "#arguments.contactLastName#" cfsqltype = "cf_sql_varchar">,
                        gender = <cfqueryparam value = "#arguments.contactGender#" cfsqltype = "cf_sql_varchar">,
                        dob = <cfqueryparam value = "#arguments.contactDOB#" cfsqltype = "cf_sql_date">,
                        address = <cfqueryparam value = "#arguments.contactAddress#" cfsqltype = "cf_sql_varchar">,
                        street = <cfqueryparam value = "#arguments.contactStreet#" cfsqltype = "cf_sql_varchar">,
                        district = <cfqueryparam value = "#arguments.contactDistrict#" cfsqltype = "cf_sql_varchar">,
                        STATE = <cfqueryparam value = "#arguments.contactState#" cfsqltype = "cf_sql_varchar">,
                        country = <cfqueryparam value = "#arguments.contactCountry#" cfsqltype = "cf_sql_varchar">,
                        pincode = <cfqueryparam value = "#arguments.contactPincode#" cfsqltype = "cf_sql_varchar">,
                        email = <cfqueryparam value = "#arguments.contactEmail#" cfsqltype = "cf_sql_varchar">,
                        phone = <cfqueryparam value = "#arguments.contactPhone#" cfsqltype = "cf_sql_varchar">,
                        <cfif arguments.contactImage NEQ "">
                            contactpicture = <cfqueryparam value = "#local.contactImage#" cfsqltype = "cf_sql_varchar">,
                        </cfif>
                        updatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                    WHERE
                        contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "cf_sql_integer">
                </cfquery>

                <cfquery name="local.deleteRoleQuery" datasource="addressbookdatasource">
                    UPDATE
                        contactRoles
                    SET
                        active = 0,
                        deletedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_varchar">
                    WHERE
                        contactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
                        AND roleId IN (
                            <cfqueryparam value="#arguments.roleIdsToDelete#" cfsqltype="cf_sql_varchar" list="true">
                        )
                </cfquery>

                <cfif len(trim(arguments.roleIdsToInsert))>
                    <cfquery name="local.addRolesQuery" datasource="addressbookdatasource">
                        INSERT INTO
                            contactRoles (
                                contactId,
                                roleId
                            )
                        VALUES
                        <cfloop list="#arguments.roleIdsToInsert#" index="local.i" item="local.roleId">
                            (
                                <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">,
                                <cfqueryparam value="#trim(local.roleId)#" cfsqltype="cf_sql_integer">
                            )
                            <cfif local.i LT listLen(arguments.roleIdsToInsert)>,</cfif>
                        </cfloop>
                    </cfquery>
                </cfif>

                <cfset local.response["message"] = "Contact Updated Successfully">
            </cfif>
        </cfif>

        <cfset local.response.success = true>
        <cfreturn local.response>
    </cffunction>

    <cffunction name="deleteContact" returnType="struct" access="public">
        <cfargument required="true" name="contactId" type="string">
        <cfargument required="true" name="userId" type="string">

        <cfset local.response = {
            "success" = false,
            "message" = ""
        }>

        <cfquery name="local.deleteContactQuery">
            BEGIN TRANSACTION;

            -- Get Contact Picture Filename
            SELECT
                contactpicture
            FROM
                contactDetails
            WHERE
                contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "cf_sql_varchar">

            -- Delete from contactRoles
            UPDATE
                contactRoles
            SET
                active = 0,
                deletedBy = <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_varchar">
            WHERE
                contactId = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "cf_sql_integer">;

            -- Update contactDetails
            UPDATE
                contactDetails
            SET
                active = 0,
                deletedBy = <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_varchar">
            WHERE
                contactId = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "cf_sql_integer">;

            COMMIT;
        </cfquery>

        <cfif local.deleteContactQuery.contactpicture NEQ "demo-contact-image.jpg">
            <cffile action="delete" file="#expandPath('/assets/contactImages/' & local.deleteContactQuery.contactpicture)#">
        </cfif>

        <cfset local.response.success = true>

        <cfreturn local.response>
    </cffunction>
</cfcomponent>