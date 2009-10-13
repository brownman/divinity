class Interface::Components::TextArea < Interface::Components::InputComponent
  theme_selection :text
  attr_reader :font_options, :padding
  attr_accessor :color
  attr_accessor :caret_position
  attr_accessor :read_only

  include Listeners::KeyListener
  include Listeners::MouseListener

  def initialize(object, method, options = {}, &block)
    @font_options = {}
    @caret_position = 0
    @padding = 4
    @scroll = 0
    @read_only = true
    super(object, method, options)

    key_listeners << self
    mouse_listeners << self
    @last_value = self.value

    yield if block_given?
  end

  def update(delta)
    super
    if self.value != @last_value
      @scroll = 0
      move_caret self.value.length - @caret_position # force to bottom
      @last_avlue = self.value
    end
  end

  def mouse_pressed(evt)
    if evt.button == 4 # TODO: Make these constants somewhere. 4 is wheelup, 5 is wheeldown.
      move_caret_vertical(-1)
      @scroll -= Font.select.height
      check_caret_scroll
    elsif evt.button == 5
      move_caret_vertical(1)
      @scroll += Font.select.height
      check_caret_scroll
    end
  end

  def key_pressed(evt)
    return if read_only
    case evt.sym
      when SDL::Key::UP    then move_caret_vertical(-1)
      when SDL::Key::DOWN  then move_caret_vertical(1)
      when SDL::Key::LEFT  then move_caret -1
      when SDL::Key::RIGHT then move_caret 1
      when SDL::Key::ESCAPE
      when SDL::Key::BACKSPACE
        unless self.value.blank?
          backspace!
          move_caret -1
        end
      when SDL::Key::HOME then move_caret -@caret_position
      when SDL::Key::END  then move_caret self.value.length - @caret_position
      when SDL::Key::RETURN
        self.value.insert(@caret_position, "\n")
        move_caret 1
      else
        if evt.unicode != 0
          case evt.unicode
            when 0
            else
              self.value.insert(@caret_position, evt.unicode.chr)
              move_caret 1
          end
        end
    end
  end

  def move_caret_vertical(amount)
    x, y = pixel_position(@caret_position)
    move_caret offset_from_pixel(x, y + Font.select.height*amount) - @caret_position
  end

  def move_caret(amount)
    @caret_position += amount
    @caret_position = self.value.length if @caret_position > self.value.length
    @caret_position = 0 if @caret_position < 0

    check_caret_scroll
  end

  def check_caret_scroll
    y = pixel_position(@caret_position)[1]

    if y - @scroll < 0 # caret is above the top of the viewable area
      @scroll -= Font.select.height
    elsif y + Font.select.height - @scroll > height - ((border_size + padding) * 2) # caret is below the bottom of the viewable area
      @scroll += Font.select.height
    end
  end

  def paint
    self.value = self.value.to_s unless self.value.kind_of? String
    paint_background
    glColor4fv(foreground_color)
    topmost = border_size + padding
    leftmost = border_size + padding
    rightmost = width - ((border_size + padding) * 2)
    bottommost = height - ((border_size + padding) * 2)
    b = screen_bounds

    scissor b.x+leftmost, frame_manager.height - (b.y + b.height - border_size - padding), rightmost,
            b.height+1-(border_size+padding)*2 do
      push_matrix do
        glTranslated(leftmost, -@scroll + topmost, 0)
        render_text
        render_caret if Interface::GUI.focus == self
      end
      glColor4f(1,1,1,1)
    end
  end

  def render_text
    font = Font.select
    maxwidth = width - ((border_size + padding) * 2)
    height = Font.select.height
    push_matrix do
      value_as_lines.each do |line|
        Font.select.put(0, 0, line)
        glTranslated(0, height, 0)
      end
    end
  end

  def value_as_lines
    lines = []
    font = Font.select
    maxwidth = width - ((border_size + padding) * 2)
    value.split(/\n/).each do |line|
      if font.sizeof(line).width < maxwidth
        lines << line
      else
        line_to_render = ""
        line.split(/\s/).each do |word|
          x = font.sizeof(line_to_render).width
          len = font.sizeof(word).width
          if x+len < maxwidth
            line_to_render.concat " #{word}"
            line_to_render.strip!
          else
            lines << line_to_render
            line_to_render = word
          end
        end
        lines << line_to_render unless line_to_render.blank?
      end
    end
    lines
  end

  def pixel_position(offset)
    # first we need to compensate for new lines
#    offset = offset - value[0...offset].count("\n")
    
    len = 0
    x, y = 0, 0
    font = Font.select
    value_as_lines.each do |line|
      l = line.length
      l += 1 # for the \n
      if len+l-1 < offset
        len += l
        y += font.height
      else
        diff = offset - len
        if diff == 0
          x = 0
        else
          x = font.sizeof(line[0...diff]).width
        end
        break
      end
    end
    [x,y]
  end

  def offset_from_pixel(x, y)
    offset = 0
    font = Font.select
    ly = 0

    value_as_lines.each do |line|
      l = line.length
      l += 1 # for the \n
      if ly < y
        offset += l
        ly += font.height
      else 
        w = 0
        line.each_byte do |char|
          w += font.sizeof(char.chr).width
          break if w > x
          offset += 1
        end
        break
      end
    end
    offset = value.length if offset > value.length
    offset
  end

  def backspace!
    offset = @caret_position

    left = (offset > 0) ? self.value[0...(offset-1)] : ""
    right = self.value[offset..-1]
    self.value = left + right
  end

  def render_caret
    return if read_only
    x, y = pixel_position(@caret_position)
    glColor4fv(color)
    glDisable(GL_TEXTURE_2D)
    glBegin(GL_LINES)
      glVertex2i(x, y)
      glVertex2i(x, y + Font.select.height)
    glEnd
    glEnable(GL_TEXTURE_2D)
  end

  def minimum_size; Dimension.new(1,1) end
  def maximum_size; Dimension.new(1024,1024) end
  def preferred_size; Dimension.new(200,100) end
end
