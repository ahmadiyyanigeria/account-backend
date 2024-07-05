FROM ubuntu:latest

RUN apt-get update
RUN apt-get install python3 python3-pip -y
RUN apt-get install -y \
    nodejs \
    npm


WORKDIR /usr/src/odoo17

RUN apt install python3.12-venv -y

RUN python3 -m venv ./env

RUN apt install python3-pip libldap2-dev libpq-dev libsasl2-dev -y

COPY requirements.txt requirements.txt
RUN ./env/bin/pip3 install --no-binary no-cache-dir -r requirements.txt

RUN npm install -g rtlcss

COPY ./entrypoint.sh /
#COPY ./config/odoo.conf /etc/odoo/
COPY . .
RUN useradd -m -s /bin/bash odoo
#RUN chown odoo /etc/odoo/odoo.conf
#RUN chown -R odoo:odoo /usr/src/odoo17

EXPOSE 8017

#ENV ODOO_RC /etc/odoo/odoo.conf

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py


USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "./env/bin/python", "odoo-bin" ]
