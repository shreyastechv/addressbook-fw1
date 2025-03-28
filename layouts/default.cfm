<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home Page - Address Book</title>
		<link href="/assets/css/bootstrap.min.css" rel="stylesheet">
		<link href="/assets/css/default.css" rel="stylesheet">
		<link href="/assets/css/login.css" rel="stylesheet">
		<script src="/assets/js/fontawesome.js"></script>
		<script src="/assets/js/jquery-3.7.1.min.js"></script>
    </head>

    <body>

        <cfoutput>
            <!--- Navbar --->
            <nav class="navbar navbar-expand-lg shadow-sm customNavbar px-2">
                <div class="container-fluid">
                    <a class="navbar-brand text-white" href="/">
                        <img src="/assets/images/logo.png" alt="Logo" width="30" height="30" class="d-inline-block align-text-top">
                        ADDRESS BOOK
                    </a>
                    <cfif structkeyExists(session, "userId")>
                        <a class="text-white text-decoration-none d-print-none" href="/" onclick="logOut()">
                            <i class="fa-solid fa-right-from-bracket"></i>
                            Logout
                        </a>
                    <cfelse>
                        <cfif NOT findNoCase("login", cgi.HTTP_URL)>
                            <a class="text-white text-decoration-none d-print-none" href="#buildURL('main.login')#">
                                <i class="fa-solid fa-right-to-bracket"></i>
                                Login
                            </a>
                        <cfelse>
                            <a class="text-white text-decoration-none d-print-none" href="#buildURL('main.signup')#">
                                <i class="fa-solid fa-user"></i>
                                SignUp
                            </a>
                        </cfif>
                    </cfif>
                </div>
            </nav>

            #body#
        </cfoutput>

		<script src="/assets/js/bootstrap.bundle.min.js"></script>
		<script src="/assets/js/default.js"></script>
		<script src="/assets/js/login.js"></script>
    </body>
</html>