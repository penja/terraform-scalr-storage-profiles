#!/bin/bash

# Get the hostname from the first argument
HOSTNAME=$1

# Debug output
echo "Checking for OIDC provider with URL: ${HOSTNAME}" >&2

# List all OIDC providers and check if our URL exists
PROVIDERS=$(aws iam list-open-id-connect-providers)
echo "Raw providers output: ${PROVIDERS}" >&2

PROVIDER=$(echo "$PROVIDERS" | jq -r ".OpenIDConnectProviderList[] | select(.Arn | contains(\"${HOSTNAME}\")) | .Arn")

if [ -n "$PROVIDER" ]; then
  echo "Found provider with ARN: ${PROVIDER}" >&2
  echo "{\"exists\": \"true\", \"arn\": \"${PROVIDER}\"}"
else
  echo "No provider found" >&2
  echo "{\"exists\": \"false\"}"
fi 