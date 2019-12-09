data "template_file" "userdata" {
  template = file("${path.module}/userdata.tmpl")
/*
  vars = {
    efs_host = var.efs_host
  }
*/
}