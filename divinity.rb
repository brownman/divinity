require 'divinity_engine'
include Helpers::RenderHelper

options = YAML::load(File.read("data/config.yml")) rescue {
        :width => 800,
        :height => 600,
        :fullscreen => true
}

afps = 0.0
frames = 0
ch = 0.0
t = 0
last_tick = 0
divinity = DivinityEngine.new(options)
scene = World::Scenes::HeightMap.new(divinity, "vendor/modules/divinity/data/height_maps/test.bmp")

move_speed = 0
strafe_speed = 0
x_extent = y_extent = 0
speed = 0.25

divinity.during_render do
  glColor4f 1, 1, 1, 1
  scene.render
end

# we can use the after_render block to verify that this code runs *last*
# of course, individual after_render blocks fire in order of creation.
divinity.after_render do
  glColor4f 1, 1, 1, 1
  divinity.write(:right, :bottom, "AVG FPS: #{afps.to_i}")
  # this logic usually goes in the during_update block, but during_update only fires if the game is unpaused --
  # since the game is paused at the menu screens, it would never fire on them.
  # convert delta to seconds (it's in milliseconds atm)
  delta = ((divinity.ticks - last_tick) / 1000.0)
  last_tick = divinity.ticks
  if delta > 0 # to prevent divide-by-zero
    frames += 1.0 / delta # one frame per delta = 1/delta
    ch += 1               # one pass
    t += delta            # total change in time over ch passes
    if t >= 0.5           # update avg framerate every half-second
      afps = frames / ch  # average of frames-per-delta over the last ch passes
      ch, t, frames = 0, 0, 0
    end
  end
end

divinity.during_update do |delta|
  divinity.move! move_speed / 12.0 if move_speed != 0
  divinity.strafe! strafe_speed / 12.0 if strafe_speed != 0
  divinity.rotate_view! y_extent / 50.0, -x_extent / 50.0, 0
  
  scene.update delta unless divinity.paused?
end

divinity.after_initialize do
  divinity.pause!
  #divinity.assume_interface :main_menu
end

divinity.on :key_pressed do |evt|
  case evt.sym
    when SDL::Key::W then move_speed += speed
    when SDL::Key::S then move_speed -= speed
    when SDL::Key::A then strafe_speed -= speed
    when SDL::Key::D then strafe_speed += speed
    when SDL::Key::UP then y_extent += speed
    when SDL::Key::DOWN then y_extent -= speed
    when SDL::Key::LEFT then x_extent += speed
    when SDL::Key::RIGHT then x_extent -= speed
  end
end

divinity.on :key_released do |evt|
  case evt.sym
    when SDL::Key::W then move_speed -= speed
    when SDL::Key::S then move_speed += speed
    when SDL::Key::A then strafe_speed += speed
    when SDL::Key::D then strafe_speed -= speed
    when SDL::Key::UP then y_extent -= speed
    when SDL::Key::DOWN then y_extent += speed
    when SDL::Key::LEFT then x_extent -= speed
    when SDL::Key::RIGHT then x_extent += speed
  end
end

divinity.after_shutdown do |divinity|
  File.open("data/config.yml", "w") { |f| f.print divinity.options.to_yaml }
end

divinity.go!
  