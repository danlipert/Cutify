from django.http import HttpResponse, Http404
from django.utils import simplejson
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from django.views.generic import DetailView
from django.shortcuts import get_object_or_404

from django.core.files.uploadedfile import SimpleUploadedFile

import urllib

import oauth2 as oauth
import time
import httplib

import re

from django.utils import simplejson

from sharing.models import SharedPhoto

from django.conf import settings

import logging
logger = logging.getLogger('cutify.lib')


# Twitter Constants
TWITTER_SERVER = "api.twitter.com"

TWITTER_CONSUMER_KEY = 'fA287REcKRordUPbqUcxA'
TWITTER_CONSUMER_SECRET  = 'TEjsunwlAvjwBEMqNqHuSjCINx7kIntSL0LD70dm8'

TWITTER_CHECK_AUTH = 'https://twitter.com/account/verify_credentials.json'
TWITTER_UPDATE_STATUS = 'https://twitter.com/statuses/update.json'

# Tumblr Constants
TUMBLR_SERVER = "api.tumblr.com"

TUMBLR_CONSUMER_KEY = 'd3ZRH6gNJM7xyB9Z1rFdLokWqPYUsRFF3cjvWB1RI5l617NAKa'
TUMBLR_CONSUMER_SECRET = 'JGyEmR4G6jiUtbI3s2O8wCwIDIdIQWFlTctJrHIbIPtOfXctS6'


# Other constants
CUTIFY_PHOTO_LINK_NAME = "Another cutify creation!"
CUTIFY_APP_DESCRIPTION = """
Add cute and expressive faces to objects in your photo with 
the ultimate purikura and anthropomorphization mashup.
"""


def tumblr_get_userinfo(token, token_secret):

    token = oauth.Token(key=token, secret=token_secret)
    consumer = oauth.Consumer(key=TUMBLR_CONSUMER_KEY, secret=TUMBLR_CONSUMER_SECRET)
    
    client = oauth.Client(consumer, token)
    resp, content = client.request('http://api.tumblr.com/v2/user/info', 'POST')

    json_data = simplejson.loads(content)
    
    if (json_data.has_key('meta') and json_data['meta'].has_key('status') and json_data['meta']['status'] == 200):
        primary_blog_url = None
        blogs = json_data['response']['user']['blogs']
        for b in blogs:
            if b['primary'] == True:
                primary_blog_url = b['url']
                break
        if primary_blog_url:
            return re.search("http://(?P<base>[\w\.]+)/", primary_blog_url).groups()[0]
        return None

def tumblr_post_link(token, token_secret, photo_link, caption):

    blog_url = tumblr_get_userinfo(token, token_secret)
    post_url = "http://api.tumblr.com/v2/blog/%s/post" % blog_url

    token = oauth.Token(key=token, secret=token_secret)
    consumer = oauth.Consumer(key=TUMBLR_CONSUMER_KEY, secret=TUMBLR_CONSUMER_SECRET)
        
    client = oauth.Client(consumer, token)

    parms = urllib.urlencode({
        'type': 'link',
        'tags': 'cutify,cute faces',
        'title': caption,
        'url': photo_link,
        'description': CUTIFY_APP_DESCRIPTION,
    })

    resp, content = client.request(post_url, 'POST', parms)

    #json_data = simplejson.loads(content)
    
    return content



def twitter_post_link(token, token_secret, photo_link, caption):

    post_url = "https://twitter.com/statuses/update.json"

    token = oauth.Token(key=token, secret=token_secret)
    consumer = oauth.Consumer(key=TWITTER_CONSUMER_KEY, secret=TWITTER_CONSUMER_SECRET)
    
    client = oauth.Client(consumer, token)

    # "Holler" len = 6, r is at index 5 
    # "Holler #yeah" # is at 7 ie len + 1

    tweet = "%s %s" % (caption, photo_link)
    tweet_len = len(tweet)
    tweet = "%s #cutify" % tweet

    parms = urllib.urlencode({
        'status': tweet,
        'include_entities ': 'true',
        'entities': {
            'hashtags': {
                'text': 'cutify', 
                'indices': (tweet_len + 1, tweet_len + 7,)
            },
        }
    })

    resp, content = client.request(post_url, 'POST', parms)

    #json_data = simplejson.loads(content)
    
    return content


