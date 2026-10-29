package com.collegeevent.servlet;

import com.collegeevent.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/register-account")
public class RegisterAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String studentId = request.getParameter("studentId");
        String course = request.getParameter("course");
        String semesterValue = request.getParameter("semester");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate required fields.
        if (fullName == null || email == null || studentId == null
                || course == null || semesterValue == null
                || password == null || confirmPassword == null) {
            response.sendError(400, "Please complete all required fields.");
            return;
        }

        fullName = fullName.trim();
        email = email.trim().toLowerCase();
        studentId = studentId.trim();
        course = course.trim();

        if (fullName.length() < 2 || fullName.length() > 100
                || studentId.length() < 2 || studentId.length() > 30
                || email.length() > 150
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
                || password.length() < 8
                || !password.equals(confirmPassword)) {
            response.sendError(400,
                    "Please check your details and password confirmation.");
            return;
        }

        // Only accept the courses offered by the registration form.
        if (!course.equals("BCA") && !course.equals("MCA")
                && !course.equals("BTech") && !course.equals("MBA")
                && !course.equals("Other")) {
            response.sendError(400, "Please select a valid course.");
            return;
        }

        int semester;

        try {
            semester = Integer.parseInt(semesterValue);
        } catch (NumberFormatException e) {
            response.sendError(400, "Please select a valid semester.");
            return;
        }

        if (semester < 1 || semester > 6) {
            response.sendError(400, "Please select a valid semester.");
            return;
        }

        // Hash the password before storing it.
        String passwordHash = BCrypt.hashpw(
                password, BCrypt.gensalt(12));

        try (Connection connection = DBConnection.getConnection()) {

            // Check for an existing email or student ID.
            String checkSql =
                    "SELECT email, college_student_id FROM students "
                    + "WHERE email = ? OR college_student_id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(checkSql)) {

                ps.setString(1, email);
                ps.setString(2, studentId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect(
                                request.getContextPath()
                                + "/student/register.jsp?status=exists");
                        return;
                    }
                }
            }

            // Create the student account.
            String insertSql =
                    "INSERT INTO students "
                    + "(full_name, email, college_student_id, "
                    + "password_hash, course, semester) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps =
                         connection.prepareStatement(insertSql)) {

                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, studentId);
                ps.setString(4, passwordHash);
                ps.setString(5, course);
                ps.setInt(6, semester);

                ps.executeUpdate();
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/register.jsp?status=success");

        } catch (SQLException e) {

            // Handle duplicate-key conflicts, including simultaneous requests.
            if (e.getErrorCode() == 1062) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/student/register.jsp?status=exists");
            } else {
                throw new ServletException(
                        "Unable to create the student account.", e);
            }
        }
    }
}

