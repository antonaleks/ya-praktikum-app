echo "Waiting for Vault..."
while [ "$(curl -XGET --insecure --silent -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/health | jq '.initialized')" != "true" ]
do
    echo 'Vault is Initializing...'
    sleep 2
done

echo "Vault Started."