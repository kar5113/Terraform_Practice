module "components" {
   for_each = var.component
    
    source = "../Roboshop-component" 
    
    component = each.key
  
    rule_priority = each.value
}