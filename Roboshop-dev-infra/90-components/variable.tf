variable "component" {
    description = "The name of the component"
    type        = map
    default = {
   #     "frontend" : 10,
        "catalogue": 10,
        # "user"     : 20,
        # "cart"     : 30,
        # "shipping" : 40,
        # "payment"  : 50
    }
  
}