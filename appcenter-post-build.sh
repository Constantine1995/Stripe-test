if [ "$AGENT_JOBSTATUS" == "Succeeded" ]; then
HOCKEYAPP_API_TOKEN={API_Token}
HOCKEYAPP_APP_ID={APP_ID}

# Example: Upload master branch app binary to HockeyApp using the API
if [ "$APPCENTER_BRANCH" == "master" ];
then
curl \
-F "status=2" \
-F "ipa=@$APPCENTER_OUTPUT_DIRECTORY/Stripe-test.ipa" \
-H "X-HockeyAppToken: $HOCKEYAPP_API_TOKEN" \
https://rink.hockeyapp.net/api/2/apps/$HOCKEYAPP_APP_ID/app_versions/upload
else
echo "Current branch is $APPCENTER_BRANCH"
fi
fi
