# Frustum Culling is a subtle but extremely important part of your game. This class is designed to provide
# you with several methods of detecting whether a set of polygons are visible to the user; if they're not
# visible, then you can safely skip rendering them. This leads to vast increases in framerate, even if you
# do no further optimization.
#
# Ideally, you'd combine this with an OpenGl::Octree for even more efficient culling.
#
# Some of the tests made available to you by the Frustum class may return the symbol :partial instead of
# true or false. You can safely evaluate :partial to mean "true" -- but this distinction is made for highly
# optimized pieces of code that rely on whether the object is fully or partially within the Frustum. For instance,
# OpenGl::Octree uses the :partial response to determine whether to assume that all objects within the Octree
# are visible. Methods that may return :partial will return true when the object is entirely within the Frustum,
# and :partial when the object is only partially in the Frustum.
#
# You should call #update! whenever you change the OpenGL matrix (unless you don't intend to test against it)
# so that the Frustum is not out-of-date. Note that this is done automatically by the Camera class when you
# call Camera#look! -- so if you're checking against a Frustum instantiated and managed by the Camera class,
# then updating it would be redundant. Frustum#update! is an expensive call, so you want to do it as rarely
# as you can manage.
#
class OpenGl::Frustum
  include Helpers::XyzHelper
  include Geometry
  SIDES = [ :right, :left, :top, :bottom, :near, :far ]

  attr_reader :planes, :modelview

  def initialize
    @planes = { }
    @modelview = Array.new(16) { 0.0 }
    @clip = Array.new(16) { 0.0 }
    SIDES.each { |k| @planes[k] = Plane.new }
  end

  # Returns true if the specified point is in the frustum; false otherwise.
  def point_visible?(*point)
    x, y, z = radius, *xyz(*point)
    x, y, z = x.to_a if x.kind_of? Vertex3d
    planes.each { |side, plane| return false if plane.a * x + plane.b * y + plane.c * z + plane.d <= 0 }
    true
  end

  # Returns true if the specified sphere is completely within the frustum;
  # returns :partial if the sphere is only partially within the frustum;
  # returns false if the sphere is completely outside the frustum.
  def sphere_visible?(radius, *point)
    r, x, y, z = radius, *xyz(*point)
    x, y, z = x.to_a if x.kind_of? Vertex3d
    c = 0
    planes.each do |side, plane|
      return false if (d = plane.a*x + plane.b*y + plane.c*z + plane.d) <= -radius
      c += 1 if d > radius
    end
    return true if c == 6
    :partial
  end

  #
  # There are many ways to call #cube_visible? and all of them depend on just how much you know about the
  # cube in question.
  #
  # Size can be either a scalar, in which case the cube is treated as a perfect square cube, or a Vector3d,
  # in which x, y and z represent width, height and depth, respectively. These numbers should be from the
  # origin (center) of the object, so divide by two if you're working with the entire size.
  #
  # *point can be either 3 scalars, which are assumed to be position x, y, z, in which case the view, up and
  # right vectors are assumed to be (0,0,-1), (0,1,0) and (1,0,0), respectively;
  #
  # or *point can be a set of 4 Vector3d's, in which case they are expected to be:
  #
  #   origin, view_vector, up_vector, right_vector - in that order.
  #
  # The extents of the bounding box will be calculated based on these vectors and the
  # supplied size(s) by calling #bounding_box.
  #
  # Or, you can pass a set of 8 Vector3d's, in which case they are interpreted as the transformed worldspace
  # coordinates of the bounding box to be tested. This would prevent #bounding_box from being called, which
  # may be ideal if the object's transformations are not changing very often. The order of vertices in this
  # list does not matter.
  #
  # Examples:
  #   # a width, height, depth of 5, 5, 5 at world position 0,0,0
  #   1. frustum.cube_visible? 5, 0, 0, 0
  #   #
  #   # a width, height, depth of 1, 2, 3 at world position 4,5,6
  #   2. frustum.cube_visible? 1, 2, 3, 4, 5, 6
  #   #
  #   # Generates a bounding box with the following arguments, see #bounding_box(w, h, d, p, v, u, r)
  #   # note that for optimization you should really cache this yourself and update it when necessary
  #   3. frustum.cube_visible? width, height, depth, position, view, up, right
  #   #
  #   # check a preset bounding box
  #   4. frustum.cube_visible? front_top_left, front_top_right, front_bottom_left, front_bottom_right,
  #                         rear_top_left, rear_top_right, rear_bottom_left, rear_bottom_right
  #   #
  #   # check a bounding box generated by the frustum. Same as #3.
  #   5. frustum.cube_visible? frustum.bounding_box(. . .)
  # 
  # If the cube is completely within the frustum, returns true.
  # If the cube is partially within the frustum, returns :partial.
  # Else, returns false.
  #
  def cube_visible?(size, *point)
    corners = if point.length == 7 or (size.kind_of? Array and point.length == 0)
      corners = [size]
      corners.concat point
      corners.flatten!
    else
      w, h, d = (size.kind_of? Array) ? size : (size.kind_of? Vertex3d) ? size.to_a : [size, size, size]
      position, view, up, right = case point.length
        when 3 then [Vertex3d.new(*point), Vertex3d.new(0,0,-1), Vertex3d.new(0,1,0), Vertex3d.new(1,0,0)]
        else point
      end

      raise "Could not calculate width, height and depth from arguments" unless w and h and d
      raise "Could not calculate position, view, up and right vectors from arguments" unless position and view and
              up and right
      
      bounding_box(w, h, d, position, view, up, right)
    end
    raise "Could not calculate any bounding box vertices from arguments" if corners.empty?

    within = 0
    len = corners.length
    # for each plane in the frustum...
    planes.each do |side, plane|
      # ...test each corner of the bounding box, incrementing c if it's in the frustum
      c = 0
      corners.each { |v| c += 1 if plane.a * v.x + plane.b * v.y + plane.c * v.z + plane.d > 0 }
      return false if c == 0
      within += 1 if c == len
    end
    return true if within == planes.length # box is completely inside frustum
    :partial # box ix partially inside frustum
  end

  # Returns the eight points that make up a bounding box calculated from the specified
  # width, height, depth, position, view, up and right vectors (in that order).
  # This is best used to buffer the bounding box in memory so that it doesn't have to be
  # calculated every time #cube_visible? is called (which would be the default functionality).
  #
  # The view, up, and right vectors must be normalized for the results to be accurate.
  # The position vector should be in worldspace.
  # The actual width, height and depth of the bounding box will be equal to 2 times the
  # supplied width, height and depth.  
  def bounding_box(w, h, d, position, view, up, right)
    corners = []
    corners << ( view*d +  up*h + -right*w + position)    # front, top,    left
    corners << ( view*d +  up*h +  right*w + position)    # front, top,    right
    corners << ( view*d + -up*h + -right*w + position)    # front, bottom, left
    corners << ( view*d + -up*h +  right*w + position)    # front, bottom, right
    corners << (-view*d +  up*h + -right*w + position)    # rear,  top,    left
    corners << (-view*d +  up*h +  right*w + position)    # rear,  top,    right
    corners << (-view*d + -up*h + -right*w + position)    # rear,  bottom, left
    corners << (-view*d + -up*h +  right*w + position)    # rear,  bottom, right
    corners
  end

  # Returns true if the specified polygon is within the frustum, false otherwise.
  def poly_visible?(*vertices)
    planes.each do |side, plane|
      n = 0
      vertices.each do |vert|
        x, y, z = if vert.kind_of? Array then vert else [vert.x, vert.y, vert.z] end
        n += 1 and break if plane.a * x + plane.b * y + plane.c * z + plane.d > 0
      end
      return false if n == 0
    end
    true
  end

  alias polygon_visible? poly_visible?

  # Updating the Frustum is EXPENSIVE and should only be done when necessary -- but must be done
  # every time the matrix changes! (When the camera is moved, rotated, or whatever.)
  def update!
    proj, @modelview = glGetDoublev(GL_PROJECTION_MATRIX).flatten, glGetDoublev(GL_MODELVIEW_MATRIX)
    modl = self.modelview.flatten

    ## Brutally ripped from my old C++ code, then reformatted to match the new Ruby classes. Math hasn't changed.
    # I'm not huge on math, and TBH I don't really have a firm understanding of what's happening here. Somehow,
    # we are waving a magic wand and extracting the 6 planes which will represent the edges of the
    # camera's viewable area. I'll let someone who's familiar with matrices explain how that happens.
    # In any case, it works, and I have a lot of other things to do, so I just copy and paste it from
    # one 3D app to the next.
    @clip[ 0] = modl[ 0] * proj[ 0] + modl[ 1] * proj[ 4] + modl[ 2] * proj[ 8] + modl[ 3] * proj[12];
    @clip[ 1] = modl[ 0] * proj[ 1] + modl[ 1] * proj[ 5] + modl[ 2] * proj[ 9] + modl[ 3] * proj[13];
    @clip[ 2] = modl[ 0] * proj[ 2] + modl[ 1] * proj[ 6] + modl[ 2] * proj[10] + modl[ 3] * proj[14];
    @clip[ 3] = modl[ 0] * proj[ 3] + modl[ 1] * proj[ 7] + modl[ 2] * proj[11] + modl[ 3] * proj[15];

    @clip[ 4] = modl[ 4] * proj[ 0] + modl[ 5] * proj[ 4] + modl[ 6] * proj[ 8] + modl[ 7] * proj[12];
    @clip[ 5] = modl[ 4] * proj[ 1] + modl[ 5] * proj[ 5] + modl[ 6] * proj[ 9] + modl[ 7] * proj[13];
    @clip[ 6] = modl[ 4] * proj[ 2] + modl[ 5] * proj[ 6] + modl[ 6] * proj[10] + modl[ 7] * proj[14];
    @clip[ 7] = modl[ 4] * proj[ 3] + modl[ 5] * proj[ 7] + modl[ 6] * proj[11] + modl[ 7] * proj[15];

    @clip[ 8] = modl[ 8] * proj[ 0] + modl[ 9] * proj[ 4] + modl[10] * proj[ 8] + modl[11] * proj[12];
    @clip[ 9] = modl[ 8] * proj[ 1] + modl[ 9] * proj[ 5] + modl[10] * proj[ 9] + modl[11] * proj[13];
    @clip[10] = modl[ 8] * proj[ 2] + modl[ 9] * proj[ 6] + modl[10] * proj[10] + modl[11] * proj[14];
    @clip[11] = modl[ 8] * proj[ 3] + modl[ 9] * proj[ 7] + modl[10] * proj[11] + modl[11] * proj[15];

    @clip[12] = modl[12] * proj[ 0] + modl[13] * proj[ 4] + modl[14] * proj[ 8] + modl[15] * proj[12];
    @clip[13] = modl[12] * proj[ 1] + modl[13] * proj[ 5] + modl[14] * proj[ 9] + modl[15] * proj[13];
    @clip[14] = modl[12] * proj[ 2] + modl[13] * proj[ 6] + modl[14] * proj[10] + modl[15] * proj[14];
    @clip[15] = modl[12] * proj[ 3] + modl[13] * proj[ 7] + modl[14] * proj[11] + modl[15] * proj[15];

    right.a = @clip[ 3] - @clip[ 0];
    right.b = @clip[ 7] - @clip[ 4];
    right.c = @clip[11] - @clip[ 8];
    right.d = @clip[15] - @clip[12];

    left.a = @clip[ 3] + @clip[ 0];
    left.b = @clip[ 7] + @clip[ 4];
    left.c = @clip[11] + @clip[ 8];
    left.d = @clip[15] + @clip[12];

    bottom.a = @clip[ 3] + @clip[ 1];
    bottom.b = @clip[ 7] + @clip[ 5];
    bottom.c = @clip[11] + @clip[ 9];
    bottom.d = @clip[15] + @clip[13];

    top.a = @clip[ 3] - @clip[ 0];
    top.b = @clip[ 7] - @clip[ 4];
    top.c = @clip[11] - @clip[ 8];
    top.d = @clip[15] - @clip[12];

    far.a = @clip[ 3] - @clip[ 2];
    far.b = @clip[ 7] - @clip[ 6];
    far.c = @clip[11] - @clip[10];
    far.d = @clip[15] - @clip[14];

    near.a = @clip[ 3] + @clip[ 2];
    near.b = @clip[ 7] + @clip[ 6];
    near.c = @clip[11] + @clip[10];
    near.d = @clip[15] + @clip[14];

    normalize_planes!
    self
  end

  SIDES.each { |k| eval("def #{k}; @planes[#{k.inspect}]; end", binding, __FILE__, __LINE__)}

  private
  def normalize_planes!
    planes.each { |side, plane| plane.normalize! }
  end
end
