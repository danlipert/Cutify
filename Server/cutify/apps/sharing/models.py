import time
import hashlib
import random
import datetime

from django.db import models
from django.core.urlresolvers import reverse

from django.core.exceptions import ObjectDoesNotExist

from imagekit.models import ImageModel

def generate_guid( *args ):
    """
    Generates a universally unique ID.
    Any arguments only create more randomness.
    """
    t = long( time.time() * 1000 )
    r = long( random.random()*100000000000000000L )
    try:
        a = socket.gethostbyname( socket.gethostname() )
    except:
        # if we can't get a network address, just imagine one
        a = random.random()*100000000000000000L
    data = str(t)+' '+str(r)+' '+str(a)+' '+str(args)
    data = hashlib.md5(data).hexdigest()

    return data


def upload_path(instance, filename):
    return "users/shared/%s" % (generate_guid(datetime.datetime.now(), filename))


class SharedPhoto(ImageModel):

    long_id     = models.CharField(max_length=128, editable=False)

    caption     = models.CharField(max_length=64, null=True, blank=True)
    image       = models.ImageField(upload_to=upload_path, null=True, blank=True)
    checksum    = models.TextField(null=True, blank=True)
    
    date_added  = models.DateTimeField(auto_now_add=True, editable=False)
    
    fb_url      = models.URLField(null=True, blank=True)
    tw_url      = models.URLField(null=True, blank=True)
    tb_url      = models.URLField(null=True, blank=True)
    
    views       = models.PositiveIntegerField(default=0)
    
    def is_photo():
        return True
    
    class Meta:
        db_table = "shared_photos"

    class IKOptions:
        # This inner class is where we define the ImageKit options for the model
        cache_filename_format = "%(specname)s/%(filename)s.%(extension)s"
        image_field = 'image'
        spec_module = 'sharing.image_specs'
        
        
    def get_absolute_url(self): 
        """Construct the absolute URL for this Item."""
        return reverse('view_shared', None, [self.long_id])


    def save(self, *args, **kwargs):
        while not self.long_id:
            try:
                tid = generate_guid()
                t = self.__class__.objects.get(long_id=tid)
            except ObjectDoesNotExist:
                self.long_id = tid

        return super(SharedPhoto, self).save(*args, **kwargs)
