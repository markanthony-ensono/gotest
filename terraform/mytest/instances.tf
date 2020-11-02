#-----------------------------------------------------
# MAA SERVER
#-----------------------------------------------------
resource "aws_instance" "example" {
  ami			  = "ami-0823c236601fef765"
  instance_type           = "t2.medium"
  vpc_security_group_ids  = [aws_security_group.open8080.id]
  subnet_id               = "subnet-4175af27"
  iam_instance_profile        = "InspectorRole"
  associate_public_ip_address = "true"
  tags = {
    Name        = "testdeploy"
    Description = "ens Terratest Instance"
    Owner       = "MarkA"
  }
  user_data = <<EOF
#!/bin/bash
echo "Hello, World!" > index.html
nohup busybox httpd -f -p 8080 &
EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
} 

resource "aws_security_group" "open8080" {
  vpc_id      = "vpc-75128013"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
