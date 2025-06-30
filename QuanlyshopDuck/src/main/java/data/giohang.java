/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data;

/**
 *
 * @author sphie
 */
import java.io.Serializable; // Important: Make CartItem serializable

public class giohang implements Serializable {
    private int productId;
    private String productName;
    private double price;
    private int quantity;
    private String productImage;

    public giohang(int productId, String productName, double price, int quantity, String productImage) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.productImage = productImage;
    }

    public int getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        
    }
    public void setTotalPrice(double price) {
        this.price = price;
        
    }

    public double getTotalPrice() {
        return price * quantity;
        
    }

    public String getProductImage() {
        return productImage;
    }
}