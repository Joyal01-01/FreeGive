<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Item - FreeGive</title>
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
                <h1>Post a New Item</h1>
                <p>Share something you no longer need with your community</p>
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
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <span class="alert-icon">✕</span> ${error}
                </div>
            </c:if>

            <div class="card">
                <form action="${pageContext.request.contextPath}/donor/post-item" method="POST"
                      enctype="multipart/form-data" class="item-form" id="postItemForm">

                    <div class="form-group">
                        <label for="name">Item Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name"
                               value="${item != null ? item.name : ''}"
                               placeholder="e.g., Wooden Dining Table" required maxlength="100">
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4"
                                  placeholder="Describe the item condition, size, any defects...">${item != null ? item.description : ''}</textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="tags">Tags <span class="form-hint-inline">(comma-separated)</span></label>
                            <input type="text" id="tags" name="tags"
                                   value="${item != null ? item.tags : ''}"
                                   placeholder="e.g., furniture, wood, dining">
                            <div class="tag-preview" id="tagPreview"></div>
                        </div>

                        <div class="form-group">
                            <label for="zipcode">Zipcode</label>
                            <input type="text" id="zipcode" name="zipcode"
                                   value="${item != null ? item.zipcode : sessionScope.user.zipcode}"
                                   placeholder="Item location zipcode"
                                   pattern="\d{4,10}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="expiry">Expiry Date</label>
                            <input type="date" id="expiry" name="expiry"
                                   value="${not empty defaultExpiry ? defaultExpiry : ''}">
                            <span class="form-hint">Item will be auto-removed after this date</span>
                        </div>

                        <div class="form-group">
                            <label for="photo">Photo</label>
                            <input type="file" id="photo" name="photo" accept="image/*" class="file-input">
                            <label for="photo" class="file-label">
                                <span class="file-icon">📷</span>
                                <span class="file-text">Choose a photo</span>
                            </label>
                            <div class="photo-preview" id="photoPreview"></div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            📦 Post Item
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
