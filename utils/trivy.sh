#!/bin/bash
set -e

docker run --rm -v .:/app/ aquasec/trivy fs /app/ --scanners vuln
