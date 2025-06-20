# Outputs
output "public_a_instance_id" {
  value = aws_instance.public_a_instance.id
}
// output "public_b_instance_id" {
//  value = aws_instance.public_b_instance.id
// }
output "private_a_instance_id" {
  value = aws_instance.private_a_instance.id
}
// output "private_b_instance_id" {
//   value = aws_instance.private_b_instance.id
// }
output "public_a_eip" {
  value = aws_eip.public_a_eip.public_ip
}
// output "public_b_eip" {
//  value = aws_eip.public_b_eip.public_ip
// }
output "vpc_id" {
  value = aws_vpc.main.id
}
