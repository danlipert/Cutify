from django.http import HttpResponse, Http404
from django.utils import simplejson
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from django.views.generic import DetailView
from django.shortcuts import get_object_or_404

from django.core.files.uploadedfile import SimpleUploadedFile

from common.views import JSONResponse, JSONErrorResponse, InitResponse
import urllib

from sharing.models import SharedPhoto

import logging
logger = logging.getLogger('cutify.lib')

'''
curl -F 'access_token=167889749949567%7C2.AQC6U_1W--byJVMp.3600.1312585200.3-100000485686813%7C8Kf2izoDhYW3xjXaVTYc4z2TbH8' -F 'message=I like spaghetti and meatballs.' https://graph.facebook.com/me/feed

curl -F 'fb_token=167889749949567%7C2.AQC6U_1W--byJVMp.3600.1312585200.3-100000485686813%7C8Kf2izoDhYW3xjXaVTYc4z2TbH8' -F 'caption=I like spaghetti and meatballs.' http://cutify.tmoa.webfactional.com/uploads/
'''




class SharedPhotoDetailView(DetailView):

    queryset = SharedPhoto.objects.all()
    template_name = "shared_photo.html"
    context_object_name = "photo"

    def get_object(self):
        # Call the superclass
        if self.kwargs['long_id']:
            object = self.get_queryset().get(long_id=self.kwargs['long_id'])
        else:
            object = self.get_queryset().order_by('?')[0]
        self.long_id = object.long_id
        object.views += 1
        object.save()
        return object

    def get_context_data(self, **kwargs):        
        # Call the base implementation first to get a context
        context = super(SharedPhotoDetailView, self).get_context_data(**kwargs)
        # Add in the publisher
        feed = list(SharedPhoto.objects.exclude(long_id=self.long_id).order_by('-date_added'))
        place_holders = []
        for i in range(0, 12 - len(feed)):
            place_holders.append(SharedPhoto())
        
        context['photo_feed'] = feed + place_holders
        
        return context



@csrf_exempt
@require_POST
def upload(request):
    
    
    response = InitResponse()
    
    if request.method == 'POST':
        logger.error("Upload request recieved.")

        # First make sure we were given some authtokens
        fb_token = request.POST.get('fb_token')
        tw_token = request.POST.get('tw_token')
        tb_token = request.POST.get('tb_token')

        

        if not fb_token:# or tw_token or tb_token):
            response['error'] = "No tokens provided"
            logger.error("Upload request failed: No tokens provided.")
            
            return JSONResponse(response)
        
        # Grab the image and caption
        message = request.POST.get('caption')


        # Create the photo object and then we can grab the url from it
        try:
            photo = SharedPhoto.objects.create(caption=message)
        except Exception as e:
            logger.error("Could not create photo object: %s" % e)
            response['error'] = "Could not create photo object: %s" % e
            return JSONResponse(response)

        
        try:
            file_contents = SimpleUploadedFile("%s.jpeg" % photo.long_id, request.raw_post_data, "image/jpeg") 
        except Exception as e:
            logger.error("Could not retrieve image from POST: %s" % e)
            response['error'] = "Could not retrieve image from POST: %s" % e
            return JSONResponse(response)

        
        try:
            photo.image.save("%s.jpeg" % photo.long_id, file_contents, True)
        except Exception as e:
            logger.error("Could not save photo: %s" % e)
            response['error'] = "Could not save photo: %s" % e            
            return JSONResponse(response)
            
        photo.save()
        link = photo.get_absolute_url()
        caption = "Cutify"
        
        # Now share the photo
        
        if fb_token:
            
            logger.error("fb: %s" % fb_token)
            
            params = urllib.urlencode({
                'access_token': fb_token, 
                'message': message,
                'link': link,
                'caption': caption
            })
            
            url = "https://graph.facebook.com/me/feed/"
            
            try:
                result = urllib.urlopen(url, params)
                html = result.read()
                logger.error("FB response: %s" % html)
                response['error'] = "FB response: %s" % html                
                
            except Exception as e:
                logger.error("Could not save to facebook: %s" % e)
                response['error'] = "Could not save to facebook: %s" % e
            
    else:
        response['error'] = "Must send image via POST"
        logger.error("Must send image via POST")
   
    return JSONResponse(response)

