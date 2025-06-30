/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Xulythongtin;



import data.giohang;
import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/donhang")
public class DonHangServlet extends HttpServlet {

  @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("update".equals(action)) {
        // ==== Cập nhật trạng thái đơn hàng ====
        int idDonHang = Integer.parseInt(request.getParameter("iddonhang"));
        String trangThai = request.getParameter("trangthai");

        try (Connection conn = DBConnection.getConnection()) {
            String updateSQL = "UPDATE donhang SET trangthai = ? WHERE iddonhang = ?";
            PreparedStatement ps = conn.prepareStatement(updateSQL);
            ps.setString(1, trangThai);
            ps.setInt(2, idDonHang);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        return; // Đã xử lý cập nhật xong
    }

    // ==== Xử lý đặt hàng ====
    HttpSession session = request.getSession();
    Integer maKhachHang = (Integer) session.getAttribute("maKhachHang");
    List<giohang> cart = (List<giohang>) session.getAttribute("cart");

    if (maKhachHang == null) {
        request.setAttribute("error", "Vui lòng nhập thông tin khách hàng trước khi đặt hàng!");
        request.getRequestDispatcher("thongtincanhan.jsp").forward(request, response);
        return;
    }

    if (cart == null || cart.isEmpty()) {
        request.setAttribute("error", "Giỏ hàng trống!");
        request.getRequestDispatcher("giohang.jsp").forward(request, response);
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        double tongtien = 0;
        for (giohang item : cart) {
            tongtien += item.getPrice() * item.getQuantity();
        }

        String sql = "INSERT INTO donhang (tongtien, trangthai, Makhachhang) VALUES (?, 'cho_xac_nhan', ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setDouble(1, tongtien);
        ps.setInt(2, maKhachHang);
        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        int orderId = 0;
        if (rs.next()) {
            orderId = rs.getInt(1);
        }

        request.setAttribute("orderId", orderId);
        request.setAttribute("message", "Đặt hàng thành công! Mã đơn hàng: " + orderId);
        session.removeAttribute("cart");
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Lỗi khi lưu đơn hàng: " + e.getMessage());
    }

    request.getRequestDispatcher("thongtincanhan.jsp").forward(request, response);
}
}