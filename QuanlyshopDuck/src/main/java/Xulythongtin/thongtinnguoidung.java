/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Xulythongtin;

import data.khachhang;
import DAO.KhachHangDAO;
import Database.DBConnection;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/thongtinnguoidung")
public class thongtinnguoidung extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        Integer idTaiKhoan = (Integer) session.getAttribute("idTaiKhoan");

        if (tenDangNhap == null || idTaiKhoan == null) {
            request.setAttribute("error", "Vui lòng đăng nhập để lưu thông tin!");
            request.getRequestDispatcher("dangnhap.jsp").forward(request, response);
            return;
        }

        // Get form data
        String hoVaTen = request.getParameter("name");
        String email = request.getParameter("email");
        String soDienThoai = request.getParameter("phone");
        String gioiTinh = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String diaChi = request.getParameter("address");

        try (Connection conn = DBConnection.getConnection()) {
            // Check if customer already exists for this idTaiKhoan
            String checkSql = "SELECT Makhachhang FROM khachhang WHERE idtaikhoan = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, idTaiKhoan);
            ResultSet rs = checkStmt.executeQuery();
            boolean customerExists = rs.next();
            int maKhachHang = customerExists ? rs.getInt("Makhachhang") : 0;

            PreparedStatement stmt;
            if (customerExists) {
                // Update existing customer
                String updateSql = "UPDATE khachhang SET hoVaTen = ?, email = ?, soDienThoai = ?, gioiTinh = ?, ngaySinh = ?, diaChi = ? WHERE idtaikhoan = ?";
                stmt = conn.prepareStatement(updateSql);
                stmt.setString(1, hoVaTen);
                stmt.setString(2, email);
                stmt.setString(3, soDienThoai);
                stmt.setString(4, gioiTinh);
                stmt.setDate(5, dob.isEmpty() ? null : Date.valueOf(dob));
                stmt.setString(6, diaChi);
                stmt.setInt(7, idTaiKhoan);
            } else {
                // Insert new customer
                String insertSql = "INSERT INTO khachhang (hoVaTen, email, soDienThoai, gioiTinh, ngaySinh, diaChi, idtaikhoan) VALUES (?, ?, ?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                stmt.setString(1, hoVaTen);
                stmt.setString(2, email);
                stmt.setString(3, soDienThoai);
                stmt.setString(4, gioiTinh);
                stmt.setDate(5, dob.isEmpty() ? null : Date.valueOf(dob));
                stmt.setString(6, diaChi);
                stmt.setInt(7, idTaiKhoan);
            }

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                // Get Makhachhang for new customer
                if (!customerExists) {
                    ResultSet generatedKeys = stmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        maKhachHang = generatedKeys.getInt(1);
                    }
                }

                // Update session with new customer info
                khachhang kh = new khachhang();
                kh.setMaKhachHang(maKhachHang);
                kh.setHoVaTen(hoVaTen);
                kh.setEmail(email);
                kh.setSoDienThoai(soDienThoai);
                kh.setGioiTinh(gioiTinh);
                kh.setNgaySinh(dob.isEmpty() ? null : Date.valueOf(dob));
                kh.setDiaChi(diaChi);
                kh.setIdTaiKhoan(idTaiKhoan);
                session.setAttribute("currentKhachHang", kh);
                session.setAttribute("maKhachHang", maKhachHang);

                request.setAttribute("message", "Lưu thông tin thành công!");
            } else {
                request.setAttribute("error", "Lưu thông tin thất bại, vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        request.getRequestDispatcher("thongtincanhan.jsp").forward(request, response);
    }
}