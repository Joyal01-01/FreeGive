<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Login to FreeGive - Access your community sharing dashboard">
    <title>Login - FreeGive</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo">
                <span class="logo-icon">🎁</span>
                <span class="logo-text">Free<span class="logo-accent">Give</span></span>
            </a>
        </div>
    </nav>

    <main class="auth-main">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>Welcome Back</h1>
                    <p>Sign in to your FreeGive account</p>
                </div>

                <!-- Success message (e.g., after registration) -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success" id="successAlert">
                        <span class="alert-icon">✓</span>
                        ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <!-- Error messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error" id="errorAlert">
                        <span class="alert-icon">✕</span>
                        ${error}
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-error">
                        <span class="alert-icon">✕</span>
                        ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST" class="auth-form" id="loginForm">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" value="${username}"
                               placeholder="Enter your username" required autocomplete="username">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password"
                               placeholder="Enter your password" required autocomplete="current-password">
                    </div>

                    <button type="submit" class="btn btn-primary btn-full" id="loginBtn">
                        Sign In
                        <span class="btn-arrow">→</span>
                    </button>
                </form>

                <div class="auth-footer">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
                </div>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
