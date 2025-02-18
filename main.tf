module "aws_appsync" {
  source  = "terraform-aws-modules/appsync/aws"
  version = "3.0.0"

  name                = var.api_name
  schema              = file(var.schema_file)
  authentication_type = var.authentication_type
  visibility          = var.visibility
  tags                = var.tags
  domain_name         = data.aws_ssm_parameter.custom_domain_name.value
  certificate_arn     = data.aws_ssm_parameter.acm_arn.value

  # DynamoDB Datasource
  datasources = {
    BidLineData = {
      type             = "AMAZON_DYNAMODB"
      table_name       = var.dynamodb_table_name
      service_role_arn = aws_iam_role.appsync_role.arn
      region           = var.aws_region
    }
  }

  resolvers = {
    getBidLine = {
      type              = "Query"
      field             = "getBidLine"
      data_source       = "BidLineData"
      request_template  = file("${path.module}/modules/awsappsync/resolvers/getBidLine-request.vtl")
      response_template = file("${path.module}/modules/awsappsync/resolvers/response.vtl")
    }

    createBidLine = {
      type              = "Mutation"
      field             = "createBidLine"
      data_source       = "BidLineData"
      request_template  = file("${path.module}/modules/awsappsync/resolvers/createBidLine-request.vtl")
      response_template = file("${path.module}/modules/awsappsync/resolvers/response.vtl")
    }

    updateBidLine = {
      type              = "Mutation"
      field             = "updateBidLine"
      data_source       = "BidLineData"
      request_template  = file("${path.module}/modules/awsappsync/resolvers/updateBidLine-request.vtl")
      response_template = file("${path.module}/modules/awsappsync/resolvers/response.vtl")
    }

    deleteBidLine = {
      type              = "Mutation"
      field             = "deleteBidLine"
      data_source       = "BidLineData"
      request_template  = file("${path.module}/modules/awsappsync/resolvers/deleteBidLine-request.vtl")
      response_template = file("${path.module}/modules/awsappsync/resolvers/response.vtl")
    }
  }
}

data "aws_ssm_parameter" "acm_arn" {
  name = "/ccplat/certificate/wfmapi-techopsworkforce-dev2-swalife-com"
}

data "aws_ssm_parameter" "custom_domain_name" {
  name = "/ccplat/dev2/cloud-common-public-hosted-zone-module/pub-r53-public-HZ-us-east-1/oPublicHostedZoneTechopsworkforcedev2swalifecomName"
}

resource "aws_iam_role" "appsync_role" {
  name = "AppSyncDynamoDBRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "appsync.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "appsync_role_policy" {
  role       = aws_iam_role.appsync_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSAppSyncAdministrator"
}

