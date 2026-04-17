<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - FreeGive</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="error-page-body">
    <main class="error-main">
        <div class="error-container">
            <div class="error-icon">⚠️</div>
            <h1>Something went wrong</h1>
            <p>An unexpected error occurred. Please try again later.</p>
            <% if (exception != null) { %>
                <p class="error-detail"><%= exception.getMessage() %></p>
            <% } %>
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
                <a href="javascript:history.back()" class="btn btn-outline">Go Back</a>
            </div>
        </div>
    </main>
</body>
</html>
