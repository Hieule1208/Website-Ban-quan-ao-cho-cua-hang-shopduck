<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, Database.DBConnection"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - ShopDuck</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9f9f9;
            color: #333;
            margin: 0;
            padding: 0;
        }
        header {
            background: #ff6f61;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        header h1 {
            font-size: 1.8rem;
            margin: 0;
            display: flex;
            align-items: center;
        }
        header h1::before {
            content: '🛍️';
            margin-right: 10px;
        }
        nav a {
            color: white;
            text-decoration: none;
            margin-left: 25px;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        nav a:hover {
            color: #ffe5e0;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        h2 {
            color: #ff6f61;
            margin-bottom: 20px;
            border-bottom: 2px solid #ff6f61;
            display: inline-block;
            padding-bottom: 5px;
        }
        h3 {
            color: #333;
            margin-bottom: 15px;
        }
        h4 {
            color: #ff6f61;
            margin-top: 20px;
            margin-bottom: 10px;
        }
        .menu {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background: #ff6f61;
            color: white;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        button:hover {
            background: #e35a4e;
            transform: translateY(-2px);
        }
        .section {
            display: none;
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: opacity 0.3s ease;
        }
        .section.active {
            display: block;
            opacity: 1;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-width: 500px;
            margin-bottom: 20px;
        }
        label {
            font-weight: 500;
            color: #333;
        }
        input, select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
            width: 100%;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #ff6f61;
            box-shadow: 0 0 5px rgba(255,111,97,0.3);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: #fff;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background: #ff6f61;
            color: white;
            font-weight: 600;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        tr:hover {
            background: #f1f1f1;
        }
        .action-buttons button {
            padding: 6px 12px;
            font-size: 0.9em;
            margin-right: 5px;
        }
        .confirm-btn {
            background: #28a745;
        }
        .confirm-btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        .ship-btn {
            background: #17a2b8;
        }
        .ship-btn:hover {
            background: #138496;
            transform: translateY(-2px);
        }
        .delivered-btn {
            background: #007bff;
        }
        .delivered-btn:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }
        .cancel-btn {
            background: #dc3545;
        }
        .cancel-btn:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        .disabled-btn {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
            transform: none;
        }
        .disabled-btn:hover {
            background: #6c757d;
            transform: none;
        }
        footer {
            background: #333;
            color: #ddd;
            text-align: center;
            padding: 20px 0;
            font-size: 0.9rem;
            margin-top: 50px;
        }
        @media (max-width: 600px) {
            header {
                flex-direction: column;
                gap: 10px;
            }
            nav a {
                margin-left: 15px;
                font-size: 0.9rem;
            }
            .container {
                padding: 0 10px;
            }
            button {
                padding: 8px 16px;
            }
        }
    </style>
    <script>
        // Function to show/hide sections
        function showSection(id) {
            document.getElementById("khachhang").style.display = "none";
            document.getElementById("sanpham").style.display = "none";
            document.getElementById("danhmuc").style.display = "none";
            document.getElementById("donhang").style.display = "none";
            document.getElementById("thongke").style.display = "none";
            document.getElementById(id).style.display = "block";
            // Reset forms when showing their respective sections
            if (id === 'khachhang') {
                resetCustomerForm();
            } else if (id === 'sanpham') {
                resetProductForm();
            } else if (id === 'danhmuc') {
                resetCategoryForm();
            }
        }

        // --- Customer Management Functions ---
        function resetCustomerForm() {
            document.getElementById("customerId").value = "";
            document.getElementById("hoVaTen").value = "";
            document.getElementById("email").value = "";
            document.getElementById("soDienThoai").value = "";
            document.getElementById("gioiTinh").value = "Nam";
            document.getElementById("ngaySinh").value = "";
            document.getElementById("diaChi").value = "";
            document.getElementById("customerAction").value = "them";
            document.getElementById("submitCustomerBtn").innerText = "Thêm khách hàng";
        }

        function editCustomer(id, hoVaTen, email, soDienThoai, gioiTinh, ngaySinh, diaChi) {
            document.getElementById("customerId").value = id;
            document.getElementById("hoVaTen").value = hoVaTen;
            document.getElementById("email").value = email;
            document.getElementById("soDienThoai").value = soDienThoai;
            document.getElementById("gioiTinh").value = gioiTinh;
            document.getElementById("ngaySinh").value = ngaySinh;
            document.getElementById("diaChi").value = diaChi;
            document.getElementById("customerAction").value = "sua";
            document.getElementById("submitCustomerBtn").innerText = "Cập nhật khách hàng";
            document.getElementById("customerForm").scrollIntoView({ behavior: 'smooth' });
        }

        // --- Product Management Functions ---
        function resetProductForm() {
            document.getElementById("productId").value = "";
            document.getElementById("TenSP").value = "";
            document.getElementById("Gia").value = "";
            document.getElementById("hinhanh").value = "";
            document.getElementById("Mota").value = "";
            document.getElementById("Soluong").value = "";
            document.getElementById("iddanhmuc").value = "";
            document.getElementById("productAction").value = "them";
            document.getElementById("submitProductBtn").innerText = "Thêm sản phẩm";
        }

        function editProduct(maSP, tenSP, gia, hinhanh, mota, soluong, iddanhmuc) {
            document.getElementById("productId").value = maSP;
            document.getElementById("TenSP").value = tenSP;
            document.getElementById("Gia").value = gia;
            document.getElementById("hinhanh").value = hinhanh;
            document.getElementById("Mota").value = mota;
            document.getElementById("Soluong").value = soluong;
            document.getElementById("iddanhmuc").value = iddanhmuc;
            document.getElementById("productAction").value = "sua";
            document.getElementById("submitProductBtn").innerText = "Cập nhật sản phẩm";
            document.getElementById("productForm").scrollIntoView({ behavior: 'smooth' });
        }

        // --- Category Management Functions ---
        function resetCategoryForm() {
            document.getElementById("categoryId").value = "";
            document.getElementById("tendanhmuc").value = "";
            document.getElementById("categoryAction").value = "them";
            document.getElementById("submitCategoryBtn").innerText = "Thêm danh mục";
        }

        function editCategory(id, tendanhmuc) {
            document.getElementById("categoryId").value = id;
            document.getElementById("tendanhmuc").value = tendanhmuc;
            document.getElementById("categoryAction").value = "sua";
            document.getElementById("submitCategoryBtn").innerText = "Cập nhật danh mục";
            document.getElementById("categoryForm").scrollIntoView({ behavior: 'smooth' });
        }

        // --- Order Management Functions ---
        function updateOrderStatus(iddonhang, currentStatus) {
            let xhr = new XMLHttpRequest();
            let newStatus;
            let button = event.target;
            let actionCell = button.parentElement;

            if (currentStatus === "cho_xac_nhan" && button.classList.contains("confirm-btn")) {
                newStatus = "da_xac_nhan";
                button.classList.remove("confirm-btn");
                button.classList.add("ship-btn");
                button.innerText = "Ship";
            } else if (currentStatus === "da_xac_nhan" && button.classList.contains("ship-btn")) {
                newStatus = "dang_giao";
                button.classList.remove("ship-btn");
                button.classList.add("delivered-btn");
                button.innerText = "Delivered";
            } else if (currentStatus === "dang_giao" && button.classList.contains("delivered-btn")) {
                newStatus = "da_giao";
                button.classList.add("disabled-btn");
                button.disabled = true;
                let cancelBtn = document.createElement("button");
                cancelBtn.classList.add("cancel-btn");
                cancelBtn.innerText = "Cancel";
                cancelBtn.onclick = function() { updateOrderStatus(iddonhang, newStatus); };
                actionCell.appendChild(cancelBtn);
                button = cancelBtn; // Update button reference for next check
            } else if ((currentStatus === "cho_xac_nhan" || currentStatus === "da_xac_nhan" || currentStatus === "dang_giao") && button.classList.contains("cancel-btn")) {
                newStatus = "da_huy";
                button.parentElement.removeChild(button);
                let existingButtons = actionCell.getElementsByTagName("button");
                for (let btn of existingButtons) {
                    btn.classList.add("disabled-btn");
                    btn.disabled = true;
                }
            }

            xhr.open("POST", "donhang", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    location.reload(); // Reload page to reflect changes
                }
            };
            xhr.send("action=update&iddonhang=" + iddonhang + "&trangthai=" + newStatus);
        }
    </script>
