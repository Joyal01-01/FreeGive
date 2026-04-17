<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Item - FreeGive</title>
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
                <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
            </ul>
        </div>
    </nav>

    <main class="dashboard-main">
        <div class="container">
            <div class="form-page-header">
                <a href="${pageContext.request.contextPath}/dashboard" class="back-link">← Back to Dashboard</a>
                <h1>Edit Item</h1>
                <p>Update your item details</p>
            </div>

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

            <div class="card">
                <form action="${pageContext.request.contextPath}/donor/edit-item" method="POST"
                      enctype="multipart/form-data" class="item-form" id="editItemForm">
                    <input type="hidden" name="id" value="${item.id}">

                    <div class="form-group">
                        <label for="name">Item Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name" value="${item.name}"
                               placeholder="Item name" required maxlength="100">
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4">${item.description}</textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="tags">Tags</label>
                            <input type="text" id="tags" name="tags" value="${item.tags}"
                                   placeholder="comma-separated tags">
                            <div class="tag-preview" id="tagPreview"></div>
                        </div>
                        <div class="form-group">
                            <label for="zipcode">Zipcode</label>
                            <input type="text" id="zipcode" name="zipcode" value="${item.zipcode}"
                                   pattern="\d{4,10}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="expiry">Expiry Date</label>
                            <input type="date" id="expiry" name="expiry" value="${item.expiry}">
                        </div>
                        <div class="form-group">
                            <label for="photo">Update Photo</label>
                            <input type="file" id="photo" name="photo" accept="image/*" class="file-input">
                            <label for="photo" class="file-label">
                                <span class="file-icon">📷</span>
                                <span class="file-text">Choose new photo</span>
                            </label>
                            <c:if test="${not empty item.photoPath}">
                                <p class="form-hint">Current photo: ${item.photoPath}</p>
                            </c:if>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">Cancel</a>
                        <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
