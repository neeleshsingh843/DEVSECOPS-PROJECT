locals{
  instance_names = ["JENKINS-SERVER","MONITORING-SERVER","KUBERNETES-MASTER-NODE","KUBERNETES-WORKER-NODE"]
}

resource "aws_instance" "jenkins-server" {
    count = var.ec2-instance-count
    ami   = data.aws_ami.AMI.id
    instance_type = var.instance_type[count.index]
    key_name = var.key-name
    subnet_id = aws_subnet.PUBLIC-SUBNET[count.index].id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.SG.id ]
    iam_instance_profile = aws_iam_instance_profile.IAM_INSTANCE_PROFILE.name
    root_block_device {
      volume_size = var.ec2_volume_size
      volume_type = var.ec2_volume_type
      delete_on_termination = true

    }
    
    tags = {
        Name = "${local.org}-${local.project}-${local.env}-${local.instance_names[count.index]}"
        env = "${local.env}"
    }
}