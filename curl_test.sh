#!/bin/bash

BASE_URL="http://127.0.0.1:8080"

echo "Testing API endpoints..."

echo -e "\n---\n"
echo -e "calling $BASE_URL/convert?lbs=0"
curl -s "$BASE_URL/convert?lbs=0"
echo -e "\n---\n"

echo -e "calling $BASE_URL/convert?lbs=150"
curl -s "$BASE_URL/convert?lbs=150"
echo -e "\n---\n"

echo -e "calling $BASE_URL/convert?lbs=0.1"
curl -s "$BASE_URL/convert?lbs=0.1"
echo -e "\n---\n"

echo -e "calling $BASE_URL/convert"
curl -s "$BASE_URL/convert"
echo -e "\n---\n"

echo -e "calling $BASE_URL/convert?lbs=-5"
curl -s "$BASE_URL/convert?lbs=-5"
echo -e "\n---\n"

echo -e "calling $BASE_URL/convert?lbs=NaN"
curl -s "$BASE_URL/convert?lbs=NaN"
echo -e "\n---\n"
