$("#signupForm").submit(function(event) {
    const fullname = $("#fullname").val();
    const fullnameError = $("#fullnameError");
    const email = $("#email").val();
    const emailError = $("#emailError");
    const username = $("#username").val();
    const usernameError = $("#usernameError");
    const password = $("#password").val();
    const passwordError = $("#passwordError");
    const confirmPassword = $("#confirmPassword").val();
    const confirmPasswordError = $("#confirmPasswordError");
    const profilePicture = $("#profilePicture");
    const profilePictureError = $("#profilePictureError");
    const submitMsgSection = $("#submitMsgSection");
    let valid = true;

    // Remove error messages if present
    $(".signup-error").text("");

    // Full name validation
    if (fullname == "") {
        fullnameError.text("Full name is requied!");
        valid = false;
    }
    else if(/\d/.test(fullname)) {
        fullnameError.text("Name cannot contain a number");
        valid = false;
    }

    //Email validation
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (email == "") {
        emailError.text("Email is requied!");
        valid = false;
    }
    else if(!emailPattern.test(email)) {
        emailError.text("Email not valid!");
        valid = false;
    }

    // Username validation
    const usernamePattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (username == "") {
        usernameError.text("Username is requied!");
        valid = false;
    }
    else if(!usernamePattern.test(username)) {
        usernameError.text("Only emails can be used as username.");
        valid = false;
    }

    // Password validation
    if (password == "") {
        passwordError.text("Password is requied!");
        valid = false;
    }
    else if(password.length < 8) {
        passwordError.text("There should be atleast 8 characters");
        valid = false;
    }
    else if(password == password.toUpperCase()) {
        passwordError.text("There shoule be atleast atleast one lowercase letter");
        valid = false;
    }
    else if(password == password.toLowerCase()) {
        passwordError.text("There shoule be atleast one uppercase letter");
        valid = false;
    }
    else if(!/\d/.test(password)) {
        passwordError.text("There shoule be atleast one digit");
        valid = false;
    }
    else if(!/[@$!%*?&^]/.test(password)) {
        passwordError.text("There shoule be atleast one special character (@$!%*?&^)");
        valid = false;
    }

    // Confirm password validation
    if (password.trim() != "") {
        if (confirmPassword == "") {
            confirmPasswordError.text("Confirm password");
            valid = false;
        }
        else if (confirmPassword !== password) {
            confirmPasswordError.text("Passwords don't match");
            valid = false;
        }
    }

    // Image type validation
    if (profilePicture.val() == "") {
        profilePictureError.text("Profile picture is requied!");
        valid = false;
    } else if(profilePicture[0].files[0].type.split('/')[0] !== 'image'){
        profilePictureError.text("Only images are allowed");
        valid = false;
    }

    if (!valid) {
        event.preventDefault();
    }
});