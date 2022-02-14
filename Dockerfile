FROM ruby:3.0.3-alpine3.15

ARG ROOT_APP=/familysub_bot
ARG PACKAGES="nano curl git bash screen cmake"

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES

ADD . $ROOT_APP
WORKDIR $ROOT_APP

# ENV BUNDLE_PATH /box

RUN gem install bundler:2.3.3
RUN bundle install --jobs 3

# ENV PATH=$ROOT_APP/bin:${PATH}

# EXPOSE 4567

CMD ["bash"]
# CMD bundle exec rails s -b '0.0.0.0' -p 3000