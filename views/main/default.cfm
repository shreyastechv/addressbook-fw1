<cfoutput>
    <div class="container-fluid contentSection">
        <!--- Bottom Content --->
        <div class="row px-1 pe-md-3">
            <!--- Left Section --->
            <div class="col-lg-3 col-md-4 col-12 sidebar bg-transparent mb-2">
                <div class="bg-white d-flex flex-column align-items-center px-3 py-5 gap-2">
                    <img class="userProfileIcon rounded-4" src="/assets/profilePictures/#session.profilePicture#" alt="User Profile Icon">
                    <h4>#session.fullName#</h4>
                    <button class="btn bg-primary text-white rounded-pill d-print-none" onclick="createContact()">CREATE CONTACT</button>
                </div>
            </div>
            <!--- Right Section --->
            <div class="col-lg-9 col-md-8 col-12 rightSection bg-white d-flex align-items-center justify-content-around">
                <div id="mainContent" class="w-100">
                    <cfif arrayLen(rc.contacts)>
                        <div class="table-responsive w-100">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>NAME</th>
                                        <th>EMAIL ID</th>
                                        <th>PHONE NUMBER</th>
                                        <th class="d-print-none"></th>
                                        <th class="d-print-none"></th>
                                        <th class="d-print-none"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfloop array="#rc.contacts#" item="item">
                                        <tr>
                                            <td>
                                                <img class="contactImage p-2 rounded-4" src="/assets/contactImages/#item.contactPicture#" alt="Contact Image">
                                            </td>
                                            <td>#item.firstName# #item.lastName#</td>
                                            <td>#item.email#</td>
                                            <td>#item.phone#</td>
                                            <td class="d-print-none">
                                                <button class="actionBtn btn btn-outline-primary rounded-pill px-3" value="#item.contactId#" onclick="editContact(event)">
                                                    <span class="d-none d-lg-inline pe-none">EDIT</span>
                                                    <i class="fa-solid fa-pen-to-square d-lg-none pe-none"></i>
                                                </button>
                                            </td>
                                            <td class="d-print-none">
                                                <button class="actionBtn btn btn-outline-danger rounded-pill px-3" value="#item.contactId#" onclick="deleteContact(event)">
                                                    <span class="d-none d-lg-inline pe-none">DELETE</span>
                                                    <i class="fa-solid fa-trash d-lg-none pe-none"></i>
                                                </button>
                                            </td>
                                            <td class="d-print-none">
                                                <button class="actionBtn btn btn-outline-info rounded-pill px-3" value="#item.contactId#" onclick="viewContact(event)">
                                                    <span class="d-none d-lg-inline pe-none">VIEW</span>
                                                    <i class="fa-solid fa-eye d-lg-none pe-none"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </cfloop>
                                </tbody>
                            </table>
                        </div>
                    <cfelse>
                        <div class="d-flex fs-5 text-info justify-content-center">No contacts to display.</div>
                    </cfif>
                </div>
            </div>
        </div>
    </div>

    <!--- View Contact Modal --->
    <div class="modal fade" id="viewContactModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content rounded-0 d-flex flex-row justify-content-around">
                <div>
                    <div class="modal-header d-flex justify-content-around border-bottom-0">
                        <div class="contactModalHeader customDarkBlue px-5">
                            <h5 class="m-1">CONTACT DETAILS</h5>
                        </div>
                    </div>
                    <div class="modal-body">
                        <table class="table table-borderless align-middle">
                            <tbody>
                                <tr>
                                    <td class="text-primary fw-semibold">Name</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactName">Contact Name</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Gender</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactGender">Contact Gender</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Date Of Birth</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactDOB">Date of Birth</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Address</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactAddress">Contact Address</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Pincode</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactPincode">Contact Pincode</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Email id</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactEmail">Contact Email</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Phone</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactPhone">Contact Phone Number</td>
                                </tr>
                                <tr>
                                    <td class="text-primary fw-semibold">Roles</td>
                                    <td class="text-primary fw-semibold">:</td>
                                    <td id="viewContactRoles"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer d-flex justify-content-around border-top-0">
                        <button type="button" class="btn text-white bg-customDarkBlue rounded-pill py-1 px-4" data-bs-dismiss="modal">CLOSE</button>
                    </div>
                </div>
                <div class="contactImageEnlarged d-flex align-items-center justify-content-end p-4">
                    <img id="viewContactPicture" src="/assets/contactImages/demo-contact-image.jpg" alt="Contact Image Enlarged">
                </div>
            </div>
        </div>
    </div>

    <!--- Contact Management Modal --->
    <div class="modal fade" id="contactManagementModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content rounded-0 d-flex flex-row justify-content-around">
                <div>
                    <form id="contactManagement" name="contactManagement" method="post" enctype="multipart/form-data">
                        <input type="hidden" id="editContactId" name="editContactId">
                        <div class="modal-header d-flex justify-content-around border-bottom-0">
                            <div class="contactModalHeader customDarkBlue px-5">
                                <h5 id="contactManagementHeading" class="m-1">CREATE CONTACT</h5>
                            </div>
                        </div>
                        <div class="modal-body">
                            <h6 class="text-primary my-1">Personal Contact</h6>
                            <hr class="border border-dark border-1 opacity-100 m-0 mb-2">
                            <div class="d-flex justify-content-between mb-3">
                                <div class="col-md-2">
                                    <label class="contactManagementLabel" for="editContactTitle">Title *</label>
                                    <select class="contactManagementInput py-1 mt-1" id="editContactTitle" name="editContactTitle">
                                        <option></option>
                                        <option>Mr.</option>
                                        <option>Miss.</option>
                                        <option>Ms.</option>
                                        <option>Mrs.</option>
                                    </select>
                                    <div class="error text-danger" id="titleError"></div>
                                </div>
                                <div class="col-md-4">
                                    <label class="contactManagementLabel" for="editContactFirstName">First Name *</label>
                                    <input class="contactManagementInput py-1 mt-1 w-100" type="text" id="editContactFirstName" name="editContactFirstName" placeholder="Enter First Name" maxlength="30">
                                    <div class="error text-danger" id="firstNameError"></div>
                                </div>
                                <div class="col-md-4">
                                    <label class="contactManagementLabel" for="editContactLastName">Last Name *</label>
                                    <input class="contactManagementInput py-1 mt-1 w-100" type="text" id="editContactLastName" name="editContactLastName" placeholder="Enter Last Name" maxlength="30">
                                    <div class="error text-danger" id="lastNameError"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-6 d-flex flex-column">
                                    <label class="contactManagementLabel" for="editContactGender">Gender *</label>
                                    <select class="contactManagementInput py-1 mt-1" id="editContactGender" name="editContactGender">
                                        <option></option>
                                        <option>Male</option>
                                        <option>Female</option>
                                        <option>Others</option>
                                    </select>
                                    <div class="error text-danger" id="genderError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactDOB">Date Of Birth *</label>
                                    <input class="contactManagementInput py-1 mt-0" type="date" id="editContactDOB" name="editContactDOB" max="#DateFormat(Now(), 'yyyy-mm-dd')#">
                                    <div class="error text-danger" id="dobError"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-9 w-75">
                                    <label class="contactManagementLabel" for="editContactImage">Upload Photo</label>
                                    <input class="contactManagementInput py-1 mt-1" type="file" id="editContactImage" name="editContactImage" accept="image/*">
                                </div>
                            </div>
                            <h6 class="text-primary my-1">Contact Details</h6>
                            <hr class="border border-dark border-1 opacity-100 m-0 mb-2">
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactAddress">Address *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" id="editContactAddress" name="editContactAddress" placeholder="Enter Address" autocomplete="address" maxlength="40">
                                    <div class="error text-danger" id="addressError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactStreet">Street *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" id="editContactStreet" name="editContactStreet" placeholder="Enter Street Name" maxlength="15">
                                    <div class="error text-danger" id="streetError"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactDistrict">District *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" id="editContactDistrict" name="editContactDistrict" placeholder="Enter District" maxlength="15">
                                    <div class="error text-danger" id="districtError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactState">State *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" id="editContactState" name="editContactState" placeholder="Enter State" maxlength="15">
                                    <div class="error text-danger" id="stateError"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactCountry">Country *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" id="editContactCountry" name="editContactCountry" placeholder="Enter Country" autocomplete="country" maxlength="15">
                                    <div class="error text-danger" id="countryError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactPincode">Pincode *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" maxlength="6" id="editContactPincode" name="editContactPincode" placeholder="Enter Pincode">
                                    <div class="error text-danger" id="pincodeError"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactEmail">Email Id *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="email" id="editContactEmail" name="editContactEmail" placeholder="Enter Email Id" autocomplete="email" maxlength="50">
                                    <div class="error text-danger" id="emailError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="contactManagementLabel" for="editContactPhone">Phone number *</label>
                                    <input class="contactManagementInput py-1 mt-1" type="text" maxlength="10" id="editContactPhone" name="editContactPhone" placeholder="Enter Phone number" autocomplete="tel">
                                    <div class="error text-danger" id="phoneError"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between gap-3 mb-3">
                                <div class="col-md-6 d-flex flex-column">
                                    <label class="contactManagementLabel" for="editContactRole">Role *</label>
                                    <select class="contactManagementInput py-1 mt-1" id="editContactRole" name="editContactRole" multiple>
                                        <cfloop array="#rc.roles#" item="item">
                                            <option value="#item.roleId#">#item.roleName#</option>
                                        </cfloop>
                                    </select>
                                    <div class="error text-danger" id="roleError"></div>
                                </div>
                            </div>
                        </div>
                        <div id="contactManagementMsgSection" class="text-center p-2"></div>
                        <div class="modal-footer d-flex justify-content-around border-top-0">
                            <button type="button" class="btn text-white bg-customDarkBlue rounded-pill py-1 px-4" data-bs-dismiss="modal">CLOSE</button>
                            <button type="submit" class="btn btn-primary rounded-pill py-1 px-4" id="submitBtn" name="submitBtn">SUBMIT</button>
                        </div>
                    </form>
                </div>
                <div class="contactImageEnlarged d-flex align-items-center justify-content-end p-4">
                    <img id="editContactPicture" src="/assets/profilePictures/demo-profilepicture.jpg" alt="Contact Image Enlarged">
                </div>
            </div>
        </div>
    </div>

    <!--- Upload Contact Modal --->
    <div class="modal fade" id="uploadContactModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content rounded-0 d-flex flex-row justify-content-around p-4">
                <form class="w-100" id="contactUpload" name="contactUpload" method="post" enctype="multipart/form-data">
                    <div class="modal-header d-flex justify-content-end border-bottom-0 gap-2">
                        <button type="button" class="btn btn-primary btn-sm rounded-1 TemplateWithDataBtn" onclick="createContactsFile('excelTemplateWithData')">Template with data</button>
                        <button type="button" class="btn btn-success btn-sm rounded-1 plainTemplateBtn" onclick="createContactsFile('excelTemplate')">Plain Template</button>
                    </div>
                    <div class="modal-body d-flex flex-column">
                        <h4 class="customDarkBlue mb-0">Upload Excel File</h4>
                        <hr class="mt-0">
                        <label class="contactUploadLabel" for="uploadExcel">Upload Excel*</label>
                        <input id="uploadExcel" name="uploadExcel" type="file" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
                        <div class="error text-danger fs-6" id="uploadExcelError"></div>
                    </div>
                        <div id="contactUploadMsgSection" class="text-center p-2 error  fs-6"></div>
                        <div class="modal-footer d-flex justify-content-start border-top-0">
                        <button type="submit" class="btn text-white bg-customDarkBlue rounded-pill py-1 px-4">SUBMIT</button>
                        <button type="button" class="btn btn-outline-secondary customDarkBlue rounded-pill py-1 px-4" data-bs-dismiss="modal">CLOSE</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</cfoutput>