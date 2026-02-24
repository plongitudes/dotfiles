#!/usr/bin/env python

import ipdb
import sys

# from pprint import pprint as pp
from loguru import logger as log

log.add(sys.stderr, format="{time} {level} {message}", filter="*", level="DEBUG")

print("-------globals-------")
log.debug(globals())
print("-------locals--------")
log.info(locals())

ipdb.set_trace()
