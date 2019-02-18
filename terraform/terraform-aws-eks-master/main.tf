module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "2.1.0"

  cluster_name                               = "${var.cluster_prefix}"
  subnets                                    = ["${var.private_subnets}"]
  write_kubeconfig                           = true
  config_output_path                         = "${var.outputs_directory}"
  tags                                       = "${var.tags}"
  vpc_id                                     = "${var.vpc_id}"
  worker_groups                              = "${local.worker_group}"
  kubeconfig_aws_authenticator_env_variables = "${var.aws_authenticator_env_variables}"
  worker_group_count                         = "1"
  worker_additional_security_group_ids       = ["${aws_security_group.all_worker_mgmt.id}"]
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
      "170.34.0.0/16",
    ]
  }
}

data "template_file" "http_proxy_workergroup" {
  template = "${file("${path.module}/templates/workergroup_proxy.tpl")}"

  vars {
    http_proxy   = "${var.http_proxy}"
    https_proxy  = "${var.http_proxy}"
    no_proxy     = "${var.no_proxy}"
    cluster_name = "${var.cluster_prefix}"
  }
}

data "template_file" "proxy_environment_variables" {
  template = "${file("${path.module}/templates/proxy-environment-variables.yaml.tpl")}"

  vars {
    http_proxy  = "${var.http_proxy}"
    https_proxy = "${var.http_proxy}"
    no_proxy    = "${var.no_proxy}"
  }
}

resource "local_file" "proxy_environment_variables" {
  count    = "${var.http_proxy != "" ? 1 : 0 }"
  filename = "${var.outputs_directory}proxy-environment-variables.yaml"
  content  = "${data.template_file.proxy_environment_variables.rendered}"
}

resource "null_resource" "proxy_environment_variables" {
  count      = "${var.http_proxy != "" ? 1 : 0 }"
  depends_on = ["module.eks", "local_file.proxy_environment_variables"]

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.proxy_environment_variables.filename} --kubeconfig=${var.outputs_directory}kubeconfig_${var.cluster_prefix}"
  }
}

resource "null_resource" "master_config_services_proxy" {
  count      = "${var.http_proxy != "" ? length(local.master_config_services_proxy) : 0 }"
  depends_on = ["module.eks", "null_resource.proxy_environment_variables"]

  provisioner "local-exec" {
    command = <<EOC
    kubectl get ${lookup(local.master_config_services_proxy[count.index], "type")} ${lookup(local.master_config_services_proxy[count.index], "name")} --namespace=kube-system --kubeconfig=${var.outputs_directory}kubeconfig_${var.cluster_prefix} -o=json > ${var.outputs_directory}${lookup(local.master_config_services_proxy[count.index], "name")}.tmp;
    jq '.spec.template.spec.containers[] += {"envFrom": [{"configMapRef": {"name": "proxy-environment-variables"}}]}' ${var.outputs_directory}${lookup(local.master_config_services_proxy[count.index], "name")}.tmp > ${var.outputs_directory}${lookup(local.master_config_services_proxy[count.index], "name")}.json;
    kubectl apply -f ${var.outputs_directory}${lookup(local.master_config_services_proxy[count.index], "name")}.json --kubeconfig=${var.outputs_directory}kubeconfig_${var.cluster_prefix};
    rm ${var.outputs_directory}${lookup(local.master_config_services_proxy[count.index], "name")}.tmp;
  EOC
  }
}
