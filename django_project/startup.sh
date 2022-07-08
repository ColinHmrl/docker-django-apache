#!/usr/bin/env bash

PROJECT_DIR="$(printenv PROJECT_DIR)"
PROJECT_NAME="$(printenv PROJECT_NAME)"
DJANGO_CONFIG="$(printenv DJANGO_CONFIG)"
DJANGO_ADMIN_USERNAME="$(printenv DJANGO_ADMIN_USERNAME)"
DJANGO_ADMIN_PASSWORD="$(printenv DJANGO_ADMIN_PASSWORD)"

mkdir -p ${PROJECT_DIR}/${PROJECT_NAME}

cp ${PROJECT_DIR}/${PROJECT_NAME}/django-apache.conf /etc/apache2/sites-available/000-default.conf

python3 -m venv ${PROJECT_DIR}/venv
${PROJECT_DIR}/venv/bin/pip install --no-cache-dir -r ${PROJECT_DIR}/${PROJECT_NAME}/requirements.txt


${PROJECT_DIR}/venv/bin/python3 ${PROJECT_DIR}/${PROJECT_NAME}/manage.py makemigrations --settings=${DJANGO_CONFIG}
${PROJECT_DIR}/venv/bin/python3 ${PROJECT_DIR}/${PROJECT_NAME}/manage.py migrate --settings=${DJANGO_CONFIG}
${PROJECT_DIR}/venv/bin/python3 ${PROJECT_DIR}/${PROJECT_NAME}/manage.py collectstatic --noinput --settings=${DJANGO_CONFIG}

echo "from django.contrib.auth.models import User; User.objects.create_superuser('${DJANGO_ADMIN_USERNAME}', '', '${DJANGO_ADMIN_PASSWORD}')" | ${PROJECT_DIR}/venv/bin/python3 ${PROJECT_DIR}/${PROJECT_NAME}/manage.py shell --settings=${DJANGO_CONFIG}

sudo apache2ctl -D FOREGROUND