/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Xulythongtin;

import Database.DBConnection;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author sphie
 */
@WebServlet("/khachhang")
public class KhachHangServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("Action nhận được: " + action); // Debug

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = null;

            if ("them".equals(action)) {
                String hoVaTen = request.getParameter("hoVaTen");
                String email = request.getParameter("email");
                String soDienThoai = request.getParameter("soDienThoai"); // dùng String
                String gioiTinh = request.getParameter("gioiTinh");
                String ngaySinh = request.getParameter("ngaySinh");
                String diaChi = request.getParameter("diaChi");

                ps = conn.prepareStatement("INSERT INTO khachhang (hoVaTen, email, soDienThoai, gioiTinh, ngaySinh, diaChi) VALUES (?, ?, ?, ?, ?, ?)");
                ps.setString(1, hoVaTen);
                ps.setString(2, email);
                ps.setString(3, soDienThoai); // dùng String thay vì int
                ps.setString(4, gioiTinh);
                ps.setString(5, ngaySinh);
                ps.setString(6, diaChi);

                int rows = ps.executeUpdate(); // Thực thi
                System.out.println("Đã thêm " + rows + " dòng.");

            } else if ("sua".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String hoVaTen = request.getParameter("hoVaTen");
                String email = request.getParameter("email");
                String soDienThoai = request.getParameter("soDienThoai");
                String gioiTinh = request.getParameter("gioiTinh");
                String ngaySinh = request.getParameter("ngaySinh");
                String diaChi = request.getParameter("diaChi");

                ps = conn.prepareStatement("UPDATE khachhang SET hoVaTen=?, email=?, soDienThoai=?, gioiTinh=?, ngaySinh=?, diaChi=? WHERE Makhachhang=?");
                ps.setString(1, hoVaTen);
                ps.setString(2, email);
                ps.setString(3, soDienThoai);
                ps.setString(4, gioiTinh);
                ps.setString(5, ngaySinh);
                ps.setString(6, diaChi);
                ps.setInt(7, id);

                ps.executeUpdate();

            } else if ("xoa".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                ps = conn.prepareStatement("DELETE FROM khachhang WHERE Makhachhang=?");
                ps.setInt(1, id);

                ps.executeUpdate();
            }

            response.sendRedirect("admin.jsp?view=khachhang");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi xử lý khách hàng: " + e.getMessage());
        }
    }
}
