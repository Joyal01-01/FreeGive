<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Search free items available in your community on FreeGive">
    <title>Search Items - FreeGive</title>
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
                <li><a href="${pageContext.request.contextPath}/search" class="active">Search</a></li>
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

    <main class="dashboard-main">
        <div class="container">
            <div class="search-header">
                <h1>🔍 Find Free Items</h1>
                <p>Search for items available in your community</p>
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

            <!-- Search Form -->
            <div class="search-bar-card">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="search-form" id="searchForm">
                    <div class="search-inputs">
                        <div class="form-group">
                            <input type="text" id="keyword" name="keyword" value="${keyword}"
                                   placeholder="Search by name or description..." class="search-input"
                                   autocomplete="off">
                        </div>
                        <div class="form-group">
                            <input type="text" id="tagSearch" name="tag" value="${tag}"
                                   placeholder="Filter by tag..." class="search-input">
                        </div>
                        <div class="form-group">
                            <input type="text" name="zipcode" value="${zipcode}"
                                   placeholder="Zipcode..." class="search-input search-input-sm">
                        </div>
                    </div>
                    <div class="search-actions">
                        <c:if test="${not empty sessionScope.user}">
                            <label class="checkbox-label">
                                <input type="checkbox" name="nearMe" ${not empty param.nearMe ? 'checked' : ''}>
                                <span>Near me</span>
                            </label>
                        </c:if>
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline">Clear</a>
                    </div>
                </form>
            </div>

            <!-- Results -->
            <div class="card">
                <div class="card-header">
                    <h2>
                        <c:choose>
                            <c:when test="${searched}">Search Results</c:when>
                            <c:otherwise>All Available Items</c:otherwise>
                        </c:choose>
                    </h2>
                    <span class="badge badge-info">${results.size()} items</span>
                </div>

                <c:choose>
                    <c:when test="${empty results}">
                        <div class="empty-state">
                            <div class="empty-icon">📭</div>
                            <h3>No items found</h3>
                            <p>Try different search terms or clear filters.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Live Filter -->
                        <div class="table-filter">
                            <input type="text" id="liveFilter" placeholder="Quick filter results..."
                                   class="search-input search-input-sm">
                        </div>

                        <div class="table-responsive">
                            <table class="data-table" id="resultsTable">
                                <thead>
                                    <tr>
                                        <th>Item</th>
                                        <th>Description</th>
                                        <th>Tags</th>
                                        <th>Donor</th>
                                        <th>Zip</th>
                                        <th>Expires</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${results}">
                                        <tr>
                                            <td>
                                                <strong>${item.name}</strong>
                                                <c:if test="${not empty item.photoPath}">
                                                    <span title="Has photo">📷</span>
                                                </c:if>
                                            </td>
                                            <td class="desc-cell">
                                                ${item.description != null && item.description.length() > 80
                                                    ? item.description.substring(0, 80).concat('...')
                                                    : item.description}
                                            </td>
                                            <td>
                                                <div class="tag-list">
                                                    <c:forEach var="t" items="${item.tagsArray}">
                                                        <span class="tag">${t}</span>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>${item.donorUsername}</td>
                                            <td>${item.zipcode}</td>
                                            <td><fmt:formatDate value="${item.expiry}" pattern="MMM dd"/></td>
                                            <td>
                                                <div class="action-buttons">
                                                    <c:if test="${not empty sessionScope.user && sessionScope.role == 'receiver'}">
                                                        <form action="${pageContext.request.contextPath}/receiver/claim" method="POST" style="display:inline">
                                                            <input type="hidden" name="itemId" value="${item.id}">
                                                            <button type="submit" class="btn btn-sm btn-primary"
                                                                    onclick="return confirm('Claim this item: ${item.name}?')">
                                                                🤝 Claim
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/receiver/wishlist" method="POST" style="display:inline">
                                                            <input type="hidden" name="action" value="add">
                                                            <input type="hidden" name="itemId" value="${item.id}">
                                                            <button type="submit" class="btn btn-sm btn-outline" title="Add to wishlist">❤️</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${empty sessionScope.user}">
                                                        <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline">Login to Claim</a>
                                                    </c:if>
                                                </div>
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
