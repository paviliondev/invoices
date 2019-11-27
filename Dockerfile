FROM ruby:2.5.7-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq
RUN apt-get install -y \
    curl \
    gnupg2
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN	apt-get install -y \
	build-essential \
	nodejs \
	libpq-dev \
	libqt5webkit5-dev \
	qt5-default \
	git \
	xvfb

WORKDIR /app

ENV BUNDLE_PATH /app
ENV GEM_PATH /app
ENV GEM_HOME /app

ADD . /app

RUN gem install bundler

COPY Gemfile Gemfile

RUN bundle install
