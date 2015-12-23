name "app_server"
description "A role to configure unicorn application servers"
run_list "recipe[ruby_from_source]",
         "recipe[nodejs::default]",
         "recipe[deploy::user]",
         "recipe[deploy::app]",
         "recipe[deploy::github]",
         "recipe[deploy::unicorn]"
