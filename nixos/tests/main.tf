variable "count" {
  default = 1
}

variable "vpc_id" {
  type = "string"
}

variable "display_name" {
  type = "string"
}

variable "security_groups" {
  type = "list"
}

variable "instance_type" {
  default = "t2.small"
  type    = "string"
}

variable "spot_price" {
  default = "1.00"
  type    = "string"
}

variable "key_name" {
  description = "The EC2 SSH key"
  type        = "string"
}

variable "s3_bucket" {
  description = "S3 bucket for uploading Nix expressions"
  type        = "string"
}

variable "nixexprs" {
  description = "Path to a directory containing a `configuration.nix`. This file may refer to files in, or under that directory, but not up."
  type        = "string"
}

variable "tags" {
  default = []
}

module "this" {
  #source               = "github.com/kreisys/terraform-aws-ssm-nixos?ref=bd828334715df1813e7a80a85338b463538dae2e"
  source        = "/Users/kreisys/src/anxt"
  display_name  = "${var.display_name}"
  nixos_release = "18.03"
  s3_bucket     = "${var.s3_bucket}"
  nixexprs      = "${var.nixexprs}"

  nix_channels = {
    nixos-unstable = "http://nixos.org/channels/nixos-unstable"
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "${module.this.name}-"
  image_id             = "${module.this.image_id}"
  iam_instance_profile = "${module.this.iam_instance_profile}"
  user_data            = "${module.this.userdata}"
  key_name             = "${var.key_name}"

  security_groups = ["${var.security_groups}"]
  instance_type   = "${var.instance_type}"
  spot_price      = "${var.spot_price}"

  root_block_device = [{
    volume_size = "50"
    volume_type = "gp2"
  }]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                 = "${module.this.name}"
  launch_configuration = "${aws_launch_configuration.this.name}"
  vpc_zone_identifier  = ["${data.aws_subnet_ids.selected.ids}"]
  min_size             = "${var.count}"
  max_size             = "${var.count}"
  desired_capacity     = "${var.count}"
  tags                 = ["${concat(module.this.tags, var.tags)}"]

  lifecycle {
    create_before_destroy = true
  }
}
