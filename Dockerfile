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
	xvfb && \
    gem install bundler

WORKDIR /app
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install
