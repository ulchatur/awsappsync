aws_region          = "us-east-1"
authentication_type = "API_KEY"
dynamodb_table_name = "BidLineData"

tags = {
  SWA_Environment     = "dev2"
  SWA_BusinessService = "WorkforceNavigator"
  SWA_AppSyncApi      = "BidLinesApi"
}
schema_file = "/home/ec2-user/test/terraform/modules/awsappsync/schema.graphql"
visibility  = "GLOBAL"
api_name    = "BidLinesApi"
