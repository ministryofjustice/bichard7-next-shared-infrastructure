if [[ "$ENVIRONMENT" == "sandbox" ]]; then
  ./scripts/deploy_sandbox_infra.sh
elif [[ "$ENVIRONMENT" == "pathtolive" ]]; then
  ./scripts/deploy_pathtolive_infra.sh
else
  echo "Unknown environment"
  exit 1
fi
