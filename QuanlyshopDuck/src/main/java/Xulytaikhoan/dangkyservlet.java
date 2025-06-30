/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Xulytaikhoan;



import Database.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dangky")
public class dangkyservlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy thông tin từ form đăng ký
        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");

        try (Connection conn = DBConnection.getConnection()) {
            // Câu lệnh SQL để thêm tài khoản vào DB
            String sql = "INSERT INTO taikhoan (tenDangNhap, matKhau) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau);
            int result = ps.executeUpdate();

            if (result > 0) {
                // Nếu đăng ký thành công, chuyển hướng đến trang đăng nhập
                response.sendRedirect("dangnhap.jsp");
            } else {
                // Nếu thất bại, báo lỗi
                response.getWriter().println("Đăng ký thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi kết nối cơ sở dữ liệu!");
        }
    }
}


