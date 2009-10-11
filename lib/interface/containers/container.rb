module Interface
  module Containers
    class Container < Components::Component
      attr_reader :children, :layout
      include Helpers::ContainerHelper

      def initialize(layout = nil, &blk)
        super()
        @layout = layout
        @children = [ ]
        process_block &blk if block_given?
      end

      def process_block(&blk)
        if block_given?
          ((blk.arity == 0 or blk.arity == -1) ? self.instance_eval(&blk) : (blk.call(self)))
        end
      end
      
      def layout=(l)
        @layout = l
        invalidate
      end
      
      def update(time)
        validate if not valid
        @children.each { |child| child.update(time) }
        validate if not valid #in case child invalidated on update
      end
      
      def validate
        @layout.layout_container(self) if @layout
        @children.each { |child| child.validate }
        super
      end

      def invalidate
        super
        @children.each { |child| child.invalidate } if @children
      end
      
      def paint
        @children.each { |child| child.render }
      end
      
      def add(comp, constraints="")
        comp.parent = self
        comp.invalidate
        @layout.add_layout_component(comp, constraints) if @layout
        @children <<= comp
        self.invalidate
      end
      
      def remove(comp)
        comp.parent = nil
        @layout.remove_layout_component(comp) if @layout
        @children.delete comp
        self.invalidate
      end

      def remove_all_components
        @layout.remove_all_components if @layout
        @children.clear
        self.invalidate
      end
      
      def minimum_size
        return @layout.minimum_layout_size(self) if @layout
        Dimension.new(0, 0)
      end
      
      def maximum_size
        return @layout.maximum_layout_size(self) if @layout
        Dimension.new(0, 0)
      end
      
      def preferred_size
        return @layout.preferred_layout_size(self) if @layout
        Dimension.new(0, 0)
      end

      def contains?(point)
        if super
          return true if background_visible?
          @children.each do |child|
            return true if child.contains? point
          end
        end
        false
      end
      
      def get_child_at(point)
        @children.each do |child|
          if child.contains?(point)
            return child.get_child_at(point) rescue return child
          end
        end
        nil
      end
    end
  end
end