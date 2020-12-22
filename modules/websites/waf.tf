resource "aws_waf_ipset" "ipset" {
  name = "${var.env}ipset"

  ip_set_descriptors {
    type  = "IPV4"
    value = "5.173.233.117/32"
  }
}

resource "aws_waf_rule" "wafrule" {
  depends_on  = [aws_waf_ipset.ipset]
  name        = "${var.env}rule"
  metric_name = "${var.env}rule"

  predicates {
    data_id = aws_waf_ipset.ipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  depends_on = [
    aws_waf_ipset.ipset,
    aws_waf_rule.wafrule,
  ]
  name        = "${var.env}acl"
  metric_name = "${var.env}acl"

  default_action {
    type = var.enable_waf ? "BLOCK" : "ALLOW"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_waf_rule.wafrule.id
    type     = "REGULAR"
  }
}

