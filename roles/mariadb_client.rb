name "mariadb_client"
description "A role to configure a MariaDB client"
run_list "recipe[mariadb::default]",
         "recipe[mariadb::client]"
