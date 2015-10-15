#!/usr/bin/python
from pysimplesoap.server import SoapDispatcher, SOAPHandler
from BaseHTTPServer import HTTPServer

# Test voor SELinux, zou niet moeten werken
#import os
#os.remove("/var/log/Xorg.0.log.old")
# EOT

def adder(a,b):
    "Add two values"
    return a+b

dispatcher = SoapDispatcher(
    'my_dispatcher',
    location = "http://localhost:8002/",
    action = 'http://localhost:8002/', # SOAPAction
    namespace = "http://example.com/sample.wsdl", prefix="ns0",
    trace = True,
    ns = True)

# register the user function
dispatcher.register_function('Adder', adder,
    returns={'AddResult': int}, 
    args={'a': int,'b': int})

print "Starting server..."
httpd = HTTPServer(("", 8002), SOAPHandler)
httpd.dispatcher = dispatcher
httpd.serve_forever()
