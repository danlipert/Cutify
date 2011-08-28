import datetime
import os
import traceback

from django.conf import settings

from common import Logger, generate_guid

EXCEPTION_FILE = os.path.join(settings.APP_LOG, 'kidopolis.exception.log')

log = Logger()


class DebugMiddleware(object):
    """
    Created since the views for this app can only be accessed with 
    SSL-wrapped POST (cant see the nice django 500 views in the browser
    and curl doesn't like SSL afaik
    
    """

    def process_exception(self, request, exception):
        file = open(EXCEPTION_FILE, 'a')
        file.write('\n\n%s\nEXCEPTION: %s\n' % (datetime.datetime.now(), exception))
        traceback.print_exc(file=file)
        file.close()

    def process_request(self, request):
        """
        Log all request data
        
        """
        request.session['id'] = generate_guid()
        
        log.debug(
            '''\nID: %s\n---------\nurl: %s\n---------\nRaw POST:\n%s\n---------\nRaw FILES: %s\n---------\nMETA: %s\n---------\n''' % (
                    request.session['id'],
                    request.path, 
                    request.POST,
                    request.FILES,
                    request.META
            )
        )

    def process_response(self, request, response):
        """
        Log response
        
        """
        try:
            id = request.session['id']
        except KeyError:
            id = 'No ID'
        log.debug(
            '''\nID: %s\n---------\nresponse ([status] content): [%s] %s''' % (
                id,
                response.status_code,
                response.content
            )
        )
        
        return response


class BuildResponseMiddleware(object):
    
    def process_response(self, request, response):
        """
        
        """
        if isinstance(response, JSONResponse) or isinstance(response, JSONErrorResponse):
            response.build()
        return response
