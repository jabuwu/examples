set -e
TERRAFORM_OUTPUT=$(terraform output -json)
BUCKET=$(echo $TERRAFORM_OUTPUT | jq -r '.bucket.value')
DISTRIBUTION_ID=$(echo $TERRAFORM_OUTPUT | jq -r '.distribution_id.value')
aws s3 rm s3://$BUCKET --recursive
aws s3 cp website s3://$BUCKET/ --recursive
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"