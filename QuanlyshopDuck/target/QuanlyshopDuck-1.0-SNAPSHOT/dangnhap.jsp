<%-- 
    Document   : dangnhap
    Created on : May 18, 2025, 6:38:53?PM
    Author     : sphie
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f2f2f2;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        form {
            max-width: 320px;
            width: 90%;
            margin: 0;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h2 {
            color: #ff6f61;
            margin-bottom: 20px;
            text-align: center;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button {
            background: #ff6f61;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            width: 100%;
        }

        button:hover {
            background: #e85b50;
        }

        p {
            text-align: center;
            margin-top: 15px;
        }

        p a {
            color: #ff6f61;
            text-decoration: none;
            font-weight: 600;
        }

        p a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form action="dangnhap" method="post">
        <h2>Đăng nhập</h2>
        Tên đăng nhập: <input type="text" name="tenDangNhap" required /><br>
        Mật khẩu: <input type="password" name="matKhau" required /><br>
        <button type="submit">Đăng nhập</button>
        <p>Bạn chưa có tài khoản? <a href="dangky.jsp">Đăng ký</a></p>
    </form>
</body>
</html>
