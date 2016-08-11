module ScriptRelocator
  class Railtie < Rails::Railtie
    initializer 'script_relocator.configure_rails_initialization' do |app|
      app.middleware.use ScriptRelocator::Rack
    end
  end
end
