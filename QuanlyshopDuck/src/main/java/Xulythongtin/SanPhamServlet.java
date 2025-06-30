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
import java.sql.SQLException;

/**
 * Servlet for managing product operations (add, edit, delete).
 */
@WebServlet("/SanPhamServlet")
public class SanPhamServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set character encoding to UTF-8 for proper handling of Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        System.out.println("Action nhận được (Sản phẩm): " + action); // Debugging output

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection(); // Get database connection

            if ("them".equals(action)) {
                // Retrieve parameters for adding a new product
                String tenSP = request.getParameter("TenSP");
                int gia = Integer.parseInt(request.getParameter("Gia"));
                String hinhAnh = request.getParameter("hinhanh");
                String moTa = request.getParameter("Mota");
                int soLuong = Integer.parseInt(request.getParameter("Soluong"));
                int idDanhMuc = Integer.parseInt(request.getParameter("iddanhmuc"));

                // Prepare SQL statement for insertion
                ps = conn.prepareStatement("INSERT INTO sanpham (TenSP, Gia, hinhanh, Mota, Soluong, iddanhmuc) VALUES (?, ?, ?, ?, ?, ?)");
                ps.setString(1, tenSP);
                ps.setInt(2, gia);
                ps.setString(3, hinhAnh);
                ps.setString(4, moTa);
                ps.setInt(5, soLuong);
                ps.setInt(6, idDanhMuc);

                int rows = ps.executeUpdate(); // Execute the insert statement
                System.out.println("Đã thêm " + rows + " dòng sản phẩm.");

            } else if ("sua".equals(action)) {
                // Retrieve parameters for updating an existing product
                int maSP = Integer.parseInt(request.getParameter("MaSP"));
                String tenSP = request.getParameter("TenSP");
                int gia = Integer.parseInt(request.getParameter("Gia"));
                String hinhAnh = request.getParameter("hinhanh");
                String moTa = request.getParameter("Mota");
                int soLuong = Integer.parseInt(request.getParameter("Soluong"));
                int idDanhMuc = Integer.parseInt(request.getParameter("iddanhmuc"));

                // Prepare SQL statement for update
                ps = conn.prepareStatement("UPDATE sanpham SET TenSP=?, Gia=?, hinhanh=?, Mota=?, Soluong=?, iddanhmuc=? WHERE MaSP=?");
                ps.setString(1, tenSP);
                ps.setInt(2, gia);
                ps.setString(3, hinhAnh);
                ps.setString(4, moTa);
                ps.setInt(5, soLuong);
                ps.setInt(6, idDanhMuc);
                ps.setInt(7, maSP);

                int rows = ps.executeUpdate(); // Execute the update statement
                System.out.println("Đã sửa " + rows + " dòng sản phẩm.");

            } else if ("xoa".equals(action)) {
                // Retrieve parameter for deleting a product
                int maSP = Integer.parseInt(request.getParameter("id")); // Using 'id' as parameter name for consistency with customer servlet
                // Prepare SQL statement for deletion
                ps = conn.prepareStatement("DELETE FROM sanpham WHERE MaSP=?");
                ps.setInt(1, maSP);

                int rows = ps.executeUpdate(); // Execute the delete statement
                System.out.println("Đã xóa " + rows + " dòng sản phẩm.");
            }

            // Redirect back to the admin page, showing the product section
            response.sendRedirect("admin.jsp?view=sanpham");

        } catch (NumberFormatException e) {
            // Handle cases where integer parameters (Gia, Soluong, MaSP, iddanhmuc) are not valid numbers
            e.printStackTrace();
            response.getWriter().println("Lỗi định dạng số khi xử lý sản phẩm: " + e.getMessage());
        } catch (SQLException e) {
            // Log SQL exceptions
            e.printStackTrace();
            response.getWriter().println("Lỗi cơ sở dữ liệu khi xử lý sản phẩm: " + e.getMessage());
        } catch (Exception e) {
            // Catch any other unexpected exceptions
            e.printStackTrace();
            response.getWriter().println("Lỗi không xác định khi xử lý sản phẩm: " + e.getMessage());
        } finally {
            // Close PreparedStatement and Connection in a finally block to ensure resources are released
            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing Connection: " + e.getMessage());
            }
        }
    }
}