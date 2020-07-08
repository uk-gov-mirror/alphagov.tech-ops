resource "aws_autoscaling_group" "concourse_worker" {
  name                = "${var.deployment}-${var.name}-concourse-worker"
  max_size            = var.desired_capacity * 2
  min_size            = 0
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

  termination_policies = [
    "OldestLaunchConfiguration",
    "OldestInstance",
  ]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.concourse_worker.id
        version            = "$Latest"
      }

      override {
        instance_type = var.instance_type
      }
    }

    instances_distribution {
      on_demand_percentage_above_base_capacity = 100
    }
  }

  tag {
    key                 = "Deployment"
    value               = var.deployment
    propagate_at_launch = true
  }
}
