<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    String adminUsername = (String) session.getAttribute("adminUsername");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CampusConnect</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f5f9;
            color: #202b3c;
        }

        header {
            background: #17243b;
            color: white;
            padding: 22px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        header h1 { margin: 0; font-size: 25px; }

        .logout {
            color: white;
            background: #d64545;
            padding: 10px 16px;
            border-radius: 7px;
            text-decoration: none;
        }

        main {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .welcome { margin-bottom: 28px; }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 22px;
        }

        .card {
            background: white;
            padding: 27px;
            border-radius: 13px;
            box-shadow: 0 4px 16px rgba(20, 35, 60, 0.07);
        }

        .card h2 { margin-top: 0; font-size: 20px; }
        .card p { color: #667085; line-height: 1.6; }

        .button {
            display: inline-block;
            margin-top: 10px;
            background: #315bd6;
            color: white;
            padding: 11px 16px;
            border-radius: 7px;
            text-decoration: none;
        }

        footer {
            text-align: center;
            padding: 25px;
            color: #667085;
        }
    </style>
</head>
<body>
    <header>
        <h1>CampusConnect Admin</h1>
        <a class="logout"
           href="<%= request.getContextPath() %>/admin-logout">
            Logout
        </a>
    </header>

    <main>
        <section class="welcome">
            <h2>Welcome, <%= adminUsername == null ? "Admin" : adminUsername %>!</h2>
            <p>Manage college events and review student registrations.</p>
        </section>

        <section class="cards">
            <article class="card">
                <h2>Manage Events</h2>
                <p>Create new college events for students to discover and register for.</p>
                <a class="button"
                   href="<%= request.getContextPath() %>/admin/add-event.jsp">
                    Add Event
                </a>
            </article>

            <article class="card">
                <h2>View Registrations</h2>
                <p>Review the events students have registered for.</p>
                <a class="button"
                   href="<%= request.getContextPath() %>/admin/registrations.jsp">
                    View Registrations
                </a>
            </article>
        </section>
    </main>

    <footer>CampusConnect · Administration Panel</footer>
</body>
</html>

