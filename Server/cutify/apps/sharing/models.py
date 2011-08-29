import time
import hashlib
import random
import datetime

from django.db import models
from django.core.urlresolvers import reverse

from django.core.exceptions import ObjectDoesNotExist

from imagekit.models import ImageModel


import urlparse
from django import template
from django.conf import settings
from django.core import urlresolvers
from django.utils.safestring import mark_safe
from shorturls.baseconv import base62


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
    return "users/shared/%s.jpeg" % (generate_guid(datetime.datetime.now(), filename))


class SharedPhoto(ImageModel):

    long_id     = models.CharField(max_length=128, editable=False)

    caption     = models.CharField(max_length=64, null=True, blank=True)
    image       = models.ImageField(upload_to=upload_path, null=True, blank=True)
    checksum    = models.TextField(editable=False, null=True, blank=True)
    
    date_added  = models.DateTimeField(auto_now_add=True, editable=False)
    
    #fb_url      = models.URLField(null=True, blank=True)
    #tw_url      = models.URLField(null=True, blank=True)
    #tb_url      = models.URLField(null=True, blank=True)
    
    views       = models.PositiveIntegerField(default=0)
        
    def admin_thumbnail_image(self):
        return u'<img src="%s" />' % (self.thumbnail_image.url)
    admin_thumbnail_image.short_description = 'admin_thumbnail_image'
    admin_thumbnail_image.allow_tags = True


    def get_short_url(self):
    
        obj = self
            
        try:
            prefix = self.get_prefix(obj)
        except (AttributeError, KeyError):
            return ''
        
        tinyid = base62.from_decimal(obj.pk)
                
        if hasattr(settings, 'SHORT_BASE_URL') and settings.SHORT_BASE_URL:
            return urlparse.urljoin(settings.SHORT_BASE_URL, prefix+tinyid)
        
        try:
            return urlresolvers.reverse('shorturls.views.redirect', kwargs = {
                'prefix': prefix,
                'tiny': tinyid
            })
        except urlresolvers.NoReverseMatch:
            return ''
            
    def get_prefix(self, model):
        if not hasattr(self.__class__, '_prefixmap'):
            self.__class__._prefixmap = dict((m,p) for p,m in settings.SHORTEN_MODELS.items())
        key = '%s.%s' % (model._meta.app_label, model.__class__.__name__.lower())
        return self.__class__._prefixmap[key]

        
    
    def is_photo():
        return True
    
    class Meta:
        db_table = "shared_photos"

    class IKOptions:
        # This inner class is where we define the ImageKit options for the model
        cache_filename_format = "%(specname)s/%(filename)s.%(extension)s"
        image_field = 'image'
        spec_module = 'sharing.image_specs'
        admin_thumbnail_spec = 'admin_thumbnail'
        
        
    def get_absolute_url(self): 
        """Construct the absolute URL for this Item."""
        return reverse('view_shared', kwargs={'long_id': self.long_id})

    def get_absolute_link(self): 
        """Construct the absolute URL for this Item."""
        return "%s%s" % ("http://cutifyapp.com", reverse('view_shared', kwargs={'long_id': self.long_id}))

    def get_short_link(self): 
        """Construct the absolute URL for this Item."""
        return "%s%s" % ("http://cutifyapp.com", self.get_short_url())



    def save(self, *args, **kwargs):
        while not self.long_id:
            try:
                tid = generate_guid()
                t = self.__class__.objects.get(long_id=tid)
            except ObjectDoesNotExist:
                self.long_id = tid

        return super(SharedPhoto, self).save(*args, **kwargs)
