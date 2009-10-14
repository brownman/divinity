class Interface::Components::TextField < Interface::Components::InputComponent
  theme_selection :text
  attr_reader :font_options, :padding, :printable_area
  attr_accessor :color
  attr_accessor :caret_position

  include Listeners::KeyListener

  def initialize(object, method, options = {}, &block)
    @font_options = {}
    @caret_position = 0
    @padding = 4
    @scroll = 0
    super(object, method, options)

    key_listeners << self

    @printable_area = Rectangle.new
    yield if block_given?
  end

  def validate
    super
    @printable_area = insets.dup
  end

  def key_pressed(evt)
    case evt.sym
      when SDL::Key::UP
      when SDL::Key::DOWN
      when SDL::Key::LEFT  then move_caret -1
      when SDL::Key::RIGHT then move_caret 1
      when SDL::Key::ESCAPE
      when SDL::Key::BACKSPACE
        unless self.value.blank?
          left = (@caret_position > 0) ? self.value[0...(@caret_position-1)] : ""
          right = self.value[@caret_position..-1]
          self.value = left + right
          move_caret -1
        end
      when SDL::Key::HOME then move_caret -@caret_position
      when SDL::Key::END  then move_caret self.value.length - @caret_position
      when SDL::Key::RETURN
        # No enter key accepted here
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

  def move_caret(amount)
    @caret_position += amount
    @caret_position = self.value.length if @caret_position > self.value.length
    @caret_position = 0 if @caret_position < 0

    check_caret_scroll
  end

  def check_caret_scroll
    if Font.select.sizeof(@value[0...@caret_position]).width - @scroll < 0
      @scroll -= Font.select.max_glyph_size.width
      @scroll = 0 if @scroll < 0
      check_caret_scroll
    end

    if Font.select.sizeof(@value[0...@caret_position]).width - @scroll > width - ((border_size + padding) * 2)
      @scroll += Font.select.max_glyph_size.width
      if @scroll > Font.select.sizeof(@value[0...@caret_position]).width
        @scroll = Font.select.sizeof(@value[0...@caret_position]).width
      end
      check_caret_scroll
    end
  end

  def paint
    glTranslated(-@scroll + 1, 0, 0)
    paint_text
    paint_cursor
  end

  def paint_text
    Font.select.put(0, (printable_area.height / 2) - (size.height / 2), value)
  end

  def paint_cursor
    return unless Interface::GUI.focus == self
    s = Font.select(font_options).sizeof(value[0...caret_position])
    x = s.width
    glColor4fv(foreground_color)
    glDisable(GL_TEXTURE_2D)
    glBegin(GL_LINES)
      glVertex2i(x, (printable_area.height / 2) - (font.height / 2))
      glVertex2i(x, (printable_area.height / 2) - (font.height / 2) + font.height)
    glEnd
    glEnable(GL_TEXTURE_2D)
  end

  def size
    #self.value = self.value.to_s unless self.value.kind_of? String
    Font.select(font_options).sizeof(value)
  end

  def minimum_size; size end
  def maximum_size; size end
  def preferred_size; size end
end
