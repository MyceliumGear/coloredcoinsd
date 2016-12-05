FROM node:6.9.1

# -p `mkpasswd -m sha-512 app`
RUN useradd -m -u 3333 -s /bin/bash -c '' -p '$6$W6YwMy6lhzN1az$pHKg1l7Nu2oxXZ3wgcnkjlQVwXcnlH93lz1YO10jEIXPkuSK6eQzhLWa40Zt3K8ZRqYiiFhyJk/mTGpQfvwbA0' app \
    && chown -R app: /home/app \
    && chmod 750 /home/app \
    && echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections \
    && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
    && apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy --no-install-recommends install \
        ca-certificates \
        locales         \
    && apt-get -qy clean autoclean autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV LANG en_US.UTF-8

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV production
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

CMD [ "npm", "start" ]
