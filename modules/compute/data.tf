data "template_file" "userdata" {
  template = "${
              replace(
                replace(
                  replace(
                    replace(
                      file("${path.module}/userdata.tmpl"),
                    "WP_DB_NAME", "${var.db_schema}"),
                  "WP_DB_USER", "${var.db_username}"),
                "WP_DB_PASS", "${var.db_password}"),
              "WP_DB_HOST", "${var.db_endpoint}")
            }"
}