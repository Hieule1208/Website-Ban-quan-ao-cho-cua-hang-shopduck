/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Xulythongtin;


import data.giohang;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter; // Thêm import này
import java.util.List;

@WebServlet("/updateCart")
public class UpdateCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Lấy productId và quantity từ request
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            // Kiểm tra và chuyển đổi sang kiểu số nguyên
            if (productIdStr == null || productIdStr.isEmpty() || quantityStr == null || quantityStr.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Thiếu tham số sản phẩm hoặc số lượng.\"}");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            // Đảm bảo số lượng không nhỏ hơn 1
            if (quantity < 1) {
                quantity = 1;
            }

            HttpSession session = request.getSession();
            List<giohang> cart = (List<giohang>) session.getAttribute("cart");

            double total = 0; // Khởi tạo lại tổng cộng

            if (cart == null) {
                out.print("{\"success\": false, \"message\": \"Giỏ hàng không tồn tại.\"}");
                return;
            }

            boolean productFound = false;
            // Cập nhật số lượng của sản phẩm cụ thể
            for (giohang item : cart) {
                if (item.getProductId() == productId) { // Sửa lỗi so sánh int == int
                    item.setQuantity(quantity);
                    productFound = true;
                    // Không cần break ở đây nếu bạn muốn tính lại total từ đầu sau khi cập nhật
                    // Tuy nhiên, break là tốt nếu bạn chỉ muốn cập nhật 1 item rồi tính tổng.
                    // Với vòng lặp này, chúng ta sẽ tính lại total sau khi cập nhật xong.
                }
            }

            // Sau khi cập nhật số lượng của sản phẩm, tính lại tổng cộng của TOÀN BỘ giỏ hàng
            for (giohang item : cart) {
                total += item.getQuantity() * item.getPrice();
            }

            // Cập nhật lại giỏ hàng trong session (đảm bảo thay đổi được lưu)
            // Dù list đã được thay đổi, việc set lại session đảm bảo thay đổi được persisted.
            session.setAttribute("cart", cart);

            // Chuẩn bị phản hồi JSON
            String totalFormatted = String.format("%,.0f", total); // Định dạng tổng tiền
            String json = String.format("{\"success\": %b, \"total\": %.0f, \"totalFormatted\": \"%s\"}",
                                        productFound, total, totalFormatted);

            out.print(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            out.print("{\"success\": false, \"message\": \"Dữ liệu sản phẩm hoặc số lượng không hợp lệ.\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            out.print("{\"success\": false, \"message\": \"Lỗi máy chủ nội bộ: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}