<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login | CampusConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-section {
            min-height: calc(100vh - 100px);
            padding: 55px 20px;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, #f7f8fc, #fff1e7);
        }


    .auth-card {
        width: 100%;
        max-width: 440px;
        padding: 38px;
        border: 1px solid var(--border);
        border-radius: 20px;
        background: var(--white);
        box-shadow: 0 20px 55px rgba(16, 29, 58, 0.10);
    }

    .auth-logo {
        margin-bottom: 28px;
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
        margin-bottom: 9px;
        color: var(--navy);
        font-size: 29px;
        text-align: center;
    }

    .auth-subtitle {
        margin-bottom: 28px;
        color: var(--muted);
        font-size: 14px;
        line-height: 1.6;
        text-align: center;
    }

    .auth-form {
        display: grid;
        gap: 17px;
    }

    .auth-form label {
        display: block;
        margin-bottom: 7px;
        color: var(--navy);
        font-size: 13px;
        font-weight: 700;
    }

    .auth-form input {
        width: 100%;
        min-height: 46px;
        padding: 12px 14px;
        border: 1px solid var(--border);
        border-radius: 9px;
        background: #fff;
        color: var(--navy);
        font: inherit;
        font-size: 14px;
    }

    .auth-form input:focus {
        outline: 2px solid rgba(255, 138, 61, 0.25);
        border-color: var(--orange);
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
        margin-top: 23px;
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
        margin-top: 20px;
        color: var(--muted);
        font-size: 13px;
        text-align: center;
    }

    @media (max-width: 480px) {
        .auth-card {
            padding: 28px 22px;
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


        <h1>Welcome Back!</h1>
        <p class="auth-subtitle">
            Sign in to discover events and manage your campus registrations.
        </p>

        <form class="auth-form"
            action="${pageContext.request.contextPath}/login"
            method="post">
            
            <div>
                <label for="email">College Email</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="you@example.com"
                    autocomplete="email"
                    required
                >
            </div>

            <div>
                <label for="password">Password</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Enter your password"
                    autocomplete="current-password"
                    required
                >
            </div>

            <button class="auth-submit" type="submit">Sign In</button>
        </form>

        <p class="auth-switch">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/student/register.jsp">
                Register here
            </a>
        </p>

        <a class="back-home" href="${pageContext.request.contextPath}/">
            &larr; Back to Home
        </a>
    </section>
</main>


</body>
</html>
