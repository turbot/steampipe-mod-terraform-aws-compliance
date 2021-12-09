benchmark "aws" {
  title = "AWS Best Practices"
  description = "Best practices for your AWS resources."
  children = [
    benchmark.aws_ec2,
    benchmark.aws_s3
  ]
}
