from __future__ import (absolute_import, division, print_function)
from ansible.plugins.lookup import LookupBase
from ansible.errors import AnsibleLookupError
from subprocess import Popen, PIPE
import json
import errno
import random

__metaclass__ = type

ANSIBLE_METADATA = {'metadata_version': '1.2',
                    'status': ['master'],
                    'supported_by': 'community'}

DOCUMENTATION = """
    lookup: random_mac
    author:
      - Ros aka vortex <support@vortex.com>
    version_added: "2.6"
    requirements:
      - No have
    short_description: Generate a random mac-address on lookup
    description:
      - Ansible lookup plugin 'random_mac' Generate a random mac-address on lookup that plugin directry
"""

EXAMPLES = """
- name: "Generate a random mac-address on lookup that plugin directry"
  debug:
    msg: "{{ lookup('random_mac') }}"
"""

RETURN = """
  _raw:
    description: You can just call lookup
"""

class GenerateMac(object):

    def __init__(self, path='ngmac'):
        self._cli_path = path

    @property
    def cli_path(self):
        return self._cli_path
        
    def randomMAC(self):
        mac = [ 0x00, 0x16, 0x3e,
        random.randint(0x00, 0x7f),
        random.randint(0x00, 0xff),
        random.randint(0x00, 0xff) ]
        self._generated_mac = ':'.join(map(lambda x: "%02x" % x, mac))
        return self._generated_mac
    
    @property
    def rand_mac(self):
        return self._generated_mac

    def _run(self, expected_rc=0):
        p = Popen([self.rand_mac], stdout=PIPE, stderr=PIPE, stdin=PIPE)
        out, err = p.communicate()
        rc = p.wait()
        if rc != expected_rc:
            raise AnsibleLookupError(err)
        return out, err

class LookupModule(LookupBase):

    def run(self, terms, **kwargs):
        ngmac = GenerateMac()
        values = []
        values.append(ngmac.randomMAC())
        return values