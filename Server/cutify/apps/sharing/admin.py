from django.contrib import admin
from sharing.models import SharedPhoto


class SharedPhotoAdmin(admin.ModelAdmin):

    list_display = ('long_id', 'admin_thumbnail_image', 'caption', 'views')


admin.site.register(SharedPhoto, SharedPhotoAdmin)

