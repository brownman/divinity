module Engine::ContentLoader
  # Iterates through each active ContentModule and searches its base path for the specified file.
  # As a last resort, looks for the file in "data/#{filename}".
  # The last ContentModule loaded has the highest priority and will be searched first.
  def find_file(*filenames)
    filenames.flatten.each do |filename|
      return filename if File.file? filename

      # Search the user-defined overrides first
      fi = File.join(DIVINITY_ROOT, 'data/override', filename)
      return fi if File.file? fi
      locations = [ fi ]

      load_content! unless @content_modules
      # Order is reversed because we want the LAST module loaded to override any preceding it
      @content_modules.reverse.each do |cm|
        fi = File.join(cm.base_path, filename)
        return fi if File.file? fi
        locations << fi
      end
    end
    raise "Could not find any of:\n\t#{locations.join("\n\t")}"
  end

  # Takes a pattern or series of patterns and searches for their occurrance in each registered ContentModule
  def glob_files(*paths)
    load_content! unless @content_modules
    matches = []
    paths.flatten.each do |path|
      @content_modules.reverse.each do |cm|
        matches += Dir.glob(File.join(cm.base_path, path))
      end
    end
    matches.uniq
  end

  def load_content!
    # Theoretically, the options hash contains a list of modules to load, and they should be loaded in order of
    # appearance. If this is not the case, create them from the module index loaded earlier. Whatever order they
    # were detected in, that's the default load order.
    options[:module_load_order] ||= Engine::ContentLoader.instance_variable_get("@content_module_index")
    @content_modules = []
    options[:module_load_order].each do |mod|
      logger.debug "Loading module: #{mod}"
      mod = Engine::ContentModule.new(mod, self)
      @content_modules << mod
    end

    Resource::Base.create_resource_hooks(self)
    
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
    @content_module_index = [ File.join(DIVINITY_GEM_ROOT, "engine") ]
                            [ DIVINITY_ROOT ] +
                            Dir.glob(File.join(DIVINITY_ROOT, "vendor/modules", "*"))
  end
end
