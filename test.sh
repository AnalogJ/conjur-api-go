#!/bin/bash -ex

function finish {
  docker-compose down -v
}
trap finish EXIT

echo "Running tests"

# Clean then generate output folder locally
rm -rf output
mkdir -p output

source ./_setup.sh

# Execute tests
CONJUR_AUTHN_API_KEY="$api_key" \
  CONJUR_V4_AUTHN_API_KEY="$api_key_v4" \
  CONJUR_V4_SSL_CERTIFICATE="$ssl_cert_v4" \
  docker-compose run test \
    bash -o pipefail \
      -c 'go test -v $(go list ./... | grep -v /vendor/) | tee output/junit.output && cat output/junit.output | go-junit-report > output/junit.xml' || echo "TESTS FAILED"

