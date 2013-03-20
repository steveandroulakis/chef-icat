Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.forward_port 4848, 4848
  config.vm.forward_port 8080, 8080  
  config.vm.forward_port 8181, 8181
   config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "cookbooks"
     chef.add_recipe "icat"
     chef.log_level = :debug
     chef.json = {
      :java => {
       :install_flavor => "oracle",
       :jdk_version => "7",
       :oracle => {
           "accept_oracle_download_terms" => true
           }      
      }
     }     
  end 
end
