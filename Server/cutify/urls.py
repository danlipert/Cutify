from django.conf.urls.defaults import patterns, include, url

from django.conf import settings

from django.contrib import admin
admin.autodiscover()

#from tmoa.views import HomeView, ContactView

from sharing.views import SharedPhotoDetailView

urlpatterns = patterns('',
    # Examples:
    #url(r'^$', HomeView.as_view(), name='home'),
    
    url(r'^uploads/$', 'sharing.views.upload', name='upload_shared'),
    url(r'^(?P<long_id>\w*)$', SharedPhotoDetailView.as_view(), name='view_shared'),

    # url(r'^tmoa/', include('tmoa.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)

if settings.DEBUG == True:
    urlpatterns += patterns('',
        #url(r'^404/$', direct_to_template, {'template': '404.html'}),
        #url(r'^500/$', direct_to_template, {'template': '500.html'}),
        #url(r'^503/$', direct_to_template, {'template': '503.html'}),
        (r'^media/(?P<path>.*)$', 'django.views.static.serve',
            {'document_root': settings.MEDIA_ROOT}),
    )
