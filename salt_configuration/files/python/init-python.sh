#!/bin/bash

tar xvf /root/init-python/setuptools-1.4.2.tar.gz
cd setuptools-1.4.2
python2.7 setup.py install && python2.7 -m easy_install pip && mv /root/init-python/pip-2.7 /usr/bin/
python 2.7 -m virtualenv || python2.7 -m pip install virtualenv && mv /root/init-python/virtualenv-2.7 /usr/bin/
