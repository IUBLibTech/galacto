ARG ALPINE_VERSION=3.21
ARG RUBY_VERSION=3.3.7

FROM ruby:$RUBY_VERSION-alpine$ALPINE_VERSION AS hyrax-base

ARG DATABASE_APK_PACKAGE="postgresql-dev"
ARG EXTRA_APK_PACKAGES="git"
ARG RUBYGEMS_VERSION=""
ARG USER_ID=1000
ARG GROUP_ID=1000


RUN addgroup -S -g $GROUP_ID galacto && \
  adduser -S -G galacto -u $USER_ID -s /bin/sh -h /app galacto

RUN apk --no-cache upgrade && \
  apk --no-cache add acl \
  bash \
  build-base \
  curl \
  gcompat \
  imagemagick \
  imagemagick-heic \
  imagemagick-jpeg \
  imagemagick-jxl \
  imagemagick-pdf \
  imagemagick-svg \
  imagemagick-tiff \
  imagemagick-webp \
  jemalloc \
  ruby-grpc \
  tzdata \
  nodejs \
  yarn \
  zip \
  $DATABASE_APK_PACKAGE \
  $EXTRA_APK_PACKAGES

RUN setfacl -d -m o::rwx /usr/local/bundle && \
  gem update --silent --system $RUBYGEMS_VERSION

USER galacto

RUN mkdir -p /app
RUN mkdir -p /app/bin
WORKDIR /app

COPY --chown=$USER_ID:$GROUP_ID ./bin/*.sh ./bin
ENV PATH="/app/bin:$PATH" \
    RAILS_ROOT="/app" \
    RAILS_SERVE_STATIC_FILES="1" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

ENTRYPOINT ["hyrax-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]


FROM hyrax-base AS hyrax

ARG APP_PATH=.
ARG BUNDLE_WITHOUT="development test"

ONBUILD COPY --chown=$USER_ID:$GROUP_ID $APP_PATH /app
ONBUILD RUN bundle install --jobs "$(nproc)"
ONBUILD RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rails secret` DATABASE_URL='nulldb://nulldb' bundle exec rake assets:precompile
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]

FROM hyrax-base AS hyrax-worker-base

USER root
RUN apk --no-cache add bash \
  ffmpeg \
  mediainfo \
  openjdk17-jre \
  perl
USER galacto

RUN mkdir -p /app/fits && \
    cd /app/fits && \
    wget https://github.com/harvard-lts/fits/releases/download/1.6.0/fits-1.6.0.zip -O fits.zip && \
    unzip fits.zip && \
    rm fits.zip tools/mediainfo/linux/libmediainfo.so.0 tools/mediainfo/linux/libzen.so.0 && \
    chmod a+x /app/fits/fits.sh && \
    sed -i 's/\(<tool.*TikaTool.*>\)/<!--\1-->/' /app/fits/xml/fits.xml
ENV PATH="${PATH}:/app/fits"

CMD ["bundle", "exec", "sidekiq"]


FROM hyrax-worker-base AS hyrax-worker

ARG APP_PATH=.
ARG BUNDLE_WITHOUT="development test"

ONBUILD COPY --chown=$USER_ID:$GROUP_ID $APP_PATH /app
ONBUILD RUN bundle install --jobs "$(nproc)"
ONBUILD RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rails secret` DATABASE_URL='nulldb://nulldb' bundle exec rake assets:precompile

FROM hyrax-worker-base AS galacto-dev

USER galacto
ARG BUNDLE_WITHOUT=
ARG APP_PATH=.
COPY --chown=$USER_ID:$GROUP_ID $APP_PATH /app

RUN bundle -v && \
  bundle install --jobs "$(nproc)" && yarn && \
  yarn cache clean

ENTRYPOINT ["dev-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]