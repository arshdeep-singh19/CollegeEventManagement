package com.collegeevent.servlet;

import com.collegeevent.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.trim().isEmpty() || password.isEmpty()) {
            response.sendRedirect(
                request.getContextPath() + "/admin/login.jsp?error=empty");
            return;
        }

        String sql = "SELECT admin_id, username, password_hash "
                   + "FROM admins WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");

                    if (storedHash != null
                            && BCrypt.checkpw(password, storedHash)) {

                        HttpSession session = request.getSession(true);
                        session.setAttribute("adminId", rs.getInt("admin_id"));
                        session.setAttribute(
                            "adminUsername", rs.getString("username"));

                        response.sendRedirect(
                            request.getContextPath() + "/admin/dashboard.jsp");
                        return;
                    }
                }
            }

            response.sendRedirect(
                request.getContextPath() + "/admin/login.jsp?error=invalid");

        } catch (Exception e) {
            throw new ServletException("Admin login failed.", e);
        }
    }
}

