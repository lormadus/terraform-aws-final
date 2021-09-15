# EC2 인스턴스 생성 
resource "aws_instance" "user30-web1" {
  ami               	= var.amazon_linux
  availability_zone 	= "ap-southeast-1a"
  # 리전마다 지원되는 인스턴스 타입이 다르기 때문에 미리 확인 필요
  instance_type     	= "t2.nano"
  key_name          	= var.dev_keyname
  vpc_security_group_ids = [
    aws_security_group.user30-sg.id,
    aws_default_security_group.user30-default-sg.id
  ]

  subnet_id                   = aws_subnet.user30-subnet1.id
  associate_public_ip_address = true

user_data = <<USER_DATA
#!/bin/bash
yum update -y
#### ALB만 설정하는 경우 아래 사용
yum install httpd -y
/bin/systemctl start httpd.service
systemctl enable httpd.service

## AWS CodeDeploy 사용하는 경우 Agent 설치 .  아래 eu-west-3 부분 각 Region Code로 수정 필요
##예) wget https://aws-codedeploy-eu-west-3.s3.amazonaws.com/latest/codedeploy-agent.noarch.rpm
wget https://aws-codedeploy-리전코드.s3.amazonaws.com/latest/codedeploy-agent.noarch.rpm
yum install ruby -y
yum -y install codedeploy-agent.noarch.rpm
service codedeploy-agent stop
service codedeploy-agent start
rm -f /var/www/html/index.html

USER_DATA

  tags = {
    Name = "user30-web1"
  }
}
