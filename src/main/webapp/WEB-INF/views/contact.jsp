<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Contact FreeGive - Get in touch with our team">
    <title>Contact - FreeGive</title>
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
                <li><a href="${pageContext.request.contextPath}/search">Browse</a></li>
                <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact" class="active">Contact</a></li>
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
                <h1>Contact Us</h1>
                <p>We'd love to hear from you</p>
            </div>
        </section>

        <section class="content-section">
            <div class="container">
                <div class="contact-layout">
                    <div class="contact-info">
                        <h2>Get In Touch</h2>
                        <div class="contact-item">
                            <span class="contact-icon">📧</span>
                            <div>
                                <h3>Email</h3>
                                <p>support@freegive.com</p>
                            </div>
                        </div>
                        <div class="contact-item">
                            <span class="contact-icon">📍</span>
                            <div>
                                <h3>Location</h3>
                                <p>University Campus, CS5054</p>
                            </div>
                        </div>
                        <div class="contact-item">
                            <span class="contact-icon">⏰</span>
                            <div>
                                <h3>Hours</h3>
                                <p>Mon - Fri: 9:00 AM - 5:00 PM</p>
                            </div>
                        </div>
                    </div>

                    <div class="contact-form-card">
                        <h2>Send a Message</h2>
                        <form class="auth-form" id="contactForm" onsubmit="handleContactSubmit(event)">
                            <div class="form-group">
                                <label for="contactName">Name</label>
                                <input type="text" id="contactName" placeholder="Your name" required>
                            </div>
                            <div class="form-group">
                                <label for="contactEmail">Email</label>
                                <input type="email" id="contactEmail" placeholder="your@email.com" required>
                            </div>
                            <div class="form-group">
                                <label for="contactMessage">Message</label>
                                <textarea id="contactMessage" rows="5" placeholder="How can we help?" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary btn-full">Send Message</button>
                        </form>
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
