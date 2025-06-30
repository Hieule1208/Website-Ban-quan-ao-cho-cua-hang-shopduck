/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Xulythongtin;

/**
 *
 * @author sphie
 */

import java.io.IOException;
import java.sql.*;


import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DanhMucServlet")
public class DanhMucServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("them".equals(action)) {
                String ten = request.getParameter("tendanhmuc");
                PreparedStatement ps = conn.prepareStatement("INSERT INTO danhmuc(tendanhmuc) VALUES(?)");
                ps.setString(1, ten);
                ps.executeUpdate();
            } else if ("sua".equals(action)) {
                int id = Integer.parseInt(request.getParameter("iddanhmuc"));
                String ten = request.getParameter("tendanhmuc");
                PreparedStatement ps = conn.prepareStatement("UPDATE danhmuc SET tendanhmuc=? WHERE iddanhmuc=?");
                ps.setString(1, ten);
                ps.setInt(2, id);
                ps.executeUpdate();
            } else if ("xoa".equals(action)) {
                int id = Integer.parseInt(request.getParameter("iddanhmuc"));
                PreparedStatement ps = conn.prepareStatement("DELETE FROM danhmuc WHERE iddanhmuc=?");
                ps.setInt(1, id);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin.jsp");
    }
}
