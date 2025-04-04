component accessors=true {
    property addressbookService;

    function init(fw) {
        variables.fw=arguments.fw;
        return this;
    }

    function signup(struct rc) {
        param name="rc.signupMsg" default="";
        param name="rc.fullname" default="";
        param name="rc.email" default="";
        param name="rc.username" default="";
        param name="rc.password" default="";

        if(structKeyExists(rc, "submitBtn")) {
            // Fullname Validation
            if (len(trim(rc.fullname)) EQ 0) {
                rc.signupMsg &= "Enter first name. ";
            } else if (isValid("regex", trim(rc.fullname), "\d")) {
                rc.signupMsg &= "First name should not contain any digits. ";
            }

            // Email Validation
            if (len(trim(rc.email)) EQ 0) {
                rc.signupMsg &= "Enter an email address. ";
            } else if (NOT isValid("email", trim(rc.email))) {
                rc.signupMsg &= "Invalid email. ";
            }

            // Username Validation
            if (len(trim(rc.username)) EQ 0) {
                rc.signupMsg &= "Enter a username";
            } else if (NOT isValid("email", trim(rc.username))) {
                rc.signupMsg &= "Username should be a valid email address";
            }

            // Password Validation
            if (len(trim(rc.password)) EQ 0) {
                rc.signupMsg &= "Enter a password. ";
            } else if (NOT (len(trim(rc.password)) GTE 8
                AND refind('[A-Z]', trim(rc.password))
                AND refind('[a-z]', trim(rc.password))
                AND refind('[0-9]', trim(rc.password))
                AND refind('[!@##$&*]', trim(rc.password)))) {
                rc.signupMsg &= "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character. ";
            }

            // Return message if validation fails
            if (len(trim(rc.signupMsg))) {
                rc.signupMsg = rc.signupMsg;
                return;
            }

            local.signupResult = variables.addressbookService.signup(
                fullname = rc.fullname,
                email = rc.email,
                username = rc.username,
                password = rc.password
            );

            if (local.signupResult.success) {
                rc.signupMsg = "Signup successfull. <a href='#variables.fw.buildURL('main.login')#'>Login</a> to continue.";
            }
            else {
                rc.signupMsg = local.signupResult.message;
            }
        }
    }

    function default(struct rc) {
        param name="rc.contacts.data" default=[];
        param name="rc.roles.data" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            userId = session.userId
        );

        local.roles = variables.addressbookService.fetchRoles();

        rc.contacts = local.contacts.data;
        rc.roles = local.roles.data;
    }

    function login(struct rc) {
        param name="rc.loginMsg" default="";
        param name="rc.username" default="";
        param name="rc.password" default="";

        if(structKeyExists(rc, "loginBtn")) {
            local.loginResult = variables.addressbookService.login(
                username = rc.username,
                password = rc.password
            );

            rc.loginMsg = local.loginResult.message;
            if (local.loginResult.success) {
                variables.fw.redirect('main.default');
            }
        }
    }

    public string function fetchContacts(struct rc) {
        param name="rc.contactId" default=0;
        param name="local.contacts.data" default=[];

        local.contacts = variables.addressbookService.fetchContacts(
            contactId = val(rc.contactId)
        );

        variables.fw.renderData( "json", local.contacts );
    }

    public string function logout() {
        local.response = { "success" = false };

        structClear(session);
        local.response.success = true;

        variables.fw.renderData( "json", local.response );
    }

    public string function modifyContacts(struct rc) {
        param name="rc.contactId" type="integer" default=0;
        param name="rc.contactTitle" type="string" default="";
        param name="rc.contactFirstName" type="string" default="";
        param name="rc.contactLastName" type="string" default="";
        param name="rc.contactGender" type="string" default="";
        param name="rc.contactDOB" type="string" default="";
        param name="rc.contactImage" type="string" default="";
        param name="rc.contactAddress" type="string" default="";
        param name="rc.contactStreet" type="string" default="";
        param name="rc.contactDistrict" type="string" default="";
        param name="rc.contactState" type="string" default="";
        param name="rc.contactCountry" type="string" default="";
        param name="rc.contactPincode" type="string" default="";
        param name="rc.contactEmail" type="string" default="";
        param name="rc.contactPhone" type="string" default="";
        param name="rc.roleIds" type="string" default="";

        local.response = {
            "success" = false,
            "message" = ""
        }

        /* Check if user is logged in before allowing contact modification */
        if (!structKeyExists(session, "isLoggedIn")) {
            local.response.message = "User not logged in!";
            variables.fw.renderData( "json", local.response );
            return;
        }

        /* Contact ID Validation */
        if (NOT isNumeric(rc.contactId)) {
            local.response.message &= "Contact ID should be a valid integer. ";
        }

        /* Gender Validation */
        if (NOT arrayContainsNoCase(["Male", "Female", "Others"], rc.contactGender)) {
            local.response.message &= "Gender should be either Male, Female, or Others. ";
        }

        /* Date of Birth Validation */
        if (len(trim(rc.contactDOB)) EQ 0) {
            local.response.message &= "Enter a date of birth. ";
        } else if (NOT isDate(rc.contactDOB)) {
            local.response.message &= "Invalid date of birth. ";
        } else if (createDate(dateFormat(rc.contactDOB, "yyyy"), dateFormat(rc.contactDOB, "mm"), dateFormat(rc.contactDOB, "dd")) GTE now()) {
            local.response.message &= "Date of birth should be before today. ";
        }

        /* Pincode Validation */
        if (len(trim(rc.contactPincode)) EQ 0) {
            local.response.message &= "Enter a pincode. ";
        } else if (NOT isNumeric(rc.contactPincode) OR len(trim(rc.contactPincode)) NEQ 6) {
            local.response.message &= "Pincode should be exactly 6 digits. ";
        }

        /* Phone Number Validation */
        if (len(trim(rc.contactPhone)) EQ 0) {
            local.response.message &= "Enter a phone number. ";
        } else if (NOT isNumeric(rc.contactPhone) OR len(trim(rc.contactPhone)) NEQ 10) {
            local.response.message &= "Phone number should be exactly 10 digits. ";
        }

        /* Role IDs Validation */
        if (len(trim(rc.roleIds)) EQ 0) {
            local.response.message &= "Enter at least one role ID. ";
        } else {
            /* Validate that all roleIds are integers */
            var roleArray = ListToArray(rc.roleIds);
            for (var i = 1; i <= ArrayLen(roleArray); i++) {
                if (NOT isNumeric(roleArray[i])) {
                    local.response.message &= "Role IDs should be integers. ";
                    break;
                }
            }
        }

        /* Fullname Validation (First Name) */
        if (len(trim(rc.contactFirstName)) EQ 0) {
            local.response.message &= "Enter first name. ";
        } else if (isValid("regex", trim(rc.contactFirstName), "\d")) {
            local.response.message &= "First name should not contain any digits. ";
        }

        /* Fullname Validation (Last Name) */
        if (len(trim(rc.contactLastName)) EQ 0) {
            local.response.message &= "Enter last name. ";
        } else if (isValid("regex", trim(rc.contactLastName), "\d")) {
            local.response.message &= "Last name should not contain any digits. ";
        }

        /* Email Validation */
        if (len(trim(rc.contactEmail)) EQ 0) {
            local.response.message &= "Enter an email address. ";
        } else if (NOT isValid("email", trim(rc.contactEmail))) {
            local.response.message &= "Invalid email address. ";
        }

        /* Address Validation (Optional, if required) */
        if (len(trim(rc.contactAddress)) EQ 0) {
            local.response.message &= "Enter an address. ";
        }

        /* Street Validation (Optional, if required) */
        if (len(trim(rc.contactStreet)) EQ 0) {
            local.response.message &= "Enter a street. ";
        }

        /* District Validation (Optional, if required) */
        if (len(trim(rc.contactDistrict)) EQ 0) {
            local.response.message &= "Enter a district. ";
        }

        /* State Validation (Optional, if required) */
        if (len(trim(rc.contactState)) EQ 0) {
            local.response.message &= "Enter a state. ";
        }

        /* Country Validation (Optional, if required) */
        if (len(trim(rc.contactCountry)) EQ 0) {
            local.response.message &= "Enter a country. ";
        }

        /* Contact Image Validation (Mandatory only if the contact is new) */
        if (!val(rc.contactId) && len(trim(rc.contactImage)) EQ 0) {
            local.response.message &= "Enter an image URL or file. ";
        }

        /* Return if there is error message */
        if (len(trim(local.response.message))) {
            variables.fw.renderData( "json", local.response );
            return;
        }

        local.response = variables.addressbookService.modifyContacts(
            contactId = rc.contactId,
            contactTitle = rc.contactTitle,
            contactFirstName = rc.contactFirstName,
            contactLastName = rc.contactLastName,
            contactGender = rc.contactGender,
            contactDOB = rc.contactDOB,
            contactImage = rc.contactImage,
            contactAddress = rc.contactAddress,
            contactStreet = rc.contactStreet,
            contactDistrict = rc.contactDistrict,
            contactState = rc.contactState,
            contactCountry = rc.contactCountry,
            contactPincode = rc.contactPincode,
            contactEmail = rc.contactEmail,
            contactPhone = rc.contactPhone,
            roleIds = rc.roleIds
        );

        local.response.success = true;
        variables.fw.renderData( "json", local.response );
    }

    public string function deleteContact(struct rc) {
        local.response = {
            "success" = false,
            "message" = ""
        }

        if (!structKeyExists(session, "isLoggedIn")) {
            local.response.success = false;
            local.response.message = "User not logged in!";
            variables.fw.renderData( "json", local.response );
            return;
        }

        local.response = variables.addressbookService.deleteContact(
            contactId = rc.contactId,
            userId = session.userId
        );

        variables.fw.renderData( "json", local.response );
    }
}
