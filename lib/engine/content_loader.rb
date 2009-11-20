module Engine::ContentLoader
  def load_content!
    # Theoretically, the options hash contains a list of modules to load, and they should be loaded in order of
    # appearance. If this is not the case, create them from the module index loaded earlier. Whatever order they
    # were detected in, that's the default load order.
    options[:module_load_order] ||= Engine::ContentLoader.instance_variable_get("@content_module_index")
    @content_modules = []
    options[:module_load_order].each do |mod|
      puts "Loading module: #{mod}" if $VERBOSE
      @content_modules << Engine::ContentModule.new(mod, self)
    end

    # After content has been loaded and the rest of engine initialization has completed,
    # we need to transfer the user to the main interface.
    after_initialize do
      c = self.current_controller || Engine::Controller::Base.root
      assume_interface(c) if c
    end
  end

  def self.included(base)
    base.send(:attr_reader,   :content_modules)
    base.send(:attr_accessor, :current_controller)
    
    # Index the available modules. Note that this does not actually load them, only creates a list of those available.
    # This affords the user an opportunity to disable or reorder the modules.
    @content_module_index = Dir.glob(File.join(ENV['DIVINITY_ROOT'], "vendor/modules", "*"))
  end
end
