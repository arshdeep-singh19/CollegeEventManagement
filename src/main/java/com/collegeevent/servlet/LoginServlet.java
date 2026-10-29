package com.collegeevent.servlet;

import com.collegeevent.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {


@Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email == null || email.isBlank()
            || password == null || password.isBlank()) {
        response.sendRedirect(
            request.getContextPath() + "/student/login.jsp?status=invalid"
        );
        return;
    }

    String sql = """
        SELECT student_id, full_name, email, password_hash
        FROM students
        WHERE email = ?
        """;

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql)) {

        statement.setString(1, email.trim());

        try (ResultSet result = statement.executeQuery()) {

            if (!result.next()) {
                response.sendRedirect(
                    request.getContextPath() + "/student/login.jsp?status=invalid"
                );
                return;
            }

            String storedHash = result.getString("password_hash");

            if (storedHash == null
                    || !BCrypt.checkpw(password, storedHash)) {
                response.sendRedirect(
                    request.getContextPath() + "/student/login.jsp?status=invalid"
                );
                return;
            }

            HttpSession session = request.getSession(true);
            request.changeSessionId();

            session.setAttribute("studentId", result.getInt("student_id"));
            session.setAttribute("studentName", result.getString("full_name"));
            session.setAttribute("studentEmail", result.getString("email"));

            response.sendRedirect(
                request.getContextPath() + "/student/dashboard.jsp"
            );
        }

    } catch (Exception e) {
        throw new ServletException("Unable to process login.", e);
    }
}


}
