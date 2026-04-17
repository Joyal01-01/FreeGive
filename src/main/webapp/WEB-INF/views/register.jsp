<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Register for FreeGive - Join our community sharing platform">
    <title>Register - FreeGive</title>
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
            <div class="auth-card auth-card-wide">
                <div class="auth-header">
                    <h1>Create Account</h1>
                    <p>Join FreeGive and start sharing with your community</p>
                </div>

                <!-- Error Messages -->
                <c:if test="${not empty errors}">
                    <div class="alert alert-error">
                        <span class="alert-icon">✕</span>
                        <ul class="error-list">
                            <c:forEach var="err" items="${errors}">
                                <li>${err}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form" id="registerForm">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="username">Username <span class="required">*</span></label>
                            <input type="text" id="username" name="username"
                                   value="${user != null ? user.username : ''}"
                                   placeholder="Choose a username" required
                                   pattern="[A-Za-z0-9_]{3,50}" title="3-50 characters: letters, numbers, underscore">
                            <span class="form-hint">3-50 characters, letters, numbers & underscore</span>
                        </div>

                        <div class="form-group">
                            <label for="email">Email <span class="required">*</span></label>
                            <input type="email" id="email" name="email"
                                   value="${user != null ? user.email : ''}"
                                   placeholder="your@email.com" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">Password <span class="required">*</span></label>
                            <input type="password" id="password" name="password"
                                   placeholder="Min. 6 characters" required minlength="6">
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Repeat your password" required minlength="6">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone">Phone <span class="required">*</span></label>
                            <input type="tel" id="phone" name="phone"
                                   value="${user != null ? user.phone : ''}"
                                   placeholder="10-15 digit number" required
                                   pattern="\d{10,15}" title="10-15 digits only">
                        </div>

                        <div class="form-group">
                            <label for="zipcode">Zipcode <span class="required">*</span></label>
                            <input type="text" id="zipcode" name="zipcode"
                                   value="${user != null ? user.zipcode : ''}"
                                   placeholder="Your zipcode" required
                                   pattern="\d{4,10}" title="4-10 digits">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>I want to <span class="required">*</span></label>
                        <div class="role-selector">
                            <label class="role-option">
                                <input type="radio" name="role" value="donor"
                                       ${user != null && user.role == 'donor' ? 'checked' : ''} required>
                                <div class="role-card">
                                    <span class="role-icon">🎁</span>
                                    <span class="role-title">Donate Items</span>
                                    <span class="role-desc">Share things I no longer need</span>
                                </div>
                            </label>
                            <label class="role-option">
                                <input type="radio" name="role" value="receiver"
                                       ${user != null && user.role == 'receiver' ? 'checked' : ''}>
                                <div class="role-card">
                                    <span class="role-icon">🔍</span>
                                    <span class="role-title">Receive Items</span>
                                    <span class="role-desc">Find things I need for free</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-full" id="registerBtn">
                        Create Account
                        <span class="btn-arrow">→</span>
                    </button>
                </form>

                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
                </div>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
