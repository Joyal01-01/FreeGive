<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receiver Dashboard - FreeGive</title>
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
                <li><a href="${pageContext.request.contextPath}/search">Search Items</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard" class="active">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/receiver/wishlist">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
            </ul>
        </div>
    </nav>

    <main class="dashboard-main">
        <div class="container">
            <div class="dashboard-header">
                <div class="dashboard-welcome">
                    <h1>Welcome, ${sessionScope.user.username} 👋</h1>
                    <p>Browse and claim items from your community</p>
                </div>
                <div class="dashboard-quick-actions">
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">🔍 Search Items</a>
                    <a href="${pageContext.request.contextPath}/receiver/wishlist" class="btn btn-outline">❤️ Wishlist</a>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">
                    <span class="alert-icon">✕</span>
                    ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <!-- My Claims -->
            <div class="card">
                <div class="card-header">
                    <h2>My Claimed Items</h2>
                    <span class="badge badge-info">${claims.size()} claims</span>
                </div>

                <c:choose>
                    <c:when test="${empty claims}">
                        <div class="empty-state">
                            <div class="empty-icon">🔍</div>
                            <h3>No items claimed yet</h3>
                            <p>Browse available items and claim what you need!</p>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Search Items</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Item Name</th>
                                        <th>Donor</th>
                                        <th>Claimed On</th>
                                        <th>Rating</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="claim" items="${claims}">
                                        <tr>
                                            <td><strong>${claim.itemName}</strong></td>
                                            <td>${claim.donorUsername}</td>
                                            <td><fmt:formatDate value="${claim.claimedAt}" pattern="MMM dd, yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty claim.rating}">
                                                        <span class="rating-stars">
                                                            <c:forEach begin="1" end="${claim.rating}">★</c:forEach>
                                                            <c:forEach begin="${claim.rating + 1}" end="5">☆</c:forEach>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/receiver/claim" method="POST" class="rating-form">
                                                            <input type="hidden" name="claimId" value="${claim.id}">
                                                            <select name="rating" class="rating-select" required>
                                                                <option value="">Rate</option>
                                                                <option value="5">★★★★★</option>
                                                                <option value="4">★★★★☆</option>
                                                                <option value="3">★★★☆☆</option>
                                                                <option value="2">★★☆☆☆</option>
                                                                <option value="1">★☆☆☆☆</option>
                                                            </select>
                                                            <button type="submit" class="btn btn-sm btn-primary">Rate</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
