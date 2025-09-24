#!/bin/bash

# Simple helper to create a release keystore for Android
# Usage: ./scripts/generate_keystore.sh
# You will be prompted for keystore details.

KEYSTORE_PATH="android/app/my-release-key.jks"
KEY_ALIAS="ai_psychologist_alias"

mkdir -p android/app

echo "Generating Android keystore at: $KEYSTORE_PATH"
keytool -genkey -v -keystore "$KEYSTORE_PATH" -alias "$KEY_ALIAS" -keyalg RSA -keysize 2048 -validity 10000

if [ $? -eq 0 ]; then
  echo "Keystore generated successfully."
  echo "Remember to keep the keystore safe and the passwords recorded."
  echo "Next steps:"
  echo "1) Upload the keystore file ($KEYSTORE_PATH) to Codemagic (Code signing section)."
  echo "2) In Codemagic, set KEYS properties: Keystore password, Key alias, Key password."
  echo "3) Start a Release build in Codemagic."
else
  echo "Keystore generation failed. Make sure keytool is installed (part of JDK)."
fi
