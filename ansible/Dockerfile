FROM python:2.7
MAINTAINER Ros aka vortex <support@vortex.com.ru>

ADD scripts/requirements.txt /tmp/requirements.txt
RUN cd /tmp \
    && pip install -r requirements.txt
RUN mkdir /volume \
    && mkdir /ansible
ADD .dockerbuild/pass.yml /volume/pass.yml
ADD .dockerbuild/ansible.yml /ansible.yml
ADD .  /ansible
ADD .dockerbuild/id_rsa /root/.ssh/id_rsa
COPY ansible.cfg /etc/ansible/ansible.cfg
RUN chmod 644 /volume/pass.yml \
    && chmod 500 /root/.ssh/id_rsa
