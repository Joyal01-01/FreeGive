<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Learn about FreeGive - a community platform for sharing items freely">
    <title>About - FreeGive</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo">
                <span class="logo-icon">🎁</span>
                <span class="logo-text">Free<span class="logo-accent">Give</span></span>
            </a>
            <input type="checkbox" id="nav-toggle" class="nav-toggle-checkbox">
            <label for="nav-toggle" class="nav-toggle-label">
                <span></span><span></span><span></span>
            </label>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/search">Browse Items</a></li>
                <li><a href="${pageContext.request.contextPath}/about" class="active">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li><a href="${pageContext.request.contextPath}/dashboard" class="btn-nav">Dashboard</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login" class="btn-nav">Login</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <main>
        <section class="page-hero">
            <div class="container">
                <h1>About FreeGive</h1>
                <p>Building stronger communities through sharing</p>
            </div>
        </section>

        <section class="content-section">
            <div class="container">
                <div class="content-grid">
                    <div class="content-card">
                        <h2>🎯 Our Mission</h2>
                        <p>FreeGive exists to reduce waste and build community connections. We believe that one person's unused item can be another person's treasure. Our platform makes it easy to share items freely and safely within your neighborhood.</p>
                    </div>
                    <div class="content-card">
                        <h2>🌱 How It Works</h2>
                        <p><strong>Donors</strong> post items they no longer need — furniture, electronics, books, clothing, and more. <strong>Receivers</strong> browse and search for items nearby. When a match is found, they connect to arrange pickup.</p>
                    </div>
                    <div class="content-card">
                        <h2>🔒 Safety First</h2>
                        <p>All accounts are verified by an admin before gaining access. We use secure password hashing, session management, and role-based access control to keep our community safe.</p>
                    </div>
                    <div class="content-card">
                        <h2>💻 Technology</h2>
                        <p>Built with Java EE (Servlets/JSP), MySQL database, and MVC architecture. This project demonstrates enterprise web development practices including JDBC, session management, and responsive design.</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-bottom">
                <p>&copy; 2026 FreeGive. CS5054 Coursework Project.</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
