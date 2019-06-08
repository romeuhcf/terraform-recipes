resource "aws_launch_configuration" "app-launchconfig" {
  name_prefix     = "${var.app_name}-launchconfig"
  image_id        = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type   = "${var.instance_type}"
  key_name        = "${aws_key_pair.mykeypair.key_name}"
  security_groups = ["${aws_security_group.web-instance.id}"]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install nginx\nMYIP=`hostname`\necho 'this is: '$MYIP > /var/www/html/index.html"
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "app-autoscaling" {
  name                      = "${var.app_name}-autoscaling"
  vpc_zone_identifier       = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  launch_configuration      = "${aws_launch_configuration.app-launchconfig.name}"
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.main-elb.name}"]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "${var.app_name} ec2 instance"
    propagate_at_launch = true
  }
}

