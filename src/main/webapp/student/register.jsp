<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration | CampusConnect</title>


<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">

<style>
    .auth-section {
        min-height: 100vh;
        padding: 45px 20px;
        display: grid;
        place-items: center;
        background: linear-gradient(135deg, #f7f8fc, #fff1e7);
    }

    .auth-card {
        width: 100%;
        max-width: 500px;
        padding: 35px;
        border: 1px solid var(--border);
        border-radius: 20px;
        background: var(--white);
        box-shadow: 0 20px 55px rgba(16, 29, 58, 0.10);
    }

    .auth-logo {
        margin-bottom: 22px;
        text-align: center;
    }

    .auth-logo a {
        color: var(--navy);
        font-size: 27px;
        font-weight: 800;
    }

    .auth-logo span {
        color: var(--orange-dark);
    }

    .auth-card h1 {
        margin-bottom: 8px;
        color: var(--navy);
        font-size: 28px;
        text-align: center;
    }

    .auth-subtitle {
        margin-bottom: 25px;
        color: var(--muted);
        font-size: 14px;
        line-height: 1.6;
        text-align: center;
    }

    .auth-form {
        display: grid;
        gap: 16px;
    }

    .form-group label {
        display: block;
        margin-bottom: 7px;
        color: var(--navy);
        font-size: 13px;
        font-weight: 700;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        min-height: 45px;
        padding: 11px 13px;
        border: 1px solid var(--border);
        border-radius: 9px;
        background: #fff;
        color: var(--navy);
        font: inherit;
        font-size: 14px;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: 2px solid rgba(255, 138, 61, 0.25);
        border-color: var(--orange);
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 14px;
    }

    .auth-submit {
        width: 100%;
        min-height: 47px;
        margin-top: 5px;
        border: none;
        border-radius: 9px;
        background: var(--orange);
        color: var(--navy);
        font-size: 14px;
        font-weight: 800;
        cursor: pointer;
    }

    .auth-submit:hover {
        filter: brightness(0.97);
    }

    .auth-switch {
        margin-top: 22px;
        color: var(--muted);
        font-size: 13px;
        text-align: center;
    }

    .auth-switch a {
        color: var(--orange-dark);
        font-weight: 800;
    }

    .back-home {
        display: block;
        margin-top: 17px;
        color: var(--muted);
        font-size: 13px;
        text-align: center;
    }

    @media (max-width: 480px) {
        .auth-card {
            padding: 26px 20px;
        }

        .form-row {
            grid-template-columns: 1fr;
            gap: 16px;
        }
    }
</style>


</head>

<body>
    <main class="auth-section">
        <section class="auth-card">


        <div class="auth-logo">
            <a href="${pageContext.request.contextPath}/">
                Campus<span>Connect</span>
            </a>
        </div>

        <h1>Create Your Account</h1>

        <p class="auth-subtitle">
            Join your campus community and discover exciting events.
        </p>

        <%
            String status = request.getParameter("status");


            if ("success".equals(status)) {           


        %> <div class="registration-alert success" role="status">
            Account created successfully! You can now log in. </div>
            <%
            } else if ("exists".equals(status)) {
            %> <div class="registration-alert error" role="alert">
            An account with this email or student ID already exists.
            Please log in or use different details. </div>
            <%
            }
            %>


        <form class="auth-form"
        action="${pageContext.request.contextPath}/register-account"
        method="post"
        onsubmit="return validateRegistration()">

            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text"
                        id="fullName"
                        name="fullName"
                        placeholder="Enter your full name"
                        autocomplete="name"
                        required>
            </div>

            <div class="form-group">
                <label for="email">College Email</label>
                <input type="email"
                       id="email"
                       name="email"
                       placeholder="you@example.com"
                       autocomplete="email"
                       required>
            </div>

            <div class="form-group">
                <label for="studentId">Student ID / Registration Number</label>
                <input type="text"
                       id="studentId"
                       name="studentId"
                       placeholder="Enter your student ID"
                       required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="course">Course</label>
                    <select id="course" name="course" required>
                        <option value="">Select course</option>
                        <option value="BCA">BCA</option>
                        <option value="MCA">MCA</option>
                        <option value="BTech">B.Tech</option>
                        <option value="MBA">MBA</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="semester">Semester</label>
                    <select id="semester" name="semester" required>
                        <option value="">Select semester</option>
                        <option value="1">Semester 1</option>
                        <option value="2">Semester 2</option>
                        <option value="3">Semester 3</option>
                        <option value="4">Semester 4</option>
                        <option value="5">Semester 5</option>
                        <option value="6">Semester 6</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Create Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="At least 8 characters"
                       minlength="8"
                       autocomplete="new-password"
                       required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       placeholder="Enter password again"
                       minlength="8"
                       autocomplete="new-password"
                       required>
            </div>

            <button type="submit" class="auth-submit">
                Create Account
            </button>
        </form>

        <p class="auth-switch">
            Already have an account?
            <a href="${pageContext.request.contextPath}/student/login.jsp">
                Sign in
            </a>
        </p>

        <a class="back-home"
           href="${pageContext.request.contextPath}/">
            &larr; Back to Home
        </a>

    </section>
</main>

<script>
    function validateRegistration() {
        const fullName = document.getElementById("fullName").value.trim();
        const studentId = document.getElementById("studentId").value.trim();
        const password = document.getElementById("password").value;
        const confirmPassword =
            document.getElementById("confirmPassword").value;

        if (fullName.length < 2) {
            alert("Please enter your full name.");
            return false;
        }

        if (studentId.length < 2) {
            alert("Please enter a valid student ID.");
            return false;
        }

        if (password.length < 8) {
            alert("Password must contain at least 8 characters.");
            return false;
        }

        if (password !== confirmPassword) {
            alert("Passwords do not match. Please try again.");
            return false;
        }

        // Validation passed. Allow the form to submit to the backend.
        return true;
    }
</script>



</body>
</html>
