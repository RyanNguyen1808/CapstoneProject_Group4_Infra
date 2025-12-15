resource "aws_security_group" "ec2_jumphost_sg" {
  name        = "${var.name_prefix}-${local.workspace_safe}-ec2-jumphost-public-sg"
  description = "Allow SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict in real use
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_jumphost" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2_jumphost_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_jumphost_profile.name

  tags = {
    Name = "${var.name_prefix}-${local.workspace_safe}-ec2-jumphost"
  }
}