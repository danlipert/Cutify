import datetime, os, time

from elementtree import ElementTree

from django.conf import settings

from common import Logger

log = Logger()

type_cast = {
    'string' : lambda val: val,
    'integer': lambda val: int(val),
    'real': lambda val: float(val),
    'date': lambda val: time.strftime("%Y-%m-%d %H:%M:%S", time.strptime(val, r"%Y-%m-%dT%H:%M:%SZ")),
}


def save_plist(data):
    
    f2 = open(os.path.join(settings.APP_LOG, '%s.plist' % str(datetime.datetime.now())), 'w')
    f2.write(data)
    f2.close()


def process_plist(in_memory_file):
    
    tree = ElementTree.parse(in_memory_file)
    plist = tree.getroot()
    save_plist(ElementTree.tostring(plist))
    
    return xmldict_to_pydict(plist[0])


def xmldict_to_pydict(xml):

    # I want a dict!
    if not xml.tag == 'dict':
        raise Exception
    
    result = {}
    
    for i in range(0, len(xml) / 2):
    
        key_index = i * 2
        val_index = key_index + 1
        
        if not xml[key_index].tag == 'key':
            raise Exception
        
        # Arrays are special
        if xml[val_index].tag == 'array':

            xml_array = xml[val_index]

            py_array = []
            
            for item in xml_array:
                
                if item.tag == 'dict':
                    py_array.append(xmldict_to_pydict(item))
                else:
                    tc_func = type_cast[item.tag]
                    py_array.append(tc_func(item.text))
                
            result[xml[key_index].text] = py_array
            
        else:
            tc_func = type_cast[xml[val_index].tag]
            result[xml[key_index].text] = tc_func(xml[val_index].text)

    log.debug("\n-------\n%s\n-----------------------------------\n" % str(result))

    return result
