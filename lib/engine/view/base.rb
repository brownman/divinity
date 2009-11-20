# A View is used solely for laying out and rendering the content to be displayed. As a rule, this means laying out and
# rendering *child* components. A View never directly modifies its own size or position; it is, instead, expected to use
# the bounds given to it to their fullest effect. For instance, views displayed at the highest level -- usually complete
# user interfaces -- will be given bounds equal to the size of the entire screen. Those views are expected to lay out
# their child components such that they utilize the entire screen.
#
# In practice, this is usually handled by Layouts so that the view need give only very general constraints. By default,
# all views are given a Border Layout, which allows the components within a view to be locked to one of the four edges
# or the center of the view.
#
# A layout can be overridden by using the "layout" keyword.
#
# Views are also charged with the task of passing on their data models to subcomponents, if this is necessary. Usually,
# this only has to be done for data which must be directly represented and changed by one of those subcomponents -- for
# example, a text field might represent a Web browser address; the view that lays out the text field is in charge of
## mapping the text field itself to the address field of the Web browser.
#
# Here is an example of a view file, rendering an imaginary Web browser interface:
#
#   panel :north do
#     layout :flow # the north panel should use a "grid" layout for its subcomponents
#     label      "Address: "
#     text_field browser, :address # map the text field to the "address" field of the browser model.
#     button     "OK"              # will fire the "button_clicked" action in the controller when clicked.
#   end
#   
#   panel :center do
#     # lay out the web page in the center of the screen
#   end
#
class Engine::View::Base
  include Helpers::ComponentHelper

  def initialize(path, locals = {})
    @path, @locals = path, locals
    load
  end

  def process(controller)
    locals = ""
    @controller = controller
    @locals.keys.each { |k| locals += "#{k} = @locals[#{k.inspect};" }
    instance_eval "#{locals}#{@content}"
  end

  private
  def load
    @content = File.read(@path)
  end
end
