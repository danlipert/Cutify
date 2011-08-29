from imagekit.specs import ImageSpec 
from imagekit import processors 


# define our thumbnail resize processor 
class ResizeThumb(processors.Resize): 
    width = 60
    height = 60
    crop = False

# now lets create an adjustment processor to enhance the image at small sizes 
class EnchanceThumb(processors.Adjustment): 
    contrast = 1.2 
    sharpness = 1.1 

# now we can define our thumbnail spec 
class Thumbnail(ImageSpec): 
    access_as = 'thumbnail_image' 
    pre_cache = True
    processors = [ResizeThumb, EnchanceThumb] 

# and our display spec
class Display(ImageSpec):
    pass

class AdminThumbnail(ImageSpec): 
    access_as = 'admin_thumbnail' 
    pre_cache = True
    processors = [ResizeThumb, EnchanceThumb] 
