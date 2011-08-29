
from django.views.generic import TemplateView


class OAuthCallbackView(TemplateView):
    
    template_name = 'callback.html'


