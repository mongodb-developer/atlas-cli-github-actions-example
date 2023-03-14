#!/usr/bin/env bash

brew install mongodb-atlas

atlas cluster delete $CLUSTER_NAME --force --projectId $MONGODB_ATLAS_PROJECT_ID
atlas cluster watch $CLUSTER_NAME

atlas project delete $MONGODB_ATLAS_PROJECT_ID --force
