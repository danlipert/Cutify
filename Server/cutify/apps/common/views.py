from django.http import HttpResponse
from django.utils import simplejson


class InitResponse(object):
    
    def __init__(self):
        self.__data = {
            'debug': '',
            'error': '',
            'notify': '',
            'results': None,
            'success': False,
        }
    
    def __setitem__(self, key, value):
        self.__data[key] = value

    def get_data(self):
        return self.__data

def JSONResponse(response, *args, **kwargs):
        json = simplejson.dumps(response.get_data())
        return HttpResponse(content=json, mimetype='application/json', *args, **kwargs)        

def JSONErrorResponse(response, error_msg, *args, **kwargs):
        #log.error('''ERROR: %s''' % error_msg)
        response['error'] = error_msg
        response['success'] = False
        return JSONResponse(response, *args, **kwargs)
    
