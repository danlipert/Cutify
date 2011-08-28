import hashlib
import logging
import os
import random
import time

from django.conf import settings


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


class Logger(object):
    
    def __init__(self, filename='kidopolis.log'):
        
        logger = logging.getLogger('basic_logger')
        hdlr = logging.FileHandler(os.path.join(settings.APP_LOG, filename))
        formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
        hdlr.setFormatter(formatter)
        logger.addHandler(hdlr)
        logger.setLevel(settings.APP_LOG_LEVEL)
        self.logger = logger

    def info(self, msg):
        self.logger.info(msg)

    def debug(self, msg):
        self.logger.debug(msg)

    def error(self, msg):
        self.logger.error(msg)
