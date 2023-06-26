resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = "n virg"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
    tags = {
    Name = "jenkins-instance"
  }
}

resource "null_resource" "jenkins_setup" { 
    depends_on = [aws_instance.jenkins_instance]
 
  connection {
    type        = "ssh"
    private_key = file("keypair.pem")
    user        = "ubuntu"
    host        = aws_instance.jenkins_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install openjdk-11-jre-headless -y",
      "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install jenkins -y",
      "sudo systemctl start jenkins",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]
  }
}

# print the url of the jenkins server
output "website_url" {
  value = join("", ["http://", aws_instance.jenkins_instance.public_dns, ":", "8080"])
  }
