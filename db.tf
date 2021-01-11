resource "aws_dynamodb_table" "default" {
    name = "${var.app_name}-data"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "WaffleId"

    attribute {
        name = "WaffleId"
        type = "S"
    }
}