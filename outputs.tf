output "graphql_api_id" {
  value = module.aws_appsync.appsync_graphql_api_id
}

output "graphql_api_url" {
  value = module.aws_appsync.appsync_graphql_api_uris["GRAPHQL"]
}

output "api_keys" {
  value     = module.aws_appsync.appsync_api_key_key
  sensitive = true
}

