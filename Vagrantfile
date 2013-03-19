Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
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
      },
      # :icat => {
      #   :glassfish_password => "adminadmin",
      # },
      :glassfish => {
        :username => "admin",
      }
     }     
  end 
end
