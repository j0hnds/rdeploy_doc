module RDeployDoc

  class Railtie < ::Rails::Railtie

    initializer "rdeploy_doc.make_it_happen" do
      puts "Hello from RDeployDoc's Railtie!!!"
    end

  end

end
