terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # bootstrap/ で作成した S3 バケット名を bucket に設定する
  # use_lockfile は Terraform v1.10+ の S3 native locking（DynamoDB 不要）
  backend "s3" {
    bucket       = "enechange-coding-challenge-tfstate"
    key          = "terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source  = "./modules/network"
  project = var.project
  env     = var.env
}

module "app" {
  source               = "./modules/app"
  project              = var.project
  env                  = var.env
  region               = var.region
  vpc_id               = module.network.vpc_id
  public_subnet_ids    = module.network.public_subnet_ids
  sg_alb_id            = module.network.sg_alb_id
  sg_ecs_id            = module.network.sg_ecs_id
  rails_image          = var.rails_image
  cors_allowed_origins = var.cors_allowed_origins
  origin_verify_secret = var.origin_verify_secret
  database_url         = var.database_url
  secret_key_base      = var.secret_key_base
  ecs_desired_count    = var.ecs_desired_count
}

module "db" {
  source             = "./modules/db"
  project            = var.project
  env                = var.env
  private_subnet_ids = module.network.private_subnet_ids
  sg_rds_id          = module.network.sg_rds_id
}

module "cdn" {
  source               = "./modules/cdn"
  project              = var.project
  env                  = var.env
  alb_dns_name         = module.app.alb_dns_name
  origin_verify_secret = var.origin_verify_secret
}
