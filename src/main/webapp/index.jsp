<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FreeGive - Share items freely with your community. Donate what you don't need, find what you do.">
    <title>FreeGive - Community Item Sharing</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
                <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li><a href="${pageContext.request.contextPath}/dashboard" class="btn-nav">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login" class="btn-nav">Login</a></li>
                        <li><a href="${pageContext.request.contextPath}/register" class="btn-nav btn-nav-outline">Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <main>
        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-bg-shapes">
                <div class="shape shape-1"></div>
                <div class="shape shape-2"></div>
                <div class="shape shape-3"></div>
            </div>
            <div class="container">
                <div class="hero-content">
                    <h1 class="hero-title">
                        Give Freely,<br>
                        <span class="gradient-text">Receive Gratefully</span>
                    </h1>
                    <p class="hero-subtitle">
                        Join our community where neighbors share items they no longer need.
                        From furniture to books, find treasures or give yours a new home.
                    </p>
                    <div class="hero-actions">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">
                            Get Started
                            <span class="btn-arrow">→</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline btn-lg">
                            Browse Items
                        </a>
                    </div>
                    <div class="hero-stats">
                        <div class="stat">
                            <span class="stat-number">100+</span>
                            <span class="stat-label">Items Shared</span>
                        </div>
                        <div class="stat">
                            <span class="stat-number">50+</span>
                            <span class="stat-label">Happy Members</span>
                        </div>
                        <div class="stat">
                            <span class="stat-number">25+</span>
                            <span class="stat-label">Communities</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features">
            <div class="container">
                <h2 class="section-title">How It Works</h2>
                <p class="section-subtitle">Three simple steps to start sharing</p>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">📝</div>
                        <h3>Register</h3>
                        <p>Sign up as a donor or receiver. An admin will verify your account for safety.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">📦</div>
                        <h3>Post or Search</h3>
                        <p>Donors post items they want to give away. Receivers search and browse available items nearby.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">🤝</div>
                        <h3>Claim & Connect</h3>
                        <p>Found something you need? Claim it! Connect with the donor and arrange a pickup.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <div class="cta-card">
                    <h2>Ready to make a difference?</h2>
                    <p>Join FreeGive today and be part of a community that believes in sharing.</p>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">
                        Join Now — It's Free
                    </a>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-brand">
                    <span class="logo-icon">🎁</span>
                    <span class="logo-text">Free<span class="logo-accent">Give</span></span>
                    <p>Sharing made simple.</p>
                </div>
                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/about">About</a>
                    <a href="${pageContext.request.contextPath}/contact">Contact</a>
                    <a href="${pageContext.request.contextPath}/search">Browse</a>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 FreeGive. CS5054 Coursework Project.</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
