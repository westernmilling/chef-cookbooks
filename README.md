# chef-cookbooks
Random Chef cookbooks for application deployments

knife solo prepare user@host
knife solo cook -V -c knife.rb -o "recipe[x::y]" user@host
knife solo cook -V -c knife.rb -o "role[role_name]" user@host
knife solo cook -V -i ~/Documents/DevOps/chef-cookbooks/.vagrant/machines/nginx/virtualbox/private_key -o "recipe[???]"user@ip

knife solo cook -V -c knife.rb -o "recipe_or_role[]" vagrant@ip -i .vagrant/machines/{vm_name}/virtualbox/private_key

## Create a new site-cookbooks

```
knife cookbook create -o site-cookbooks/ cookbook-name
```
