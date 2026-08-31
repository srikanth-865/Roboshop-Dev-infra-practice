variable "components"{
    default = {
               catalogue = {
                rule_priority = 10
                app_version = "v3"  #its on version 3
                  }
                user = {
                    rule_priority = 20
                   app_version = "v3"  #its on version 3
                  }
                 cart = {
                    rule_priority = 30
                   app_version = "v3"  #its on version 3
                  }
    
                   /*shipping = {
                    rule_priority = 40
                   app_version = "v3"  #its on version 3
                  }
    }
}
                  /* payment = {
                    rule_priority = 50
                   app_version = "v3"  #its on version 3
                  }
            #we are passing frontend also here and it  will connect to frontend load-balancer
                   frontend = {
                        rule_priority = 10
                   app_version = "v3"  #its on version 3
                  }
              */
variable "project"{
    default = "Roboshop1"
}
variable "environment"{
    default = "Dev"
}
variable "app_version"{
    default ="v3"
}

variable "domain_name"{
    default = "srikanth865.online"
}