</head>
<body>
    <header>
        <h1>ShopDuck Admin</h1>
        <nav>
            <a href="adamin.jsp">Trang chủ</a>
            <a href="dangxuat.jsp">Đăng xuất</a>
        </nav>
    </header>

    <div class="container">
        <h2>Trang Quản Trị Admin</h2>
        <div class="menu">
            <button onclick="showSection('khachhang')">Quản lý khách hàng</button>
            <button onclick="showSection('sanpham')">Quản lý sản phẩm</button>
            <button onclick="showSection('danhmuc')">Quản lý danh mục</button>
            <button onclick="showSection('donhang')">Quản lý đơn hàng</button>
            <button onclick="showSection('thongke')">Thống kê đơn hàng</button>
        </div>

        <div id="khachhang" class="section">
            <h3>Quản lý Khách Hàng</h3>
            <form id="customerForm" action="khachhang" method="post">
                <input type="hidden" name="action" value="them" id="customerAction">
                <input type="hidden" name="id" value="" id="customerId">
                <label for="hoVaTen">Họ tên:</label>
                <input type="text" name="hoVaTen" id="hoVaTen" required>
                <label for="email">Email:</label>
                <input type="text" name="email" id="email" required>
                <label for="soDienThoai">SĐT:</label>
                <input type="text" name="soDienThoai" id="soDienThoai" required>
                <label for="gioiTinh">Giới tính:</label>
                <select name="gioiTinh" id="gioiTinh">
                    <option value="Nam">Nam</option>
                    <option value="Nữ">Nữ</option>
                    <option value="Khác">Khác</option>
                </select>
                <label for="ngaySinh">Ngày sinh:</label>
                <input type="date" name="ngaySinh" id="ngaySinh">
                <label for="diaChi">Địa chỉ:</label>
                <input type="text" name="diaChi" id="diaChi">
                <div>
                    <button type="submit" id="submitCustomerBtn">Thêm khách hàng</button>
                    <button type="button" onclick="resetCustomerForm()">Hủy</button>
                </div>
            </form>

            <h4>Danh sách khách hàng:</h4>
            <table>
                <tr>
                    <th>Mã KH</th><th>Họ và Tên</th><th>Email</th><th>SĐT</th><th>Giới tính</th><th>Ngày sinh</th><th>Địa chỉ</th><th>Thao tác</th>
                </tr>
                <%
                    Connection connKhachHang = null;
                    Statement stmtKhachHang = null;
                    ResultSet rsKhachHang = null;
                    try {
                        connKhachHang = DBConnection.getConnection();
                        stmtKhachHang = connKhachHang.createStatement();
                        rsKhachHang = stmtKhachHang.executeQuery("SELECT * FROM khachhang");
                        while (rsKhachHang.next()) {
                %>
                <tr>
                    <td><%=rsKhachHang.getInt("Makhachhang")%></td>
                    <td><%=rsKhachHang.getString("hoVaTen")%></td>
                    <td><%=rsKhachHang.getString("email")%></td>
                    <td><%=rsKhachHang.getString("soDienThoai")%></td>
                    <td><%=rsKhachHang.getString("gioiTinh")%></td>
                    <td><%=rsKhachHang.getDate("ngaySinh") != null ? rsKhachHang.getDate("ngaySinh") : ""%></td>
                    <td><%=rsKhachHang.getString("diaChi") != null ? rsKhachHang.getString("diaChi") : ""%></td>
                    <td class="action-buttons">
                        <button type="button" 
                                onclick="editCustomer(
                                    <%=rsKhachHang.getInt("Makhachhang")%>,
                                    '<%=rsKhachHang.getString("hoVaTen")%>',
                                    '<%=rsKhachHang.getString("email")%>',
                                    '<%=rsKhachHang.getString("soDienThoai")%>',
                                    '<%=rsKhachHang.getString("gioiTinh")%>',
                                    '<%=rsKhachHang.getDate("ngaySinh") != null ? rsKhachHang.getDate("ngaySinh").toString() : ""%>',
                                    '<%=rsKhachHang.getString("diaChi") != null ? rsKhachHang.getString("diaChi") : ""%>'
                                )">Sửa</button>
                        <form action="khachhang" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="xoa">
                            <input type="hidden" name="id" value="<%=rsKhachHang.getInt("Makhachhang")%>">
                            <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này?');">Xóa</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("Lỗi kết nối dữ liệu KH: " + e.getMessage());
                    } finally {
                        try { if (rsKhachHang != null) rsKhachHang.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (stmtKhachHang != null) stmtKhachHang.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (connKhachHang != null) connKhachHang.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </table>
        </div>

        <div id="sanpham" class="section">
            <h3>Quản lý Sản Phẩm</h3>
            <form id="productForm" action="SanPhamServlet" method="post">
                <input type="hidden" name="action" value="them" id="productAction">
                <input type="hidden" name="MaSP" value="" id="productId">
                <label for="TenSP">Tên SP:</label>
                <input type="text" name="TenSP" id="TenSP" required>
                <label for="Gia">Giá:</label>
                <input type="number" name="Gia" id="Gia" required>
                <label for="hinhanh">Hình ảnh:</label>
                <input type="text" name="hinhanh" id="hinhanh">
                <label for="Mota">Mô tả:</label>
                <input type="text" name="Mota" id="Mota">
                <label for="Soluong">Số lượng:</label>
                <input type="number" name="Soluong" id="Soluong">
                <label for="iddanhmuc">Danh mục:</label>
                <select name="iddanhmuc" id="iddanhmuc" required>
                    <option value="" disabled selected>Chọn danh mục</option>
                    <%
                        Connection connDanhMuc = null;
                        Statement stmtDanhMuc = null;
                        ResultSet rsDanhMuc = null;
                        try {
                            connDanhMuc = DBConnection.getConnection();
                            stmtDanhMuc = connDanhMuc.createStatement();
                            rsDanhMuc = stmtDanhMuc.executeQuery("SELECT * FROM danhmuc");
                            while (rsDanhMuc.next()) {
                    %>
                    <option value="<%=rsDanhMuc.getInt("iddanhmuc")%>"><%=rsDanhMuc.getString("tendanhmuc")%></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Lỗi kết nối dữ liệu danh mục: " + e.getMessage());
                        } finally {
                            try { if (rsDanhMuc != null) rsDanhMuc.close(); } catch (SQLException e) { /* ignore */ }
                            try { if (stmtDanhMuc != null) stmtDanhMuc.close(); } catch (SQLException e) { /* ignore */ }
                            try { if (connDanhMuc != null) connDanhMuc.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </select>
                <div>
                    <button type="submit" id="submitProductBtn">Thêm sản phẩm</button>
                    <button type="button" onclick="resetProductForm()">Hủy</button>
                </div>
            </form>

            <h4>Danh sách sản phẩm:</h4>
            <table>
                <tr>
                    <th>Mã SP</th>
                    <th>Tên SP</th>
                    <th>Giá</th>
                    <th>Hình ảnh</th>
                    <th>Mô tả</th>
                    <th>Số lượng</th>
                    <th>Danh mục</th>
                    <th>Thao tác</th>
                </tr>
                <%
                    Connection connSanPham = null;
                    Statement stmtSanPham = null;
                    ResultSet rsSanPham = null;
                    try {
                        connSanPham = DBConnection.getConnection();
                        stmtSanPham = connSanPham.createStatement();
                        rsSanPham = stmtSanPham.executeQuery("SELECT s.*, d.tendanhmuc FROM sanpham s LEFT JOIN danhmuc d ON s.iddanhmuc = d.iddanhmuc");
                        while (rsSanPham.next()) {
                %>
                <tr>
                    <td><%=rsSanPham.getInt("MaSP")%></td>
                    <td><%=rsSanPham.getString("TenSP")%></td>
                    <td><%=rsSanPham.getInt("Gia")%></td>
                    <td><%=rsSanPham.getString("hinhanh") != null ? rsSanPham.getString("hinhanh") : ""%></td>
                    <td><%=rsSanPham.getString("Mota") != null ? rsSanPham.getString("Mota") : ""%></td>
                    <td><%=rsSanPham.getInt("Soluong")%></td>
                    <td><%=rsSanPham.getString("tendanhmuc") != null ? rsSanPham.getString("tendanhmuc") : "Không có danh mục"%></td>
                    <td class="action-buttons">
                        <button type="button" 
                                onclick="editProduct(
                                    <%=rsSanPham.getInt("MaSP")%>,
                                    '<%=rsSanPham.getString("TenSP")%>',
                                    <%=rsSanPham.getInt("Gia")%>,
                                    '<%=rsSanPham.getString("hinhanh") != null ? rsSanPham.getString("hinhanh") : ""%>',
                                    '<%=rsSanPham.getString("Mota") != null ? rsSanPham.getString("Mota") : ""%>',
                                    <%=rsSanPham.getInt("Soluong")%>,
                                    <%=rsSanPham.getInt("iddanhmuc")%>
                                )">Sửa</button>
                        <form action="SanPhamServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="xoa">
                            <input type="hidden" name="id" value="<%=rsSanPham.getInt("MaSP")%>">
                            <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">Xóa</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("Lỗi kết nối dữ liệu SP: " + e.getMessage());
                    } finally {
                        try { if (rsSanPham != null) rsSanPham.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (stmtSanPham != null) stmtSanPham.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (connSanPham != null) connSanPham.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </table>
        </div>

        <div id="danhmuc" class="section">
            <h3>Quản lý Danh Mục</h3>
            <form id="categoryForm" action="DanhMucServlet" method="post">
                <input type="hidden" name="action" value="them" id="categoryAction">
                <input type="hidden" name="iddanhmuc" value="" id="categoryId">
                <label for="tendanhmuc">Tên danh mục:</label>
                <input type="text" name="tendanhmuc" id="tendanhmuc" required>
                <div>
                    <button type="submit" id="submitCategoryBtn">Thêm danh mục</button>
                    <button type="button" onclick="resetCategoryForm()">Hủy</button>
                </div>
            </form>

            <h4>Danh sách danh mục:</h4>
            <table>
                <tr><th>ID</th><th>Tên danh mục</th><th>Thao tác</th></tr>
                <%
                    Connection connDM = null;
                    Statement stmtDM = null;
                    ResultSet rsDM = null;
                    try {
                        connDM = DBConnection.getConnection();
                        stmtDM = connDM.createStatement();
                        rsDM = stmtDM.executeQuery("SELECT * FROM danhmuc");
                        while (rsDM.next()) {
                %>
                <tr>
                    <td><%=rsDM.getInt("iddanhmuc")%></td>
                    <td><%=rsDM.getString("tendanhmuc")%></td>
                    <td class="action-buttons">
                        <button type="button"
                                onclick="editCategory(
                                    <%=rsDM.getInt("iddanhmuc")%>,
                                    '<%=rsDM.getString("tendanhmuc")%>'
                                )">Sửa</button>
                        <form action="DanhMucServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="xoa">
                            <input type="hidden" name="iddanhmuc" value="<%=rsDM.getInt("iddanhmuc")%>">
                            <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">Xóa</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("Lỗi kết nối dữ liệu danh mục: " + e.getMessage());
                    } finally {
                        try { if (rsDM != null) rsDM.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (stmtDM != null) stmtDM.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (connDM != null) connDM.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </table>
        </div>

        <div id="donhang" class="section">
            <h3>Danh sách đơn hàng</h3>
            <h4>Danh sách đơn hàng:</h4>
            <table>
                <tr>
                    <th>Mã đơn hàng</th>
                    <th>Mã người dùng</th>
                    <th>Tên người dùng</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                <%
                    Connection connDonHang = null;
                    Statement stmtDonHang = null;
                    ResultSet rsDonHang = null;
                    try {
                        connDonHang = DBConnection.getConnection();
                        stmtDonHang = connDonHang.createStatement();
                        rsDonHang = stmtDonHang.executeQuery("SELECT d.iddonhang, d.Makhachhang AS user_id, k.hoVaTen AS customer_name, d.tongtien, d.trangthai FROM donhang d LEFT JOIN khachhang k ON d.Makhachhang = k.Makhachhang");
                        while (rsDonHang.next()) {
                            String status = rsDonHang.getString("trangthai");
                            String actionButton = "";
                            if ("da_huy".equals(status)) {
                                actionButton = "<button class='disabled-btn' disabled>Cancelled</button>";
                            } else {
                                if ("cho_xac_nhan".equals(status)) {
                                    actionButton = "<button class='confirm-btn' onclick='updateOrderStatus(" + rsDonHang.getInt("iddonhang") + ", \"" + status + "\")'>Confirm</button>";
                                } else if ("da_xac_nhan".equals(status)) {
                                    actionButton = "<button class='ship-btn' onclick='updateOrderStatus(" + rsDonHang.getInt("iddonhang") + ", \"" + status + "\")'>Ship</button>";
                                } else if ("dang_giao".equals(status)) {
                                    actionButton = "<button class='delivered-btn' onclick='updateOrderStatus(" + rsDonHang.getInt("iddonhang") + ", \"" + status + "\")'>Delivered</button>";
                                } else if ("da_giao".equals(status)) {
                                    actionButton = "<button class='disabled-btn' disabled>Delivered</button>";
                                }
                                if (!"da_giao".equals(status)) {
                                    actionButton += " <button class='cancel-btn' onclick='updateOrderStatus(" + rsDonHang.getInt("iddonhang") + ", \"" + status + "\")'>Cancel</button>";
                                }
                            }
                %>
                <tr>
                    <td><%=rsDonHang.getInt("iddonhang")%></td>
                    <td><%=rsDonHang.getInt("user_id")%></td>
                    <td><%=rsDonHang.getString("customer_name") != null ? rsDonHang.getString("customer_name") : "Unknown"%></td>
                    <td><%=rsDonHang.getBigDecimal("tongtien") != null ? rsDonHang.getBigDecimal("tongtien") + " VND" : "0 VND"%></td>
                    <td><%=status != null ? status.replace("_", " ") : "Unknown"%></td>
                    <td class="action-buttons"><%=actionButton%></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("Lỗi kết nối dữ liệu đơn hàng: " + e.getMessage());
                    } finally {
                        try { if (rsDonHang != null) rsDonHang.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (stmtDonHang != null) stmtDonHang.close(); } catch (SQLException e) { /* ignore */ }
                        try { if (connDonHang != null) connDonHang.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </table>
        </div>

        <div id="thongke" class="section">
            <h3>Thống kê Đơn Hàng</h3>
            <h4>Thống kê đơn hàng đã giao:</h4>
            <%
                Connection connThongKe = null;
                Statement stmtThongKe = null;
                ResultSet rsThongKe = null;
                int totalDeliveredOrders = 0;
                double totalRevenue = 0.0;
                try {
                    connThongKe = DBConnection.getConnection();
                    stmtThongKe = connThongKe.createStatement();
                    rsThongKe = stmtThongKe.executeQuery("SELECT COUNT(*) AS total_orders, SUM(tongtien) AS total_revenue FROM donhang WHERE trangthai = 'da_giao'");
                    if (rsThongKe.next()) {
                        totalDeliveredOrders = rsThongKe.getInt("total_orders");
                        totalRevenue = rsThongKe.getDouble("total_revenue");
                    }
                } catch (Exception e) {
                    out.println("Lỗi kết nối dữ liệu thống kê: " + e.getMessage());
                } finally {
                    try { if (rsThongKe != null) rsThongKe.close(); } catch (SQLException e) { /* ignore */ }
                    try { if (stmtThongKe != null) stmtThongKe.close(); } catch (SQLException e) { /* ignore */ }
                    try { if (connThongKe != null) connThongKe.close(); } catch (SQLException e) { /* ignore */ }
                }
            %>
            <div style="padding: 15px; background: #f9f9f9; border-radius: 5px; margin-bottom: 20px;">
                <p><strong>Tổng số đơn hàng đã giao:</strong> <%=totalDeliveredOrders%></p>
                <p><strong>Tổng doanh thu:</strong> <%=String.format("%,.0f", totalRevenue)%> VND</p>
            </div>
        </div>
    </div>

    <footer>
        <p>© 2025 ShopDuck. Mọi quyền được bảo lưu.</p>
    </footer>
</body>
</html>