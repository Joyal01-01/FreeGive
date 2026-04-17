<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - FreeGive</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar navbar-admin">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo">
                <span class="logo-icon">🎁</span>
                <span class="logo-text">Free<span class="logo-accent">Give</span></span>
                <span class="badge badge-admin">Admin</span>
            </a>
            <input type="checkbox" id="nav-toggle" class="nav-toggle-checkbox">
            <label for="nav-toggle" class="nav-toggle-label">
                <span></span><span></span><span></span>
            </label>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/admin?tab=users" class="${activeTab == 'users' ? 'active' : ''}">Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?tab=items" class="${activeTab == 'items' ? 'active' : ''}">Items</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?tab=reports" class="${activeTab == 'reports' ? 'active' : ''}">Reports</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-nav-outline">Logout</a></li>
            </ul>
        </div>
    </nav>

    <main class="dashboard-main">
        <div class="container">
            <div class="dashboard-header">
                <div class="dashboard-welcome">
                    <h1>Admin Panel</h1>
                    <p>Manage users, items, and view reports</p>
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

            <!-- Tab Navigation -->
            <div class="admin-tabs">
                <a href="${pageContext.request.contextPath}/admin?tab=users" class="tab ${activeTab == 'users' || activeTab == null ? 'tab-active' : ''}">👥 Users</a>
                <a href="${pageContext.request.contextPath}/admin?tab=items" class="tab ${activeTab == 'items' ? 'tab-active' : ''}">📦 Items</a>
                <a href="${pageContext.request.contextPath}/admin?tab=reports" class="tab ${activeTab == 'reports' ? 'tab-active' : ''}">📊 Reports</a>
            </div>

            <!-- USERS TAB -->
            <c:if test="${activeTab == 'users' || activeTab == null}">
                <div class="card">
                    <div class="card-header">
                        <h2>User Management</h2>
                        <span class="badge badge-info">${users.size()} users</span>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table" id="usersTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Zip</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td>${u.id}</td>
                                        <td><strong>${u.username}</strong></td>
                                        <td>${u.email}</td>
                                        <td>${u.phone}</td>
                                        <td>${u.zipcode}</td>
                                        <td><span class="badge badge-role-${u.role}">${u.role}</span></td>
                                        <td>
                                            <span class="badge ${u.approved ? 'badge-success' : 'badge-warning'}">
                                                ${u.approved ? 'Approved' : 'Pending'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <c:if test="${u.role != 'admin'}">
                                                    <c:if test="${!u.approved}">
                                                        <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="userId" value="${u.id}">
                                                            <input type="hidden" name="tab" value="users">
                                                            <button type="submit" class="btn btn-sm btn-success">✓ Approve</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${u.approved}">
                                                        <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline">
                                                            <input type="hidden" name="action" value="block">
                                                            <input type="hidden" name="userId" value="${u.id}">
                                                            <input type="hidden" name="tab" value="users">
                                                            <button type="submit" class="btn btn-sm btn-warning">⊘ Block</button>
                                                        </form>
                                                    </c:if>
                                                    <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline" class="role-change-form">
                                                        <input type="hidden" name="action" value="changeRole">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <input type="hidden" name="tab" value="users">
                                                        <select name="newRole" class="select-sm" onchange="this.form.submit()">
                                                            <option value="">Role...</option>
                                                            <option value="donor" ${u.role == 'donor' ? 'selected' : ''}>Donor</option>
                                                            <option value="receiver" ${u.role == 'receiver' ? 'selected' : ''}>Receiver</option>
                                                        </select>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline"
                                                          onsubmit="return confirm('Delete user ${u.username}? This will also delete all their items.')">
                                                        <input type="hidden" name="action" value="deleteUser">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <input type="hidden" name="tab" value="users">
                                                        <button type="submit" class="btn btn-sm btn-danger">🗑️</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- ITEMS TAB -->
            <c:if test="${activeTab == 'items'}">
                <div class="card">
                    <div class="card-header">
                        <h2>All Items</h2>
                        <span class="badge badge-info">${items.size()} items</span>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table" id="adminItemsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Donor</th>
                                    <th>Tags</th>
                                    <th>Zip</th>
                                    <th>Status</th>
                                    <th>Posted</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${items}">
                                    <tr>
                                        <td>${item.id}</td>
                                        <td><strong>${item.name}</strong></td>
                                        <td>${item.donorUsername}</td>
                                        <td>
                                            <div class="tag-list">
                                                <c:forEach var="tag" items="${item.tagsArray}">
                                                    <span class="tag">${tag}</span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                        <td>${item.zipcode}</td>
                                        <td>
                                            <span class="badge ${item.status == 'available' ? 'badge-success' : 'badge-warning'}">
                                                ${item.status}
                                            </span>
                                        </td>
                                        <td><fmt:formatDate value="${item.postedAt}" pattern="MMM dd"/></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline"
                                                  onsubmit="return confirm('Delete this item?')">
                                                <input type="hidden" name="action" value="deleteItem">
                                                <input type="hidden" name="itemId" value="${item.id}">
                                                <input type="hidden" name="tab" value="items">
                                                <button type="submit" class="btn btn-sm btn-danger">🗑️ Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- REPORTS TAB -->
            <c:if test="${activeTab == 'reports'}">
                <div class="reports-grid">
                    <!-- Stats Cards -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-card-icon">👥</div>
                            <div class="stat-card-value">${totalUsers}</div>
                            <div class="stat-card-label">Total Users</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-card-icon">⏳</div>
                            <div class="stat-card-value">${pendingCount}</div>
                            <div class="stat-card-label">Pending</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-card-icon">🎁</div>
                            <div class="stat-card-value">${donorCount}</div>
                            <div class="stat-card-label">Donors</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-card-icon">🔍</div>
                            <div class="stat-card-value">${receiverCount}</div>
                            <div class="stat-card-label">Receivers</div>
                        </div>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-card-icon">📦</div>
                            <div class="stat-card-value">${totalItems}</div>
                            <div class="stat-card-label">Total Items</div>
                        </div>
                        <div class="stat-card stat-card-success">
                            <div class="stat-card-icon">✅</div>
                            <div class="stat-card-value">${availableItems}</div>
                            <div class="stat-card-label">Available</div>
                        </div>
                        <div class="stat-card stat-card-warning">
                            <div class="stat-card-icon">🤝</div>
                            <div class="stat-card-value">${claimedItems}</div>
                            <div class="stat-card-label">Claimed</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-card-icon">📋</div>
                            <div class="stat-card-value">${totalClaims}</div>
                            <div class="stat-card-label">Total Claims</div>
                        </div>
                    </div>

                    <!-- Top Categories -->
                    <div class="card">
                        <div class="card-header">
                            <h2>Top Categories by Claims</h2>
                        </div>
                        <c:choose>
                            <c:when test="${not empty topCategories}">
                                <div class="table-responsive">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Tags</th>
                                                <th>Claims Count</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cat" items="${topCategories}" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>
                                                        <div class="tag-list">
                                                            <c:forEach var="tag" items="${cat.tags.split(',')}">
                                                                <span class="tag">${tag.trim()}</span>
                                                            </c:forEach>
                                                        </div>
                                                    </td>
                                                    <td><strong>${cat.claimCount}</strong></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>No claims data available yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
