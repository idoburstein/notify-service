FROM quay.io/waynesun09/uvicorn-gunicorn:python3.9-nodejs14

LABEL maintainer="Wayne Sun <gsun@redhat.com>"

ENV PIPENV_VENV_IN_PROJECT=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    PORT=8080

WORKDIR ${APP_ROOT}/

USER 0

COPY start.sh Pipfile Pipfile.lock ./
RUN chown -R 1001:0 ${APP_ROOT} && chmod -R ug+rwx ${APP_ROOT} && \
    rpm-file-permissions

USER 1001
RUN pip install pip pipenv && \
    pipenv install --deploy --ignore-pipfile

COPY ./app ${APP_ROOT}/app
EXPOSE 8080
EXPOSE 443
CMD ["./start.sh"]
