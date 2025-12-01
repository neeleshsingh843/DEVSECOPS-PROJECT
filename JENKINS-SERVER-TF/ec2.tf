resource "aws_instance" "JENKINS-SERVER" {
    ami   = data.aws_ami.AMI.id
    instance_type = var.instance_type
    key_name = var.key-name
    subnet_id = aws_subnet.SUBNET.id
    vpc_security_group_ids = [aws_security_group.SG.id ]
    iam_instance_profile = aws_iam_instance_profile.IAM_INSTANCE_PROFILE.name
    root_block_device {
      volume_size = 30
      volume_type = "gp3"

    }
    user_data = file("./install.sh")
    tags = {
        Name = "JENKINS-SERVER"
    }
}