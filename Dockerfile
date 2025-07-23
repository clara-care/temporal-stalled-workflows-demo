FROM ruby:3.3

WORKDIR /app
COPY Gemfile Gemfile.lock /app
RUN bundle install

ENTRYPOINT ["rake"]
