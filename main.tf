resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "A user ID-based request.",
        "properties" = {
            "USER_ID" = {
                "description" = "The user ID.",
                "type" = "string"
            }
        },
        "required" = [
            "USER_ID"
        ],
        "title" = "UserIdRequest",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "Returns a user\u2019s out of office status.",
        "properties" = {
            "active" = {
                "description" = "The user\u2019s out of office status as a true/false flag.",
                "title" = "active",
                "type" = "boolean"
            }
        },
        "title" = "Get User Routing Status Response",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/users/$${input.USER_ID}/outofoffice"
        headers = {
			UserAgent = "PureCloudIntegrations/1.0"
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\"active\": $${active}\n}"
        translation_map = { 
			active = "$.active"
		}
    }
}