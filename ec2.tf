# Provider
 provider "aws" {
      access_key="AKIAQORZLAFTV3Y4P4EP"
      secret_key="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"
      region="ap-south-1"
      skip_credentials_validation = true
      skip_requesting_account_id = true
      skip_metadata_api_check = true
}

resource "aws_instance" "example"{
  ami = "ami-0470e33cd681b2476"
  instance_type="t2.micro"
  count=1
  user_data = <<-EOF
   #!/bin/bash
   echo "Hello, World" > index.html
   nohup busybox httpd -f -p 8080 &
   EOF

  tags = {
     Name= "tf-example"
}
}

resource "aws_security_group" "instance"{
  name="tf-example-instance"
  ingress {
    from_port=8080
    to_port=8080
    protocol="tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}

