class Textures::Texture
  include Helpers::RenderHelper
  include Magick
  include ::Geometry

  attr_reader :id, :mipmap, :image
  protected :image

  def bytes_per_pixel; image.depth / 8 end
  def width; image.columns end
  def height; image.rows end
  def image_data; image.to_blob { self.format = 'RGBA' } end

  def mipmap=(a)
    @mipmap = a
    free_resources
    @mipmap
  end
 def image=(a)
    @image = a
    free_resources
    @image
  end

  def initialize(image_or_path_to_image = nil)
    @mipmap = true # majority of textures will be mipmapped.
    
    if image_or_path_to_image
      @path, image = if image_or_path_to_image.kind_of? Magick::Image or image_or_path_to_image.kind_of? Magick::ImageList
        [image_or_path_to_image.filename, image_or_path_to_image]
      else [image_or_path_to_image, Magick::ImageList.new(image_or_path_to_image) ]
      end
      @path = image.hash if @path.blank?
      @image = image
    end

    @id = -1
    @bound = false
  end
  
  def bind
    if id.nil? or id == -1
      @id = glGenTextures(1)[0]
      glEnable(GL_TEXTURE_2D)
      glBindTexture(GL_TEXTURE_2D, id)
      if mipmap
        glTexImage2D(GL_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
        gluBuild2DMipmaps(GL_TEXTURE_2D, 4, width, height, GL_RGBA, GL_UNSIGNED_BYTE, image_data)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
        glEnable(GL_TEXTURE_2D)
      else
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
        glTexImage2D(GL_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data)
      end
    end
    @bound = id
    glBindTexture(GL_TEXTURE_2D, id)
    if block_given?
      yield
      unbind
    end
  end
  
  def unbind
    #This will get used when multitexturing is eventually implemented
    @bound = false
  end
  
  def coord2f(x, y)
    glTexCoord2f(x, y)#-y)
  end
  
  def bound?
    @bound != false
  end

  def free_resources
    glDeleteTextures(id) if id and id != -1
    @id = -1
    @bound = false
  end

  def min_filter; GL_LINEAR_MIPMAP_NEAREST; end
  def mag_filter; GL_LINEAR; end
end
