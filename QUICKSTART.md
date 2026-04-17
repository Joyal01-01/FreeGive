# FreeGive - Quick Start Guide

Welcome to FreeGive, a community item sharing platform!

## Prerequisites

- **Docker** and **Docker Compose** installed
- Port **8080** (Tomcat) and **3307** (MySQL) available

## Starting the Application

### 1. Navigate to the project directory

```bash
cd FreeGive
```

### 2. Start the application

```bash
docker-compose up --build
```

### 3. Wait for startup

The first build takes 2-3 minutes. You'll see:

- MySQL container starting and becoming "healthy"
- Tomcat container building and starting
- Initialization complete when `tomcat_1` shows as "Up"

### 4. Access the application

Open your browser and go to: **http://localhost:8080**

## Core Features

### Homepage

- View featured items
- Navigate to Browse, About, or Contact
- Links to Register or Login

### Registration

1. Click **Register** on homepage
2. Fill in your details:
   - Username (3-50 characters)
   - Email
   - Password (min 6 characters)
   - Phone (10 digits)
   - Zip code
   - Role: **Donor** (sharing items) or **Receiver** (seeking items)
3. Submit - account pending admin approval

### Login

1. Click **Login** on homepage
2. Enter username and password
3. Access personalized dashboard

### Dashboard (After Login)

- **Donor Dashboard**: Post items you want to give away
- **Receiver Dashboard**: Browse items and create wishlists
- **Browse Items**: Search and filter available items
- **My Wishlist**: View items you've saved

### Post an Item (Donors)

1. Navigate to "Post Item"
2. Enter:
   - Item name and description
   - Category
   - Condition
   - Photos (if available)
3. Submit for listing

### Search Items (Receivers)

1. Use the **Browse** section
2. Filter by:
   - Category
   - Condition
   - Location (zip code)
3. Add items to wishlist or claim interest

## Admin Features

### Admin Dashboard

Access via `/admin` (after login as admin-approved account)

- Approve/reject pending registrations
- Manage items listings
- View platform statistics

## Stopping the Application

```bash
docker-compose down
```

## Troubleshooting

### "Connection refused" error

- Ensure MySQL container is healthy: `docker-compose ps`
- Wait a few seconds and try again
- Restart: `docker-compose down && docker-compose up --build`

### Port already in use

- **Port 8080**: `lsof -i :8080` and kill the process
- **Port 3307**: `lsof -i :3307` and kill the process

### Database issues

- Check MySQL logs: `docker logs freegive_mysql`
- Restart containers: `docker-compose down && docker-compose up`

## Project Structure

```
FreeGive/
├── src/main/
│   ├── java/com/freegive/
│   │   ├── controller/     # Servlets handling HTTP requests
│   │   ├── dao/            # Database access objects
│   │   ├── model/          # User, Item, Claim classes
│   │   ├── filter/         # Authentication & session filters
│   │   └── util/           # Database connection, validation, security
│   └── webapp/
│       ├── WEB-INF/views/  # JSP pages
│       ├── css/            # Stylesheets
│       └── js/             # JavaScript functionality
├── database/schema.sql     # Database schema
├── pom.xml                 # Maven dependencies
└── Dockerfile              # Container configuration
```

## Key Technologies

- **Backend**: Java, Servlets, JSP
- **Database**: MySQL 8.0
- **Server**: Apache Tomcat 9.0
- **Build**: Maven
- **Containerization**: Docker & Docker Compose
- **Frontend**: HTML5, CSS3, JavaScript

## Sample Test Flow

1. **Open homepage**: http://localhost:8080
2. **Register a donor account**: username `donor_user`, role: Donor
3. **Register a receiver account**: username `receiver_user`, role: Receiver
4. **Login as donor**: Post an item
5. **Login as receiver**: Browse and search items
6. **Admin approval**: Items and users pending approval

## Development

### Rebuild after code changes

```bash
docker-compose up --build
```

### View logs

```bash
docker logs freegive_tomcat  # Tomcat logs
docker logs freegive_mysql   # MySQL logs
```

### Access database directly

```bash
docker exec -it freegive_mysql mysql -u root -proot freegive
```

## Need Help?

- Check Tomcat logs: `docker logs freegive_tomcat`
- Verify containers running: `docker-compose ps`
- Ensure ports are available: `lsof -i :8080`

---

**Happy sharing! 🎁**
