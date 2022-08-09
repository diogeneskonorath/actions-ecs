FROM public.ecr.aws/v4t2v0o6/node:latest
ARG config_env
COPY . /usr/local/app/
WORKDIR /usr/local/app/src
COPY ./src/.docker/.env.$config_env /usr/local/app/.env
ENTRYPOINT npm start
RUN npm install


