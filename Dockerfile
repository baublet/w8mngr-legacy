# For info on how to maintain and keep this up, https://docs.docker.com/compose/rails/

FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /w8mngr
WORKDIR /w8mngr
ADD Gemfile /w8mngr/Gemfile
ADD Gemfile.lock /w8mngr/Gemfile.lock
RUN bundle install
ADD . /w8mngr