# IAM Role for Jenkins Server
resource "aws_iam_role" "iam_role" {
    name = "${local.org}-${local.project}-${local.env}-IAM-ROLE"
    assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
}
EOF
tags = {
    Name = "${local.org}-${local.project}-${local.env}-IAM-ROLE"
    env = var.env
  }
}

#POLICY ATTACHMENT TO THE ROLE
resource "aws_iam_role_policy_attachment" "POLICY" {
    role       = aws_iam_role.iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
}
resource "aws_iam_role_policy_attachment" "policy2" {
  role = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for Jenkins Server
resource "aws_iam_instance_profile" "IAM_INSTANCE_PROFILE" {
    name = "${local.org}-${local.project}-${local.env}-IAM-INSTANCE-PROFILE"
    role = aws_iam_role.iam_role.name
}