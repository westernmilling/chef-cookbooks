name "mariadb_server"
description "A role to install a MariaDB server"
run_list "recipe[mariadb::default]",
         "recipe[mariadb::server]"
