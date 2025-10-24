#!/usr/bin/env bash
# Print non-sensitive inputs for debugging (do NOT print secrets: password, client_cert, client_key)
echo "--- step inputs (non-sensitive) ---"
echo "- domain: $domain"
echo "-----------------------------------"

curl $certicate_url -o ~/git.crt
curl $key_url -o ~/git.key

git config --system http.https://$domain.sslVerify false
git config --system http.https://$domain.sslCert ~/git.crt
git config --system http.https://$domain.sslKey ~/git.key

if [ -n "$authorization_token" ]; then
    git config --global --add http.https://$domain.extraHeader "Authorization: Bearer $authorization_token"
fi

envman add --key GIT_CERTIFICATE_PATH --value ~/git.crt
envman add --key GIT_KEY_PATH --value ~/git.key