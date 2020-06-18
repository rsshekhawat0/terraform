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

resource "aws_s3_bucket" "gg1245" {
  bucket = "gg1245"
  acl    = "public-read"
  tags = {
      Name = "gg1245"
      Environment = "Dev"
  }
}



output "bucket" {
  value = aws_s3_bucket.gg1245
}



resource "aws_s3_bucket_object" "bucket_obj" {
  bucket = "${aws_s3_bucket.corruptgenius.id}"
  key    = "shekhawat.jpg"
  source = "./gitcode/shekhawat.jpg"
  acl	 = "public-read"
}



resource "aws_cloudfront_distribution" "gg" {
  origin {
    domain_name = "${aws_s3_bucket.gg1245.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.gg1245.id}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 wel"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.gg1245.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN"]
    }
  }

  tags = {
    Name        = "terr"
    Environment = "Production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [
    aws_s3_bucket.gg1245
  ]
}

