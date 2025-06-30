/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Xulytaikhoan;

import Database.DBConnection;
import data.khachhang;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dangnhap")
public class dangnhapservlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        
        try (Connection conn = DBConnection.getConnection()) {
            // Authenticate user
            String sql = "SELECT id, role FROM taikhoan WHERE tenDangNhap = ? AND matKhau = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau); // Note: Use hashed passwords in production
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Create session for user
                HttpSession session = request.getSession();
                session.setAttribute("tenDangNhap", tenDangNhap);
                session.setAttribute("idTaiKhoan", rs.getInt("id"));
                session.setAttribute("role", rs.getString("role"));

                // Load existing customer info (for khachhang role)
                if ("khachhang".equalsIgnoreCase(rs.getString("role"))) {
                    String khSql = "SELECT * FROM khachhang WHERE idtaikhoan = ?";
                    PreparedStatement khPs = conn.prepareStatement(khSql);
                    khPs.setInt(1, rs.getInt("id"));
                    ResultSet khRs = khPs.executeQuery();
                    if (khRs.next()) {
                        khachhang kh = new khachhang();
                        kh.setMaKhachHang(khRs.getInt("Makhachhang"));
                        kh.setHoVaTen(khRs.getString("hoVaTen"));
                        kh.setEmail(khRs.getString("email"));
                        kh.setSoDienThoai(khRs.getString("soDienThoai"));
                        kh.setGioiTinh(khRs.getString("gioiTinh"));
                        kh.setNgaySinh(khRs.getDate("ngaySinh"));
                        kh.setDiaChi(khRs.getString("diaChi"));
                        kh.setIdTaiKhoan(rs.getInt("id"));
                        session.setAttribute("currentKhachHang", kh);
                        session.setAttribute("maKhachHang", khRs.getInt("Makhachhang")); // Set maKhachHang
                    }
                    khPs.close();
                    khRs.close();
                }

                // Redirect based on role
                if ("admin".equalsIgnoreCase(rs.getString("role"))) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("trangchu.jsp"); // Redirect to thongtincanhan.jsp
                }
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("dangnhap.jsp").forward(request, response);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi kết nối cơ sở dữ liệu!");
            request.getRequestDispatcher("dangnhap.jsp").forward(request, response);
        }
    }
}