def facebook_post_link(token, photo_link, caption):

    post_url = "https://graph.facebook.com/me/feed/"

    params = urllib.urlencode({
        'access_token': token, 
        'message': caption,
        'link': photo_link,
        'name' : CUTIFY_PHOTO_LINK_NAME, # The name of the link
        'caption': 'Cutify', # The caption of the link (appears beneath the link name)
        'description': CUTIFY_APP_DESCRIPTION, # A description of the link (appears beneath the link caption)
    })
    
    response = ""

    try:
        result = urllib.urlopen(post_url, params)
        response = result.read()    
    except Exception as e:
        response = "Could not save to facebook: %s" % e

    #json_data = simplejson.loads(content)
    
    return response


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
        
            try:
                object = self.get_queryset().get(long_id=self.kwargs['long_id'])
            except SharedPhoto.DoesNotExist:
                raise Http404

        else:
            try:
                object = self.get_queryset().order_by('?')[0]
            except IndexError:
                raise Http404

        self.long_id = object.long_id
        object.views += 1
        object.save()
        return object

    def get_context_data(self, **kwargs):        
        # Call the base implementation first to get a context
        context = super(SharedPhotoDetailView, self).get_context_data(**kwargs)
        # Add in the publisher
        feed = list(SharedPhoto.objects.exclude(long_id=self.long_id).order_by('-date_added')[:12])
        place_holders = []
        for i in range(0, 12 - len(feed)):
            place_holders.append(SharedPhoto())
        
        context['photo_feed'] = feed + place_holders
        
        return context





def JSONResponse(response, *args, **kwargs):
    json = simplejson.dumps(response.get_data())
    return HttpResponse(content=json, mimetype='application/json', *args, **kwargs)        


@csrf_exempt
@require_POST
def upload(request):
    
    
    response = {
            'debug': '',
            'error': '',
            'notify': '',
            'results': None,
            'success': False,
        }
    
    if request.method == 'POST':
        logger.error("Upload request recieved")

        # First make sure we were given some authtokens
        facebook_token = request.POST.get('facebook_access_token')
        twitter_token = request.POST.get('twitter_oauth_token')
        twitter_token_secret = request.POST.get('twitter_oauth_token_secret')
        tumblr_token = request.POST.get('tumblr_oauth_token')
        tumblr_token_secret = request.POST.get('tumblr_oauth_token_secret')
        photo_caption = request.POST.get('photo_caption')
        
        if not photo_caption or photo_caption == "None": photo_caption = CUTIFY_PHOTO_LINK_NAME
        
        logger.error("Caption is %s" % photo_caption)

        if not (facebook_token or twitter_token or tumblr_token):
            response['error'] = "No tokens provided"
            logger.error("Upload request failed: No tokens provided.")
            
            return JSONResponse(response)
        
        # Create the photo object and then we can grab the url from it
        try:
            photo = SharedPhoto.objects.create(caption=photo_caption)
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
        photo_link = photo.get_short_link()

        # Now share the photo
        
        if facebook_token:
            
            logger.error("fb: %s" % facebook_token)

            try:
                facebook_response = facebook_post_link(facebook_token, photo_link, photo_caption)
                response['error'] = "Facebook Response: %s" % facebook_response 
                logger.error("Facebook Response: %s" % facebook_response )      
                
            except Exception as e:
                logger.error("Could not save to facebook: %s" % e)
                response['error'] = "Could not save to facebook: %s" % e
                
        if twitter_token and twitter_token_secret:
            
            logger.error("tw: %s" % twitter_token)
            try:
                twitter_response = twitter_post_link(twitter_token, twitter_token_secret, photo_link, photo_caption)
                response['error'] = "Twitter Response: %s" % twitter_response
                logger.error("Twitter Response: %s" % twitter_response)
            except Exception as e:
                response['error'] = "Twitter Error: %s" % e
                logger.error("Twitter Error: %s" % e)
        

        if tumblr_token and tumblr_token_secret:
            
            logger.error("tu: %s" % tumblr_token)
            
            try:
                tumblr_response = tumblr_post_link(tumblr_token, tumblr_token_secret, photo_link, photo_caption)
                response['error'] = "Tumblr Response: %s" % tumblr_response
                logger.error("Tumblr Response: %s" % tumblr_response)
            except Exception as e:
                response['error'] = "Tumblr Error: %s" % e
                logger.error("Tumblr Error: %s" % e)

    else:
        response['error'] = "Must send image via POST"
        logger.error("Must send image via POST")
   
    return JSONResponse(response)

