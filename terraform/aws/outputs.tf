# variable "filename" {
#   default = "./templates/hosts_ident1.txt" # format("%s/%s", var.ansible_inventories, "hosts_ident")
# }



resource "local_file" "hosts_addresses" {
  content  = <<EOF
[all:vars]
site1_db_hostname     = site1-db-${replace(replace(split(".", module.site1.database_data["private_dns"])[0], "ip-", ""), "ec2-", "")}
site1_db_private_dns  = ${module.site1.database_data["private_dns"]}
site1_db_private_ip   = ${module.site1.database_data["private_ip"]}
site1_db_public_dns   = ${module.site1.database_data["public_dns"]}
site1_db_public_ip    = ${module.site1.database_data["public_ip"]}

site1_app_hostname    = site1-app-${replace(replace(split(".", module.site1.application_data["private_dns"])[0], "ip-", ""), "ec2-", "")}
site1_app_private_dns = ${module.site1.application_data["private_dns"]}
site1_app_private_ip  = ${module.site1.application_data["private_ip"]}
site1_app_public_dns  = ${module.site1.application_data["public_dns"]}
site1_app_public_ip   = ${module.site1.application_data["public_ip"]}

site2_db_hostname     = site2-db-${replace(replace(split(".", module.site2.database_data["private_dns"])[0], "ip-", ""), "ec2-", "")}
site2_db_private_dns  = ${module.site2.database_data["private_dns"]}
site2_db_private_ip   = ${module.site2.database_data["private_ip"]}
site2_db_public_dns   = ${module.site2.database_data["public_dns"]}
site2_db_public_ip    = ${module.site2.database_data["public_ip"]}

site2_app_hostname    = site2-app-${replace(replace(split(".", module.site2.application_data["private_dns"])[0], "ip-", ""), "ec2-", "")}
site2_app_private_dns = ${module.site2.application_data["private_dns"]}
site2_app_private_ip  = ${module.site2.application_data["private_ip"]}
site2_app_public_dns  = ${module.site2.application_data["public_dns"]}
site2_app_public_ip   = ${module.site2.application_data["public_ip"]}

[being practical here]
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.site1.database_data["public_ip"]}
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.site1.application_data["public_ip"]}
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.site2.database_data["public_ip"]}
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.site2.application_data["public_ip"]}
EOF
  filename = format("%s/%s", var.ansible_inventories, "hosts_addresses")
}

resource "local_file" "hosts_ident" {
  content  = <<EOF
[site1-db]
${module.site1.database_data["public_ip"]}

[site1-app]
${module.site1.application_data["public_ip"]}

[site2-db]
${module.site2.database_data["public_ip"]}

[site2-app]
${module.site2.application_data["public_ip"]}

[allsites-db]
${module.site1.database_data["public_ip"]}
${module.site2.database_data["public_ip"]}

[allsites-app]
${module.site1.application_data["public_ip"]}
${module.site2.application_data["public_ip"]}

[allsites-monitor]
${module.site1.database_data["public_ip"]}
${module.site1.application_data["public_ip"]}
${module.site2.database_data["public_ip"]}
${module.site2.application_data["public_ip"]}

[allsites-db:vars]

[all:vars]
postgresql_host= ${module.site1.database_data["private_ip"]}
postgresql_port= ${var.dbport}
postgresql_db_name= "${var.dbname}"
postgresql_db_user= "${var.dbuser}"
postgresql_db_user_password= "${var.dbpass}"
api_application_name= "${var.dbappname}"
api_source_directory= "../application/"
api_destination_directory= "/usr/src/application/"
api_owner= "admin"

EOF
  filename = format("%s/%s", var.ansible_inventories, "hosts_ident")
}

resource "local_file" "django_env" {
  content  = <<EOF
# ------------
# django
# ------------
SECRET_KEY="${var.django_secret_key}"

# ------------
# database
# ------------
dbhost=${module.site1.database_data["private_ip"]}
dbport=${var.dbport}
dbname=${var.dbname}
dbuser=${var.dbuser}
dbpass=${var.dbpass}
dbappname=${var.dbappname}
EOF
  filename = format("%s/%s", var.django_env, ".env")
}
