module Interface
  module Layouts
    class BorderLayout < Layout
      attr_accessor :hgap, :vgap

      include Geometry

      def initialize(hgap=2, vgap=2)
        super()
        @north = @south = @east = @west = @center = nil
        @hgap = hgap
        @vgap = vgap
      end
    
      def get_constraints(comp)
        case comp
          when @north  then "north"
          when @south  then "south"
          when @east   then "east"
          when @west   then "west"
          when @center then "center"
          else ""
        end
      end
    
      def add_layout_component(comp, name="")
        name = name.to_s if name.kind_of? Symbol
        name.downcase!
        valid_constraints = [ "center", "north", "south", "east", "west" ]
        case name
          when *valid_constraints
            ret = self.instance_variable_get("@#{name}")
            self.instance_variable_set("@#{name}", comp)
            ret.parent = nil if ret
            ret
          else
            raise "Invalid constraints: #{name.inspect}; expected one of #{valid_constraints.inspect}"
        end
      end

      def remove_all_components
        [ :center, :north, :south, :east, :west ].each do |a|
          r = add_layout_component(nil, a)
          r.parent = nil if r.respond_to? "parent="
        end
      end
    
      def remove_layout_component(comp)
        case comp
          when @north then @north = nil
          when @south then @south = nil
          when @east then @east = nil
          when @west then @west = nil
          when @center then @center = nil
        end
      end
    
      def layout_container(cont)
        #bool ltr = true  #TODO: Make this do stuff.
        buf = cont.insets.dup

        buf.x, buf.y = 0, 0
        nx = (@west ? 1 : 0) + (@center ? 1 : 0) + (@east ? 1 : 0)
        ny = (@north ? 1 : 0) + (@center ? 1 : 0) + (@south ? 1 : 0)
        mx = (buf.width  - (@hgap * (nx-1))) / nx
        my = (buf.height - (@vgap * (ny-1))) / ny
        #buf = Rectangle.new(border_size, border_size, cont.bounds.width-border_size, cont.bounds.height-border_size)

        if @north
          b = @north.preferred_size
          h = min(b.height, my)
          @north.bounds = Rectangle.new(buf.x, buf.y, buf.width - buf.x, h)
          buf.y += h + @vgap
        end
        if @south
          b = @south.preferred_size
          h = min(b.height, my)
          @south.bounds = Rectangle.new(buf.x, buf.height - h, buf.width - buf.x, h)
          buf.height -= h + @vgap
        end
        if @east
          b = @east.preferred_size
          w = min(b.width, mx)
          @east.bounds = Rectangle.new(buf.width - w, buf.y, w, buf.height - buf.y)
          buf.width -= w + @hgap
        end
        if @west
          b = @west.preferred_size
          w = min(b.width, mx)
          @west.bounds = Rectangle.new(buf.x, buf.y, w, buf.height - buf.y)
          buf.x += w + @hgap
        end
        if @center
          @center.bounds = Rectangle.new(buf.x, buf.y, buf.width - buf.x, buf.height - buf.y)
        end

        [@north, @south, @east, @west, @center].each do |comp|
          raise "No room to lay out component #{comp} in container #{cont} (insets #{cont.insets.inspect})" if comp and
                  (comp.bounds.width == 0 or comp.bounds.height == 0)
        end
      end
    
      protected
      def layout_size(cont, &blk)
        dim = Dimension.new

        #bool ltr = true #TODO: Make this work.
        [@east, @west].each do |comp|
          if not comp.nil?
            d = yield(comp)
            dim.width += d.width + @hgap
            dim.height = max(d.height, dim.height)
          end
        end
        if not @center.nil?
          d = yield(@center)
          dim.width += d.width
          dim.height = max(d.height, dim.height)
        end
        [@north, @south].each do |comp|
          if not comp.nil?
            d = yield(comp)
            dim.width = max(d.width, dim.width)# + (cont.border_size*2)
            dim.height += d.height + @vgap# + (cont.border_size*2)
          end
        end
        dim.width = 64 if dim.width == 0
        dim.height = 64 if dim.height == 0
        return dim
      end
      
      private
      def max(a, b); a > b ? a : b; end
      def min(a, b); a > b ? b : a; end
    end
  end
end