<cfoutput>
    <div class="container-fluid contentSection">
        <!--- Bottom Content --->
        <div class="row px-1 pe-md-3">
            <!--- Left Section --->
            <div class="col-lg-3 col-md-4 col-12 sidebar bg-transparent mb-2">
                <div class="bg-white d-flex flex-column align-items-center px-3 py-5 gap-2">
                    <!--- <img class="userProfileIcon rounded-4" src="./assets/profilePictures/#session.profilePicture#" alt="User Profile Icon"> --->
                    <img class="userProfileIcon rounded-4" src="./assets/profilePictures/profilePic.jpg" alt="User Profile Icon">
                    <!--- <h4>#session.fullName#</h4> --->
                    <h4>Full Name</h4>
                    <button class="btn bg-primary text-white rounded-pill d-print-none" onclick="createContact()">CREATE CONTACT</button>
                    <button id="scheduleBdayEmailBtn" class="btn bg-secondary text-white rounded-pill d-print-none" onclick="toggleBdayEmailSchedule()">SCHEDULE BDAY MAILS</button>
                    <button class="btn bg-info text-white rounded-pill d-print-none" data-bs-toggle="modal" data-bs-target="##uploadContactModal">UPLOAD CONTACTS</button>
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
                                                <img class="contactImage p-2 rounded-4" src="./assets/contactImages/#item.contactpicture#" alt="Contact Image">
                                            </td>
                                            <td>#item.firstname# #item.lastname#</td>
                                            <td>#item.email#</td>
                                            <td>#item.phone#</td>
                                            <td class="d-print-none">
                                                <button class="actionBtn btn btn-outline-primary rounded-pill px-3" value="#item.contactid#" onclick="editContact(event)">
                                                    <span class="d-none d-lg-inline pe-none">EDIT</span>
                                                    <i class="fa-solid fa-pen-to-square d-lg-none pe-none"></i>
                                                </button>
                                            </td>
                                            <td class="d-print-none">
                                                <button class="actionBtn btn btn-outline-danger rounded-pill px-3" value="#item.contactid#" onclick="deleteContact(event)">
                                                    <span class="d-none d-lg-inline pe-none">DELETE</span>
                                                    <i class="fa-solid fa-trash d-lg-none pe-none"></i>
                                                </button>
                                            </td>
                                            <td class="d-print-none">
                                                <button class="actionBtn btn btn-outline-info rounded-pill px-3" value="#item.contactid#" onclick="viewContact(event)">
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
</cfoutput>