<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donor Dashboard - FreeGive</title>
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
                <li><a href="${pageContext.request.contextPath}/dashboard" class="active">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/donor/post-item" class="btn-nav">+ Post Item</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
            </ul>
        </div>
    </nav>

    <main class="dashboard-main">
        <div class="container">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <div class="dashboard-welcome">
                    <h1>Welcome, ${sessionScope.user.username} 👋</h1>
                    <p>Manage your donated items and track claims</p>
                </div>
                <a href="${pageContext.request.contextPath}/donor/post-item" class="btn btn-primary">
                    + Post New Item
                </a>
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

            <!-- Items Table -->
            <div class="card">
                <div class="card-header">
                    <h2>My Posted Items</h2>
                    <span class="badge badge-info">${items.size()} items</span>
                </div>

                <c:choose>
                    <c:when test="${empty items}">
                        <div class="empty-state">
                            <div class="empty-icon">📦</div>
                            <h3>No items posted yet</h3>
                            <p>Start by posting your first item to share with the community.</p>
                            <a href="${pageContext.request.contextPath}/donor/post-item" class="btn btn-primary">Post Your First Item</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" id="itemsTable">
                                <thead>
                                    <tr>
                                        <th>Item Name</th>
                                        <th>Tags</th>
                                        <th>Zipcode</th>
                                        <th>Expiry</th>
                                        <th>Status</th>
                                        <th>Claimed By</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${items}">
                                        <tr>
                                            <td>
                                                <strong>${item.name}</strong>
                                                <c:if test="${not empty item.photoPath}">
                                                    <span class="has-photo" title="Has photo">📷</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="tag-list">
                                                    <c:forEach var="tag" items="${item.tagsArray}">
                                                        <span class="tag">${tag}</span>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>${item.zipcode}</td>
                                            <td><fmt:formatDate value="${item.expiry}" pattern="MMM dd, yyyy"/></td>
                                            <td>
                                                <span class="badge ${item.status == 'available' ? 'badge-success' : 'badge-warning'}">
                                                    ${item.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:set var="claimKey" value="claim_${item.id}"/>
                                                <c:choose>
                                                    <c:when test="${not empty requestScope[claimKey]}">
                                                        ${requestScope[claimKey].claimerUsername}
                                                        <c:if test="${not empty requestScope[claimKey].rating}">
                                                            <br><span class="rating-stars">
                                                                <c:forEach begin="1" end="${requestScope[claimKey].rating}">★</c:forEach>
                                                            </span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <c:if test="${item.status == 'available'}">
                                                        <a href="${pageContext.request.contextPath}/donor/edit-item?id=${item.id}"
                                                           class="btn btn-sm btn-outline" title="Edit">✏️ Edit</a>
                                                    </c:if>
                                                    <form action="${pageContext.request.contextPath}/donor/delete-item" method="POST"
                                                          style="display:inline" onsubmit="return confirm('Are you sure you want to delete this item?')">
                                                        <input type="hidden" name="id" value="${item.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger" title="Delete">🗑️ Delete</button>
                                                    </form>
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
