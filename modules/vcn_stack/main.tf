locals {
  dns_label = var.vcn_dns_label != null && var.vcn_dns_label != "" ? var.vcn_dns_label : "vcnprod"

  subnet_display_name = { for k, v in var.subnets : k => "${var.vcn_display_name}-${k}" }

  route_table_id_by_type = {
    public  = oci_core_route_table.public.id
    private = oci_core_route_table.private.id
  }
}

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_block]
  display_name   = var.vcn_display_name
  dns_label      = local.dns_label
  freeform_tags  = var.freeform_tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.vcn_display_name}-igw"
  enabled        = true
  freeform_tags  = var.freeform_tags
}

resource "oci_core_nat_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.vcn_display_name}-nat"
  freeform_tags  = var.freeform_tags
}

resource "oci_core_service_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.vcn_display_name}-sgw"
  freeform_tags  = var.freeform_tags

  services {
    service_id = data.oci_core_services.all_oci_services.services[0].id
  }
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.vcn_display_name}-rt-public"
  freeform_tags  = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.vcn_display_name}-rt-private"
  freeform_tags  = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.this.id
  }

  route_rules {
    destination       = data.oci_core_services.all_oci_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR"
    network_entity_id = oci_core_service_gateway.this.id
  }
}

resource "oci_core_security_list" "subnet" {
  for_each       = var.subnets
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${local.subnet_display_name[each.key]}-sl"
  freeform_tags  = var.freeform_tags

  ingress_security_rules {
    protocol    = "all"
    source      = var.vcn_cidr_block
    description = "Tráfico dentro de la VCN"
  }

  dynamic "ingress_security_rules" {
    for_each = each.value.type == "public" ? [22, 80, 443] : []
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      description = "TCP ${ingress_security_rules.value} desde Internet (ajustar según política de seguridad)"
      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Salida a cualquier destino"
  }
}

resource "oci_core_subnet" "this" {
  for_each                   = var.subnets
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = each.value.cidr_block
  display_name               = local.subnet_display_name[each.key]
  dns_label                  = each.value.dns_label
  prohibit_public_ip_on_vnic = each.value.type == "private"
  route_table_id             = local.route_table_id_by_type[each.value.type]
  security_list_ids          = [oci_core_security_list.subnet[each.key].id]
  freeform_tags              = var.freeform_tags
}

resource "oci_core_drg_attachment" "vcn" {
  drg_id       = var.drg_id
  display_name = "${var.vcn_display_name}-drg-att"

  network_details {
    id   = oci_core_vcn.this.id
    type = "VCN"
  }
}
