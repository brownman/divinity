# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{divinity}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colin MacKenzie IV (sinisterchipmunk)"]
  s.date = %q{2009-12-09}
  s.description = %q{A new kind of game engine}
  s.email = %q{sinisterchipmunk@gmail.com}
  s.extensions = ["ext/divinity/extconf.rb"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "TODO.rdoc",
     "VERSION",
     "divinity.gemspec",
     "engine/controllers/components/button_controller.rb",
     "engine/controllers/components/component_controller.rb",
     "engine/controllers/components/panel_controller.rb",
     "engine/helpers/components/button_helper.rb",
     "engine/helpers/components/component_helper.rb",
     "engine/helpers/components/panel_helper.rb",
     "engine/models/components/button.rb",
     "engine/models/components/panel.rb",
     "engine/models/errors.rb",
     "engine/models/errors/event_errors.rb",
     "engine/models/events.rb",
     "engine/models/events/generic.rb",
     "engine/models/events/input_event.rb",
     "engine/models/events/interface_events.rb",
     "engine/models/events/interface_events/controller_created_event.rb",
     "engine/models/events/interface_events/focus_event.rb",
     "engine/models/events/interface_events/interface_assumed.rb",
     "engine/models/events/interface_events/redirected.rb",
     "engine/models/events/keyboard_events.rb",
     "engine/models/events/keyboard_events/key_event.rb",
     "engine/models/events/keyboard_events/key_pressed.rb",
     "engine/models/events/keyboard_events/key_released.rb",
     "engine/models/events/mouse_events.rb",
     "engine/models/events/mouse_events/mouse_button_event.rb",
     "engine/models/events/mouse_events/mouse_event.rb",
     "engine/models/events/mouse_events/mouse_moved.rb",
     "engine/models/events/mouse_events/mouse_pressed.rb",
     "engine/models/events/mouse_events/mouse_released.rb",
     "engine/models/events/sdl_events.txt",
     "engine/models/resources/actor.rb",
     "engine/views/components/button/index.rb",
     "engine/views/components/panel/index.rb",
     "ext/divinity/Makefile",
     "ext/divinity/array.c",
     "ext/divinity/divinity.c",
     "ext/divinity/divinity.h",
     "ext/divinity/divinity_macros.h",
     "ext/divinity/extconf.rb",
     "ext/divinity/frustum.c",
     "ext/divinity/octree.c",
     "ext/divinity/octree_object_descriptor.c",
     "ext/divinity/open_gl.c",
     "ext/divinity/planes_and_vertices.c",
     "ext/divinity/render_helper.c",
     "ext/divinity/ruby.h",
     "ext/divinity/vector3d.c",
     "lib/dependencies.rb",
     "lib/dependencies/geometry.rb",
     "lib/dependencies/helpers.rb",
     "lib/devices/input_device.rb",
     "lib/devices/keyboard.rb",
     "lib/devices/keyboard/modifiers.rb",
     "lib/devices/mouse.rb",
     "lib/divinity.rb",
     "lib/divinity_engine.rb",
     "lib/engine/cache.rb",
     "lib/engine/content_loader.rb",
     "lib/engine/content_module.rb",
     "lib/engine/controller.rb",
     "lib/engine/controller/base.rb",
     "lib/engine/controller/class_methods.rb",
     "lib/engine/controller/event_dispatching.rb",
     "lib/engine/controller/helpers.rb",
     "lib/engine/controller/input_device_proxy.rb",
     "lib/engine/controller/keyboard_proxy.rb",
     "lib/engine/controller/mouse_proxy.rb",
     "lib/engine/controller/request.rb",
     "lib/engine/controller/response.rb",
     "lib/engine/controller/routing.rb",
     "lib/engine/controller/view_paths.rb",
     "lib/engine/default_render_block.rb",
     "lib/engine/default_update_block.rb",
     "lib/engine/delegation.rb",
     "lib/engine/model/base.rb",
     "lib/engine/view.rb",
     "lib/engine/view/base.rb",
     "lib/extensions/array.rb",
     "lib/extensions/bytes.rb",
     "lib/extensions/fixnum.rb",
     "lib/extensions/magick.rb",
     "lib/extensions/magick/image.rb",
     "lib/extensions/magick/image_list.rb",
     "lib/extensions/magick_extensions.rb",
     "lib/extensions/matrix.rb",
     "lib/extensions/numeric.rb",
     "lib/extensions/object.rb",
     "lib/extensions/string.rb",
     "lib/geometry/dimension.rb",
     "lib/geometry/plane.rb",
     "lib/geometry/point.rb",
     "lib/geometry/rectangle.rb",
     "lib/geometry/vector3d.rb",
     "lib/helpers/attribute_helper.rb",
     "lib/helpers/component_helper.rb",
     "lib/helpers/content_helper.rb",
     "lib/helpers/event_listening_helper.rb",
     "lib/helpers/render_helper.rb",
     "lib/interface/layouts/alignment.rb",
     "lib/interface/layouts/border_layout.rb",
     "lib/interface/layouts/flow_layout.rb",
     "lib/interface/layouts/grid_layout.rb",
     "lib/interface/layouts/layout.rb",
     "lib/interface/theme.rb",
     "lib/interface/theme/effects/button_effect.rb",
     "lib/interface/theme/effects/effect.rb",
     "lib/math/dice.rb",
     "lib/math/die.rb",
     "lib/open_gl/camera.rb",
     "lib/open_gl/display_list.rb",
     "lib/open_gl/frustum.rb",
     "lib/open_gl/octree.rb",
     "lib/physics/gravity/gravitational_field.rb",
     "lib/physics/gravity/gravity_source.rb",
     "lib/requires.rb",
     "lib/resource/base.rb",
     "lib/resource/class_methods.rb",
     "lib/resource/image.rb",
     "lib/resource/world/object.rb",
     "lib/resource/world/scene.rb",
     "lib/resource/world/scenes/height_map.rb",
     "lib/textures/font.rb",
     "lib/textures/texture.rb",
     "lib/textures/texture_generator.rb",
     "rakefile",
     "tasks/dev.rb",
     "tasks/docs.rb",
     "tasks/jeweler.rb",
     "tasks/tests.rb",
     "template.rb",
     "test/camera_test.rb",
     "test/frustum_test.rb",
     "test/octree_test.rb",
     "test/test_divinity.rb",
     "test/test_helper.rb",
     "test/unit/extensions/array_test.rb",
     "test/unit/extensions/fixnum_test.rb",
     "test/unit/geometry/vertex3d_test.rb",
     "test/unit/models/events_test.rb",
     "vendor/dependencies/1.8/linux/rmagick-2.12.2.gem",
     "vendor/dependencies/1.8/linux/ruby-opengl-0.60.1.gem",
     "vendor/dependencies/1.8/linux/rubysdl-2.1.0.gem",
     "vendor/dependencies/1.8/win32/rmagick-2.12.0/ImageMagick-6.5.6-8-Q8-windows-dll.exe",
     "vendor/dependencies/1.8/win32/rmagick-2.12.0/README.html",
     "vendor/dependencies/1.8/win32/rmagick-2.12.0/RMagick-2.12.0.tar.gz",
     "vendor/dependencies/1.8/win32/rmagick-2.12.0/rmagick-2.12.0-x86-mswin32.gem",
     "vendor/dependencies/1.8/win32/ruby-opengl-0.60.1-x86-mswin32.gem",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/NEWS.en",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/NEWS.ja",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/README.en",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/README.en.win32",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/README.ja",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/README.ja.win32",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/SDL.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/SDL_image.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/SDL_mixer.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/SDL_ttf.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/SGE.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/jpeg.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libcharset-1.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libfreetype-6.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libiconv-2.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libogg-0.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libpng12-0.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libtiff-3.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libvorbis-0.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/libvorbisfile-3.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/smpeg.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/dll/zlib1.dll",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/ext/opengl.so",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/ext/sdl.so",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/install_rubysdl.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/lib/rubysdl_aliases.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/lib/rubysdl_compatible_ver1.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/lib/sdl.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/rubysdl_doc_old.en.rd",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/rubysdl_doc_old.rd",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/rubysdl_ref.html",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/rubysdl_ref.rd",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/aadraw.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/alpha.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/alphadraw.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/bfont.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/cdrom.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/collision.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/cursor.bmp",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/cursor.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/ellipses.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/event2.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/font.bmp",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/font.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/fpstimer.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/icon.bmp",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/icon.bmp.gz",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/icon.png",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/joy2.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/kanji.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/load_from_io.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/movesp.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/playmod.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/plaympeg.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/playwave.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/randrect.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/sample.ttf",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/sdl.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/sdlskk.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/sgetest.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/stetris.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/testgl.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/testsprite.rb",
     "vendor/dependencies/1.8/win32/rubysdl-2.1.0-mswin32-1.8.7-p72/sample/transformblit.rb",
     "vendor/dependencies/1.8/win32/rubysdl-mswin32-1.8-2.1.0.1.gem",
     "vendor/dependencies/1.9.1/linux/ruby-opengl-0.60.1.gem",
     "vendor/dependencies/1.9.1/mkrf-0.2.3.gem",
     "vendor/dependencies/1.9.1/rake-0.8.7.gem",
     "vendor/dependencies/1.9.1/win32/README",
     "vendor/dependencies/1.9.1/win32/ruby-opengl-0.60.1-x86-mswin32-ruby19.gem",
     "vendor/dependencies/1.9.1/win32/rubysdl-mswin32-1.9-2.1.0.1.gem",
     "vendor/dependencies/activesupport-2.3.4.gem"
  ]
  s.homepage = %q{http://github.com/sinisterchipmunk/divinity}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A new kind of game engine}
  s.test_files = [
    "test/camera_test.rb",
     "test/frustum_test.rb",
     "test/octree_test.rb",
     "test/test_divinity.rb",
     "test/test_helper.rb",
     "test/unit/extensions/array_test.rb",
     "test/unit/extensions/fixnum_test.rb",
     "test/unit/geometry/vertex3d_test.rb",
     "test/unit/models/events_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<ruby-opengl>, [">= 0.60.1"])
      s.add_runtime_dependency(%q<rmagick>, [">= 2.12.0"])
      s.add_runtime_dependency(%q<rubysdl-mswin32-1.8>, [">= 2.1.0.1"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_dependency(%q<ruby-opengl>, [">= 0.60.1"])
      s.add_dependency(%q<rmagick>, [">= 2.12.0"])
      s.add_dependency(%q<rubysdl-mswin32-1.8>, [">= 2.1.0.1"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 2.3.4"])
    s.add_dependency(%q<ruby-opengl>, [">= 0.60.1"])
    s.add_dependency(%q<rmagick>, [">= 2.12.0"])
    s.add_dependency(%q<rubysdl-mswin32-1.8>, [">= 2.1.0.1"])
  end
end

