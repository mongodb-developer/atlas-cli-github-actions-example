#!/usr/bin/env bash

PROJECT_NAME=IntegrationTestsProject
CLUSTER_NAME=Tests
USERNAME=tests_user
PASSWORD=$(openssl rand -hex 12)

echo "Creating the test project..."
export MONGODB_ATLAS_PROJECT_ID=$(atlas projects create \
    $PROJECT_NAME \
    -o json-path="$.id")

echo "Creating a free M0 cluster..."
SETUP_OUTPUT=$(atlas setup \
    --force \
    --tier M0 \
    --clusterName $CLUSTER_NAME \
    --skipSampleData \
    --provider GCP \
    --region WESTERN_EUROPE \
    --username $USERNAME \
    --password $PASSWORD \
    --skipMongosh \
    --accessListIp "0.0.0.0/0")

# Wait until the cluster's available
atlas cluster watch $CLUSTER_NAME

# Extract the database host from the output of the setup command
DATABASE_HOST=$(echo $SETUP_OUTPUT | sed -n "s/.*mongodb+srv:\/\/\(.*\)/\1/p")
CONNECTION_STRING="mongodb+srv://${USERNAME}:${PASSWORD}@${DATABASE_HOST}"
# Store the connection string in an environment file that will be loaded by the server
rm .env && echo "ATLAS_URI=$CONNECTION_STRING" > .env

# Execute the tests
npm run ci

echo "Deleting the cluster..."
atlas cluster delete $CLUSTER_NAME --force

echo "Waiting until the cluster is in "goal state" (deleted)..."
atlas cluster watch $CLUSTER_NAME

echo "Deleting the project..."
atlas project delete $MONGODB_ATLAS_PROJECT_ID --force
