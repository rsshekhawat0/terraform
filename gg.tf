provider "aws" {
  region  = "ap-south-1"
  profile  =  "rohan"
}
resource "aws_instance" "web2" {
  ami           = "ami-052c08d70def0ac62"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name      =  "ramjiki"
  security_groups = [ "launch-wizard-1" ]

  tags = {
    Name = "Rohan terraform"
  }
}
resource "aws_ebs_volume" "ebs11" {
  availability_zone = "ap-south-1b"
  size              = 8
  tags = {
    Name = "Swsha1"
  }
}
resource "aws_volume_attachment" "ebs11" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs11.id
  instance_id = aws_instance.web2.id
}
resource "null_resource" "nullremote4"  {

depends_on = [
    aws_instance.web2,
  ]
  connection{
     type = "ssh"
     user = "ec2-user"
     private_key = file("C:/Users/Rohan Shekhawat/Downloads/ramjiki.pem")
     host = aws_instance.web2.public_ip
     }

provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd  php git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
    ]
  }
}
resource "null_resource" "nullremote3"  {

depends_on = [
    aws_volume_attachment.ebs11,
  ]
  connection{
     type = "ssh"
     user = "ec2-user"
     private_key = file("C:/Users/Rohan Shekhawat/Downloads/ramjiki.pem")
     host = aws_instance.web2.public_ip
     }

provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4  /dev/xvdh",
      "sudo mount  /dev/xvdh2  /var/www/html",
      "sudo rm -rf /var/www/html/*",
    ]
  }
}

resource "aws_s3_bucket" "examplebucket2dd233" {
  bucket = "examplebuckettfpofpdfds"
}
resource "aws_s3_bucket_public_access_block" "examplebucket2d33" {
  bucket = aws_s3_bucket.examplebucket2dd233.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_object" "file_upload" {
  key = "shekhawat.jpg"
bucket = aws_s3_bucket.examplebucket2dd233.id
source = "C:/Users/Lenovo/Desktop/Untitled Folder/complete/Untitled Folder/datafac/Testing/Testing/Happy/Happy-181.jpg"
acl="public-read"
}

