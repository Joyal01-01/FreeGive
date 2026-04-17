# FreeGive - Running the Application

## Prerequisites

- Docker & Docker Compose
- Git (optional)

## Quick Start

### Option 1: Using Docker Compose (Recommended)

This will automatically set up MySQL database and Tomcat server.

```bash
cd /Users/gauravsoni/Desktop/FreeGive\ Antigravity/FreeGive
docker-compose up --build
```

The application will be available at:

- **Web Application**: http://localhost:8080
- **MySQL Database**: localhost:3306

### Option 2: Manual Setup (Requires Maven & MySQL)

If you have Maven and MySQL installed:

```bash
# 1. Create the database
mysql -u root -p < database/schema.sql

# 2. Update DBConnection.java if needed
# Edit src/main/java/com/freegive/util/DBConnection.java
# Set your MySQL credentials

# 3. Build the project
mvn clean package

# 4. Deploy to Tomcat
cp target/FreeGive.war /path/to/tomcat/webapps/

# 5. Start Tomcat
/path/to/tomcat/bin/catalina.sh start
```

## Accessing the Application

### Default URL

```
http://localhost:8080
```

### Database Access

```
Host: localhost (or mysql if using Docker)
Port: 3306
Username: root
Password: root
Database: freegive
```

### Default Test Credentials

Create an account through the registration page or use:

- **Role**: donor
- **Username**: testuser
- **Email**: test@example.com
- **Phone**: 5551234567
- **Zipcode**: 12345

## Features to Test

1. **User Registration** - Register as Donor or Receiver
2. **User Login** - Login with created account
3. **Post Items** - Donors can post items to share
4. **Search Items** - Search and browse available items
5. **Claim Items** - Receivers can claim items
6. **Wishlist** - Receivers can add items to wishlist
7. **Admin Dashboard** - Approve user accounts

## Stopping the Application

### Docker Compose

```bash
docker-compose down
```

### Manual Tomcat

```bash
/path/to/tomcat/bin/catalina.sh stop
```

## Troubleshooting

### Container fails to start

```bash
# View logs
docker-compose logs -f

# Rebuild without cache
docker-compose up --build --no-cache
```

### Database connection error

- Ensure MySQL container is running: `docker-compose ps`
- Check database initialization: `docker-compose logs mysql`
- Verify credentials in DBConnection.java match docker-compose.yml

### Port 8080 already in use

Change the port in docker-compose.yml:

```yaml
ports:
  - "8081:8080" # Maps 8081 to container's 8080
```

Then access at: http://localhost:8081

## Project Structure

```
FreeGive/
├── src/main/
│   ├── java/com/freegive/         # Java source code
│   │   ├── controller/             # Servlets
│   │   ├── dao/                    # Data Access Objects
│   │   ├── model/                  # Entity models
│   │   ├── filter/                 # Authentication & Session filters
│   │   └── util/                   # Utilities
│   └── webapp/                     # Web resources
│       ├── css/style.css           # Stylesheet
│       ├── js/app.js               # Client-side JavaScript
│       ├── index.jsp               # Homepage
│       └── WEB-INF/
│           ├── web.xml            # Deployment descriptor
│           └── views/              # JSP templates
├── database/schema.sql             # Database schema
├── pom.xml                         # Maven configuration
├── Dockerfile                      # Docker image definition
├── docker-compose.yml              # Multi-container config
└── RUN.md                          # This file
```

## Environment Variables

### Docker Compose

The following can be customized in `docker-compose.yml`:

**MySQL:**

- `MYSQL_ROOT_PASSWORD`: root (database root password)
- `MYSQL_DATABASE`: freegive (default database)
- `MYSQL_USER`: freegive_user
- `MYSQL_PASSWORD`: freegive_pass

**Tomcat:**

- Port mapping: `"8080:8080"` (change as needed)

## Building Without Docker

If you prefer to build without Docker:

```bash
# Install Maven if not already installed
brew install maven

# Navigate to project directory
cd /Users/gauravsoni/Desktop/FreeGive\ Antigravity/FreeGive

# Build the project
mvn clean package

# The WAR file will be at: target/FreeGive.war
```

## Additional Resources

- **Maven Build**: `mvn clean package`
- **Run Tests**: `mvn test`
- **Check Code Style**: `mvn checkstyle:check`
- **Generate JavaDoc**: `mvn javadoc:javadoc`

---

**Happy Coding! 🎁**
For issues or questions, refer to the troubleshooting section above.
