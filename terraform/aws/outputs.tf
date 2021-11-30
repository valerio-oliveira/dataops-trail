# resource "local_file" "hosts_region" {
#   #  content  = <<-DOC
#   content  = <<EOF
# %{if(var.is_main_region)}[postgresql-main]%{else}[postgresql-replica]%{endif}
# %{for s in module.vm_database.*.public_ip~}
# ${s}
# %{endfor~}
# EOF
#   filename = format("%s/hosts_%s", var.ansible_directory, data.aws_region.current.name)
# }
