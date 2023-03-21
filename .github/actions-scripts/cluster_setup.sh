#!/usr/bin/env bash
set -e

brew install mongodb-atlas

echo "Creating the test project..."
export MONGODB_ATLAS_PROJECT_ID=$(atlas projects create \
    $PROJECT_NAME \
    --output json-path="$.id")

echo "atlas_project_id=${MONGODB_ATLAS_PROJECT_ID}" >> "$GITHUB_OUTPUT"

echo "Creating the cluster..."
atlas cluster create $CLUSTER_NAME \
    --provider $PROVIDER \
    --region $REGION \
    --tier $TIER

# Create an IP access list entry allowing access from anywhere
atlas accessList create 0.0.0.0/0

# Create a database user for the project
echo "${PASSWORD}" | atlas dbuser create readWriteAnyDatabase --username $USERNAME

# Wait until the cluster's available
atlas cluster watch $CLUSTER_NAME

STANDARD_SRV=$(atlas cluster connectionString describe $CLUSTER_NAME --output json-path="$.standardSrv")
DATABASE_HOST=$(echo $STANDARD_SRV | sed -n "s/.*mongodb+srv:\/\/\(.*\)/\1/p")
CONNECTION_STRING="mongodb+srv://${USERNAME}:${PASSWORD}@${DATABASE_HOST}"

echo "ATLAS_URI=$CONNECTION_STRING" > .env
