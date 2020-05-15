# Provider
  provider "aws" {
      access_key="AKIAJT4IKFNDUXVFXGHQ"
      secret_key="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"
      region="ap-south-1"
}

resource "aws_instance" "good-morning"{
  ami = "ami-0470e33cd681b2476"
  instance_type="t2.micro"
  availability_zone = "ap-south-1a"
  key_name="logiec2autoscaling"
  user_data = <<-EOF
   #!/bin/bash
   echo "Hello, World" > index.html
   nohup busybox httpd -f -p 8080 &
   EOF

  tags = {
     Name= "tf-example"
}
   ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 10
  }

}

resource "aws_security_group_rule" "example"{
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id="sg-05596f05dc37cfa4c"
 }

resource "aws_ebs_volume" "data-vol" {
 availability_zone = "ap-south-1a"
 size = 20
 tags = {
        Name = "data-volume"
 }

}
#
resource "aws_volume_attachment" "good-morning-vol" {
 device_name = "/dev/sdc"
 volume_id = "${aws_ebs_volume.data-vol.id}"
 instance_id = "${aws_instance.good-morning.id}"
}
