data "template_file" "ansible_hosts" {
  template = file("../../ansible/templates/hosts")
  vars = {
    postgresql_host             = module.site1.database_data["private_ip"]
    postgresql_port             = var.dbport
    postgresql_db_name          = "${var.dbname}"
    postgresql_db_user          = "${var.dbuser}"
    postgresql_db_user_password = "${var.dbpass}"

    api_application_name      = "${var.dbappname}"
    api_source_directory      = "../application/"
    api_destination_directory = "/usr/src/application/"
    api_owner                 = "admin"

    site1_db_hostname    = "site1-db-${split("172-20-1-", replace(replace(split(".", module.site1.database_data["private_dns"])[0], "ip-", ""), "ec2-", ""))[1]}"
    site1_db_private_dns = module.site1.database_data["private_dns"]
    site1_db_private_ip  = module.site1.database_data["private_ip"]
    site1_db_public_dns  = module.site1.database_data["public_dns"]
    site1_db_public_ip   = module.site1.database_data["public_ip"]

    site1_app_hostname    = "site1-app-${split("172-20-1-", replace(replace(split(".", module.site1.application_data["private_dns"])[0], "ip-", ""), "ec2-", ""))[1]}"
    site1_app_private_dns = module.site1.application_data["private_dns"]
    site1_app_private_ip  = module.site1.application_data["private_ip"]
    site1_app_public_dns  = module.site1.application_data["public_dns"]
    site1_app_public_ip   = module.site1.application_data["public_ip"]

    site1_svc_hostname    = "site1-svc-${split("172-20-1-", replace(replace(split(".", module.site1.service_data["private_dns"])[0], "ip-", ""), "ec2-", ""))[1]}"
    site1_svc_private_dns = module.site1.service_data["private_dns"]
    site1_svc_private_ip  = module.site1.service_data["private_ip"]
    site1_svc_public_dns  = module.site1.service_data["public_dns"]
    site1_svc_public_ip   = module.site1.service_data["public_ip"]

    site2_db_hostname    = "site2-db-${split("172-21-1-", replace(replace(split(".", module.site2.database_data["private_dns"])[0], "ip-", ""), "ec2-", ""))[1]}"
    site2_db_private_dns = module.site2.database_data["private_dns"]
    site2_db_private_ip  = module.site2.database_data["private_ip"]
    site2_db_public_dns  = module.site2.database_data["public_dns"]
    site2_db_public_ip   = module.site2.database_data["public_ip"]

    site2_app_hostname    = "site2-app-${split("172-21-1-", replace(replace(split(".", module.site2.application_data["private_dns"])[0], "ip-", ""), "ec2-", ""))[1]}"
    site2_app_private_dns = module.site2.application_data["private_dns"]
    site2_app_private_ip  = module.site2.application_data["private_ip"]
    site2_app_public_dns  = module.site2.application_data["public_dns"]
    site2_app_public_ip   = module.site2.application_data["public_ip"]

    site2_svc_hostname    = "site2-svc-${split("172-21-1-", replace(replace(split(".", module.site2.service_data["private_dns"])[0], "ip-", ""), "ec2-", ""))[1]}"
    site2_svc_private_dns = module.site2.service_data["private_dns"]
    site2_svc_private_ip  = module.site2.service_data["private_ip"]
    site2_svc_public_dns  = module.site2.service_data["public_dns"]
    site2_svc_public_ip   = module.site2.service_data["public_ip"]
    ssh_public_key        = replace(var.ssh_public_key, ".pub", "")
  }
}
resource "null_resource" "ansible_hosts_output" {
  triggers = {
    template = data.template_file.ansible_hosts.rendered
  }
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_hosts.rendered}\" > ${join("/", ["../../ansible/inventories", "hosts"])}"
  }
}

data "template_file" "site1_appserver_env" {
  template = file("../../ansible/roles/appserver/templates/.env")
  vars = {
    secret    = "${var.appserver_secret_key}"
    dbhost    = "${module.site1.database_data["private_ip"]}"
    dbport    = var.dbport
    dbname    = "${var.dbname}"
    dbuser    = "${var.dbuser}"
    dbpass    = "${var.dbpass}"
    dbappname = "${var.dbappname}"
  }
}
resource "null_resource" "site1_appserver_env_output" {
  triggers = {
    template = data.template_file.site1_appserver_env.rendered
  }
  provisioner "local-exec" {
    command = "echo \"${data.template_file.site1_appserver_env.rendered}\" > ${join("/", ["../../ansible/roles/appserver/files", "site1.env"])}"
  }
}

data "template_file" "site2_appserver_env" {
  template = file("../../ansible/roles/appserver/templates/.env")
  vars = {
    secret    = "${var.appserver_secret_key}"
    dbhost    = "${module.site2.database_data["private_ip"]}"
    dbport    = var.dbport
    dbname    = "${var.dbname}"
    dbuser    = "${var.dbuser}"
    dbpass    = "${var.dbpass}"
    dbappname = "${var.dbappname}"
  }
}
resource "null_resource" "site2_appserver_env_output" {
  triggers = {
    template = data.template_file.site2_appserver_env.rendered
  }
  provisioner "local-exec" {
    command = "echo \"${data.template_file.site2_appserver_env.rendered}\" > ${join("/", ["../../ansible/roles/appserver/files", "site2.env"])}"
  }
}

resource "local_file" "haproxy_cfg" {
  content  = <<EOF
global
    log /dev/log	local0
    log /dev/log	local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

    # Default SSL material locations
    ca-base /etc/ssl/certs
    crt-base /etc/ssl/private

    # Default ciphers to use on SSL-enabled listening sockets.
    # For more information, see ciphers(1SSL). This list is from:
    #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
    # An alternative list with additional directives can be obtained from
    #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
    ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
    ssl-default-bind-options no-sslv3

defaults
    log	global
    mode	http
    option	httplog
    option	dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

frontend main
    bind *:80
    bind *:8000
    bind *:5432
    default_backend hometask

backend hometask
    balance roundrobin
    server hometask1_1 ${module.site1.application_data["private_ip"]}:8001
    server hometask1_2 ${module.site1.application_data["private_ip"]}:8002
    server hometask1_3 ${module.site1.application_data["private_ip"]}:8003
    server hometask2_1 ${module.site2.application_data["private_ip"]}:8001
    server hometask2_2 ${module.site2.application_data["private_ip"]}:8002
    server hometask2_3 ${module.site2.application_data["private_ip"]}:8003

EOF
  filename = format("%s/%s", var.haproxy_conf, "haproxy.cfg")
}
