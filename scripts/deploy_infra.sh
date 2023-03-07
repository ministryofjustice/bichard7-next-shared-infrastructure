if [[ "$ENVIRONMENT" == "sandbox" ]]; then
  make shared-account-sandbox-infra
elif [[ "$ENVIRONMENT" == "pathtolive" ]]; then
  make shared-account-pathtolive-infra
else
  echo "Unknown environment"
  exit 1
fi
