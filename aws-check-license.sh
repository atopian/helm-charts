#!/bin/bash

TOKEN=$(aws license-manager checkout-license --product-sku 23a57c00-38e0-4380-ac2c-e695950e270e --checkout-type PROVISIONAL --key-fingerprint aws:967222283187:test-seller:issuer-fingerprint --client-token $(uuid) --entitlements Name=BasicTier,Unit=None,Value=1 | jq '.LicenseConsumptionToken')

if [ -z "$2" ]; then
  export DO_RESTART=1
else 
  export DO_RESTART=0
fi



if [ -z "$TOKEN" ]; then 
  if [ -f /var/log/sysgoatent ]; then
    echo "License Not Available, Reverting to Free"
    rm /var/log/sysgoatent
    [ $DO_RESTART -gt 0 ] && /opt/cribl/bin/cribl restart
  else
    echo "License Not Available, Running Free"
  fi
else
  if [ -f /var/log/sysgoatent ]; then
    echo "Continuing to Run"
  else 
    echo "Install License"
    echo > /var/log/sysgoatent
    ls -al /var/log
    [ $DO_RESTART -gt 0 ] && /opt/cribl/bin/cribl restart
  fi
fi 
