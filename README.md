# Project 1 – EC2 REST Service: Pounds → Kilograms

- CS 454/554 – Cloud Computing (UAH)

A simple RESTful API that converts pounds to kilograms with HTTPS encryption

## Setup Instructions

### Prerequisites
- Node.js and npm installed
- pm2 (`npm install pm2`)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/utsavdarlami/cs554
cd cs554 

# Install dependencies
npm install

# Start the application
npm start
# OR
node server.js
```

## API Endpoint

**API Endpoint**: `GET /convert?lbs={number}`

Convert pounds to kilograms using the standard conversion formula

## Conversion Logic

### Formula
```javascript
kg = lbs * 0.45359237
```

### Precision
- Result rounded to 3 decimal places
- Implementation: `Math.round(lbs * 0.45359237 * 1000) / 1000`

### Validation Rules
1. Parameter must be present
2. Must be a valid number (not NaN)
3. Must be finite (not Infinity/-Infinity)
4. Must be non-negative (>= 0)

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

- Can be found more in [curl_test.sh](curl_test.sh)

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

For detailed architecture information, see [DESIGN.md](DESIGN.md)

## Cleanup Guide

### 1. Stop or Terminate the EC2 Instance

**Option A: Stop Instance (Keeps data, stops compute charges)**

```bash
# Via AWS CLI
aws ec2 stop-instances --instance-ids i-<instance-id>

# Or via AWS Console:
# EC2 → Instances → Select instance → Instance State → Stop
```

**Option B: Terminate Instance (Permanent deletion)**

- Terminating permanently deletes the instance and all data.

```bash
# Via AWS CLI  
aws ec2 terminate-instances --instance-ids i-<instance-id>

# Or via AWS Console:
# EC2 → Instances → Select instance → Instance State → Terminate
```

### 2. Delete Orphaned EBS Volumes

After terminating an instance, EBS volumes may remain and continue charging:

```bash
# List available (unattached) volumes
aws ec2 describe-volumes --filters Name=state,Values=available

# Delete orphaned volume
aws ec2 delete-volume --volume-id vol-<vol-id>

# Or via AWS Console:
# EC2 → Volumes → Select unattached volumes → Actions → Delete volume
```

### 3. Delete Key Pairs

Remove SSH key pairs if no longer needed:

```bash
# List key pairs
aws ec2 describe-key-pairs

# Delete key pair
aws ec2 delete-key-pair --key-name <key-name>

# Or via AWS Console:
# EC2 → Key Pairs → Select → Actions → Delete
```

**Also delete the local .pem file:**

```bash
rm ~/Downloads/<key-name>.pem
```

### Clean-up Verification

Check that resources are cleaned up:

```bash
# Verify no running instances
aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name!=`terminated`]'

# Check for orphaned volumes
aws ec2 describe-volumes --filters Name=state,Values=available
```

