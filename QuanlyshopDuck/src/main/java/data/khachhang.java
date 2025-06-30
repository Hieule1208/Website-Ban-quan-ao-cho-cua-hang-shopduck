/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data;

import java.sql.Date;

public class khachhang {
    private int maKhachHang;
    private String hoVaTen;
    private String email;
    private String soDienThoai;
    private String gioiTinh;
    private Date ngaySinh;
    private String diaChi;
    private int idTaiKhoan;

    // Constructor
    public khachhang() {}

    public khachhang(String hoVaTen, String email, String soDienThoai, String gioiTinh, Date ngaySinh, String diaChi, int idTaiKhoan) {
        this.hoVaTen = hoVaTen;
        this.email = email;
        this.soDienThoai = soDienThoai;
        this.gioiTinh = gioiTinh;
        this.ngaySinh = ngaySinh;
        this.diaChi = diaChi;
        this.idTaiKhoan = idTaiKhoan;
    }

    // Getters and Setters
    public int getMaKhachHang() { return maKhachHang; }
    public void setMaKhachHang(int maKhachHang) { this.maKhachHang = maKhachHang; }
    public String getHoVaTen() { return hoVaTen; }
    public void setHoVaTen(String hoVaTen) { this.hoVaTen = hoVaTen; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }
    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }
    public Date getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(Date ngaySinh) { this.ngaySinh = ngaySinh; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public int getIdTaiKhoan() { return idTaiKhoan; }
    public void setIdTaiKhoan(int idTaiKhoan) { this.idTaiKhoan = idTaiKhoan; }
}