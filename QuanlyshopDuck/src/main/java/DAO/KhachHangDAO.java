/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import data.khachhang; 
import java.sql.*; 

public class KhachHangDAO {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/quanlyshopduck?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456"; 

    public KhachHangDAO() {
        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("JDBC Driver not found!");
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
    }

    // Phương thức để thêm khách hàng mới vào CSDL
    public boolean addKhachHang(khachhang kh) {
        String SQL_INSERT = "INSERT INTO khachhang (hoVaTen, email, soDienThoai, gioiTinh, ngaySinh, diaChi) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL_INSERT)) {

            pstmt.setString(1, kh.getHoVaTen());
            pstmt.setString(2, kh.getEmail());
            pstmt.setString(3, kh.getSoDienThoai());
            pstmt.setString(4, kh.getGioiTinh());
            pstmt.setDate(5, kh.getNgaySinh());
            pstmt.setString(6, kh.getDiaChi());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu có hàng được thêm
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Phương thức để lấy khách hàng theo Email (hoặc ID nếu bạn muốn)
    public khachhang getKhachHangByEmail(String email) {
        String SQL_SELECT = "SELECT * FROM khachhang WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL_SELECT)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                khachhang kh = new khachhang();
                kh.setMaKhachHang(rs.getInt("MaKhachhang"));
                kh.setHoVaTen(rs.getString("hoVaTen"));
                kh.setEmail(rs.getString("email"));
                kh.setSoDienThoai(rs.getString("soDienThoai"));
                kh.setGioiTinh(rs.getString("gioiTinh"));
                kh.setNgaySinh(rs.getDate("ngaySinh"));
                kh.setDiaChi(rs.getString("diaChi"));
                return kh;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy
    }

    // Phương thức để lấy khách hàng cuối cùng được thêm vào (nếu cần)
    public khachhang getLastAddedKhachHang() {
        // Giả sử MaKhachhang là AUTO_INCREMENT và là PK
        String SQL_SELECT_LAST = "SELECT * FROM khachhang ORDER BY MaKhachhang DESC LIMIT 1";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SQL_SELECT_LAST)) {

            if (rs.next()) {
                khachhang kh = new khachhang();
                kh.setMaKhachHang(rs.getInt("MaKhachhang"));
                kh.setHoVaTen(rs.getString("hoVaTen"));
                kh.setEmail(rs.getString("email"));
                kh.setSoDienThoai(rs.getString("soDienThoai"));
                kh.setGioiTinh(rs.getString("gioiTinh"));
                kh.setNgaySinh(rs.getDate("ngaySinh"));
                kh.setDiaChi(rs.getString("diaChi"));
                return kh;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
