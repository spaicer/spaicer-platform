#!/usr/bin/env bash
set -euo pipefail

echo-ip() {
  echo The service can be addressed at: $1
}

# Call the requested function and pass the arguments as-is
"$@"