<%-- 
    Document   : dangxuat.jsp
    Created on : May 20, 2025, 2:07:24 PM
    Author     : sphie
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Xoá session người dùng
    response.sendRedirect("dangnhap.jsp"); // Quay lại trang chủ
%>

