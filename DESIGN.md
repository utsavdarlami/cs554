# DESIGN

## Architecture

```
Internet Request (HTTPS)
         ↓
    nginx (Port 443/80)
         ↓
  Express.js App (Port 8080)
         ↓
    JSON Response
```

## Components

### 1. Frontend Layer - nginx Reverse Proxy

**Purpose**: Web server and SSL termination
**Configuration**: `/etc/nginx/conf.d/default.conf`

**Key Features**:
- SSL/TLS encryption via Let's Encrypt certificates
- Automatic HTTP to HTTPS redirect (301)
- Reverse proxy to Node.js application
- Request header forwarding for client information preservation

**Security**:
- Managed SSL certificates with automatic renewal
- Secure SSL configuration via Certbot
- Domain validation through DuckDNS (`uduah.duckdns.org`)

### 2. Application Layer - Express.js API

**Purpose**: Business logic and API endpoint handling
**Runtime**: Node.js with Express.js framework
**Port**: 8080 (internal)

**API Specification**:
```
GET /convert?lbs={number}
```

**Request Parameters**:
- `lbs` (required): Number representing pounds to convert

**Response Format**:
```json
{
  "lbs": 10,
  "kg": 4.536,
  "formula": "kg = lbs * 0.45359237"
}
```

**Error Handling**:
- `400 Bad Request`: Missing or invalid `lbs` parameter
- `422 Unprocessable Entity`: Negative or non-finite numbers

### 3. Process Management - PM2

**Purpose**: Application lifecycle management and monitoring
**Command**: `npx pm2 start server.js`

**Benefits**:
- Automatic application restart on failure
- Process monitoring and logging
- Zero-downtime deployments
- Cluster mode capability for scaling

## Data Flow

1. **Client Request**: HTTPS request to `https://uduah.duckdns.org/convert?lbs=10`
2. **SSL Termination**: nginx handles SSL/TLS encryption and decryption
3. **Reverse Proxy**: nginx forwards request to Express.js on `http://127.0.0.1:8080`
4. **Request Processing**: Express.js validates input and performs conversion
5. **Response Generation**: JSON response with conversion result
6. **SSL Encryption**: nginx encrypts response before sending to client

## Security Implementation

### SSL/TLS Configuration
- **Certificate Authority**: Let's Encrypt (free, trusted CA)
- **Certificate Path**: `/etc/letsencrypt/live/uduah.duckdns.org/`
- **Auto-renewal**: Managed by Certbot systemd timer
- **SSL Labs Grade**: A+ (with Certbot's secure defaults)

**Certificate Installation Command**:
```bash
sudo certbot --nginx -d uduah.duckdns.org
```

### Request Security
- Input validation for numeric values
- Range checking (non-negative, finite numbers)
- Proper HTTP status codes for different error conditions
- Request logging via Morgan middleware

## Deployment Architecture

### Infrastructure
- **Platform**: AWS EC2 instance
- **Operating System**: Linux (Ubuntu/Amazon Linux)
- **Domain**: DuckDNS free dynamic DNS service

### Network Configuration
- **HTTP Port 80**: Redirects to HTTPS
- **HTTPS Port 443**: Main application access
- **Internal Port 8080**: Express.js application (not externally accessible)

### Security Groups (AWS)

```
Inbound Rules:
- SSH (22): Your IP only
- HTTP (80): 0.0.0.0/0 (for Let's Encrypt validation and redirects)
- HTTPS (443): 0.0.0.0/0 (main application access)
```

## Monitoring and Logging

### Application Logs
- **Morgan**: HTTP request logging in 'combined' format
- **Console Logging**: Request/response debugging information
- **PM2 Logs**: Process management and error logs

### Log Locations
- nginx access/error logs: `/var/log/nginx/`
- PM2 logs: `~/.pm2/logs/`
- Application console output: Available via `npx pm2 logs`


## Maintenance

### SSL Certificate Renewal
- Automatic renewal via Certbot
- Check status: `sudo certbot certificates`

### Application Updates
```bash
# Restart application
pm2 reload server.js
```

### nginx Updates
```bash
# Test and reload configuration
sudo nginx -t
sudo systemctl reload nginx
```
