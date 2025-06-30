/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Xulythongtin;

/**
 *
 * @author sphie
 */
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import data.giohang;

public class SessionManager {

    // Lấy giỏ hàng từ session.  Nếu không tồn tại, tạo mới.
    public static List<giohang> getCart(HttpSession session) {
        List<giohang> cart = (List<giohang>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    // Lưu giỏ hàng vào session
    public static void setCart(HttpSession session, List<giohang> cart) {
        session.setAttribute("cart", cart);
    }
}
