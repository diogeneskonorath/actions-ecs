FROM public.ecr.aws/v4t2v0o6/node:latest
ARG config_env
COPY . /usr/local/app/
COPY ./src/.docker/.env.dev /usr/local/app/.env
WORKDIR /usr/local/app/src/
ENTRYPOINT npm start
RUN cd /usr/local/app/src/
RUN npm install


