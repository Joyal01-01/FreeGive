<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - FreeGive</title>
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
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/search">Search</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/receiver/wishlist" class="active">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
            </ul>
        </div>
    </nav>

    <main class="dashboard-main">
        <div class="container">
            <div class="dashboard-header">
                <div class="dashboard-welcome">
                    <h1>❤️ My Wishlist</h1>
                    <p>Items you've saved for later</p>
                </div>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">🔍 Search More Items</a>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span> ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">
                    <span class="alert-icon">✕</span> ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="card">
                <c:choose>
                    <c:when test="${empty wishlistItems}">
                        <div class="empty-state">
                            <div class="empty-icon">❤️</div>
                            <h3>Your wishlist is empty</h3>
                            <p>Save items while browsing to keep track of things you want.</p>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Browse Items</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="items-grid">
                            <c:forEach var="item" items="${wishlistItems}">
                                <div class="item-card">
                                    <div class="item-card-header">
                                        <h3>${item.name}</h3>
                                        <span class="badge ${item.status == 'available' ? 'badge-success' : 'badge-warning'}">
                                            ${item.status}
                                        </span>
                                    </div>
                                    <p class="item-card-desc">${item.description}</p>
                                    <div class="tag-list">
                                        <c:forEach var="t" items="${item.tagsArray}">
                                            <span class="tag">${t}</span>
                                        </c:forEach>
                                    </div>
                                    <div class="item-card-meta">
                                        <span>📍 ${item.zipcode}</span>
                                        <span>👤 ${item.donorUsername}</span>
                                    </div>
                                    <div class="item-card-actions">
                                        <c:if test="${item.status == 'available'}">
                                            <form action="${pageContext.request.contextPath}/receiver/claim" method="POST" style="display:inline">
                                                <input type="hidden" name="itemId" value="${item.id}">
                                                <button type="submit" class="btn btn-sm btn-primary"
                                                        onclick="return confirm('Claim ${item.name}?')">🤝 Claim</button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/receiver/wishlist" method="POST" style="display:inline">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="itemId" value="${item.id}">
                                            <button type="submit" class="btn btn-sm btn-outline">✕ Remove</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
