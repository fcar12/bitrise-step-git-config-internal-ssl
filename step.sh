#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Print non-sensitive inputs for debugging (do NOT print secrets: password, client_cert, client_key)
echo "--- step inputs (non-sensitive) ---"
echo "- domain: $domain"
echo "- authorization_token: $authorization_token"
echo "-----------------------------------"

TMP_DIR="./git_crt_key"
CRT_PATH="$TMP_DIR/git.crt"
KEY_PATH="$TMP_DIR/git.key"

mkdir -p "$TMP_DIR"
curl $certicate_url -o "$CRT_PATH"
curl $key_url -o "$KEY_PATH"

git config --system http.https://$domain.sslVerify false
git config --system http.https://$domain.sslCert ~/git.crt
git config --system http.https://$domain.sslKey ~/git.key

if [ -n "$authorization_token" ]; then
    echo "Setting token..."
    git config --global --add http.https://$domain.extraHeader "Authorization: Bearer $authorization_token"
fi

envman add --key GIT_CERTIFICATE_PATH --value $CRT_PATH
envman add --key GIT_KEY_PATH --value $KEY_PATH