<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Search results for free items on FreeGive">
    <title>Search Results - FreeGive</title>
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
                <li><a href="${pageContext.request.contextPath}/search">Search</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <c:if test="${sessionScope.role == 'receiver'}">
                        <li><a href="${pageContext.request.contextPath}/receiver/wishlist">❤️ Wishlist</a></li>
                    </c:if>
                    <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <li><a href="${pageContext.request.contextPath}/login" class="btn-nav">Login</a></li>
                </c:if>
            </ul>
        </div>
    </nav>

    <main class="search-results-main">
        <div class="container">
            <!-- Header -->
            <div class="search-results-header">
                <div class="results-title">
                    <a href="${pageContext.request.contextPath}/search" class="back-link">← Back</a>
                    <h1>🔍 Search Results</h1>
                    <span class="results-count badge badge-info">${results.size()} items found</span>
                </div>
            </div>

            <!-- Alerts -->
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
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <span class="alert-icon">✕</span> ${error}
                </div>
            </c:if>

            <!-- Search Filters -->
            <div class="search-filters-card">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="filters-form">
                    <div class="filter-group">
                        <label>Keyword</label>
                        <input type="text" name="keyword" value="${keyword}" placeholder="Search items..." class="filter-input">
                    </div>
                    <div class="filter-group">
                        <label>Tags</label>
                        <input type="text" name="tag" value="${tag}" placeholder="Filter by tags..." class="filter-input">
                    </div>
                    <div class="filter-group">
                        <label>Zipcode</label>
                        <input type="text" name="zipcode" value="${zipcode}" placeholder="Location..." class="filter-input">
                    </div>
                    <c:if test="${not empty sessionScope.user}">
                        <div class="filter-group checkbox-group">
                            <label class="checkbox-label">
                                <input type="checkbox" name="nearMe" ${not empty param.nearMe ? 'checked' : ''}>
                                <span>Near me</span>
                            </label>
                        </div>
                    </c:if>
                    <div class="filter-actions">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline">Clear</a>
                    </div>
                </form>
            </div>

            <!-- Results Grid -->
            <c:choose>
                <c:when test="${empty results}">
                    <div class="empty-state">
                        <div class="empty-icon">📭</div>
                        <h2>No items found</h2>
                        <p>Try adjusting your search filters or browse all items.</p>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Browse All Items</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="items-grid">
                        <c:forEach var="item" items="${results}">
                            <div class="item-card">
                                <div class="item-card-header">
                                    <c:if test="${not empty item.photoPath}">
                                        <img src="${pageContext.request.contextPath}${item.photoPath}" alt="${item.name}" class="item-image">
                                    </c:if>
                                    <c:if test="${empty item.photoPath}">
                                        <div class="item-image-placeholder">📦</div>
                                    </c:if>
                                    <div class="item-status-badge">
                                        <span class="badge badge-success">Available</span>
                                    </div>
                                </div>

                                <div class="item-card-body">
                                    <h3 class="item-name">${item.name}</h3>
                                    
                                    <p class="item-description">
                                        ${item.description != null && item.description.length() > 100
                                            ? item.description.substring(0, 100).concat('...')
                                            : item.description}
                                    </p>

                                    <c:if test="${not empty item.tagsArray}">
                                        <div class="tag-list">
                                            <c:forEach var="t" items="${item.tagsArray}">
                                                <span class="tag">${t}</span>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="item-meta">
                                        <div class="meta-item">
                                            <span class="meta-label">Donor</span>
                                            <span class="meta-value">${item.donorUsername}</span>
                                        </div>
                                        <div class="meta-item">
                                            <span class="meta-label">Location</span>
                                            <span class="meta-value">${item.zipcode}</span>
                                        </div>
                                        <div class="meta-item">
                                            <span class="meta-label">Expires</span>
                                            <span class="meta-value"><fmt:formatDate value="${item.expiry}" pattern="MMM dd, yyyy"/></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="item-card-footer">
                                    <c:if test="${not empty sessionScope.user && sessionScope.role == 'receiver'}">
                                        <form action="${pageContext.request.contextPath}/receiver/claim" method="POST" style="display:inline; flex:1;">
                                            <input type="hidden" name="itemId" value="${item.id}">
                                            <button type="submit" class="btn btn-primary btn-block"
                                                    onclick="return confirm('Claim this item: ${item.name}?')">
                                                🤝 Claim
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/receiver/wishlist" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="itemId" value="${item.id}">
                                            <button type="submit" class="btn btn-outline btn-icon" title="Add to wishlist">❤️</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${empty sessionScope.user}">
                                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-block">Login to Claim</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>FreeGive</h4>
                    <p>Community item sharing made simple and sustainable.</p>
                </div>
                <div class="footer-section">
                    <h4>Links</h4>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                        <li><a href="${pageContext.request.contextPath}/search">Browse</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 FreeGive. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
