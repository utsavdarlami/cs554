# Project 1 – EC2 REST Service: Pounds → Kilograms

- CS 454/554 – Cloud Computing (UAH)

A simple RESTful API that converts pounds to kilograms with HTTPS encryption.

## Setup Instructions

### Prerequisites
- Node.js and npm installed
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/utsavdarlami/cs554
cd weight-converter-api

# Install dependencies
npm install

# Start the application
npm start
# OR
node server.js
```

## API Endpoint

**API Endpoint**: `GET /convert?lbs={number}`

Convert pounds to kilograms using the standard conversion formula.

## Conversion Formula

The API uses the standard conversion formula:
```
kg = lbs × 0.45359237
```

Results are rounded to 3 decimal places for precision.


## Quick Examples

### Successful Conversion
```bash
curl http://localhost:8080/convert?lbs=10
```
**Response:**
```json
{
  "lbs": 10,
  "kg": 4.536,
  "formula": "kg = lbs * 0.45359237"
}
```

### More Examples
```bash
# Convert 25 pounds
curl http://localhost:8080/convert?lbs=25

# Convert 0 pounds (edge case)
curl http://localhost:8080/convert?lbs=0

# Convert fractional pounds
curl http://localhost:8080/convert?lbs=2.5
```

## Error Cases

### Missing Parameter
```bash
curl http://localhost:8080/convert
```
**Response:** `400 Bad Request`
```json
{
  "error": "Query param lbs is required and must be a number"
}
```

### Invalid Number
```bash
curl http://localhost:8080/convert?lbs=abc
```
**Response:** `400 Bad Request`
```json
{
  "error": "Query param lbs is required and must be a number"
}
```

### Negative Number
```bash
curl http://localhost:8080/convert?lbs=-5
```
**Response:** `422 Unprocessable Entity`
```json
{
  "error": "lbs must be a non-negative, finite number"
}
```

## Testing

### Test the API
```bash
# Test successful conversion
curl http://localhost:8080/convert?lbs=10

# Test error cases
curl http://localhost:8080/convert
curl http://localhost:8080/convert?lbs=abc
curl http://localhost:8080/convert?lbs=-5
```

## Architecture

- **Backend**: Express.js API (Node.js)
- **Logging**: Morgan middleware for HTTP request logging
- **Validation**: Input validation and error handling
- **Response Format**: JSON with conversion results

For detailed architecture information, see [DESIGN.md](DESIGN.md).
