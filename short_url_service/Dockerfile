FROM ruby:3.0-alpine

RUN apk update -qq
RUN apk add -U build-base postgresql-client postgresql-dev tzdata busybox-initscripts vips gcompat

WORKDIR /workspace
COPY . /workspace/

RUN gem install bundler
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD [ "rails", "s", "-b", "0.0.0.0" ]
