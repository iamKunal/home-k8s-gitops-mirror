#!/usr/bin/env bash

OLD_HOOK_ID=$(gh api /repos/${WEBHOOK_REPO}/hooks | jq '.[] | select(.config.url == "https://webhook-forwarder.github.com/hook") | .id' -e)

echo "OLD_HOOK_ID=${OLD_HOOK_ID}"

if [ "$OLD_HOOK_ID" != "" ]; then
  echo "DELETING OLD HOOK"
  gh api --method DELETE "/repos/${WEBHOOK_REPO}/hooks/${OLD_HOOK_ID}"
fi


echo "Setting up Github Webhook forwarder"

gh webhook forward --repo="${WEBHOOK_REPO}" --secret="${WEBHOOK_SECRET}" --events="${WEBHOOK_EVENTS}" --url="${WEBHOOK_FORWARDED_URL}"