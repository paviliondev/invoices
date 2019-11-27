FROM ruby:2.5.7-slim

ENV DEBIAN_FRONTEND=noninteractive
COPY . /app/
WORKDIR /app
RUN bundle config --local build.sassc --disable-march-tune-native
RUN apt-get update -qq && \
        apt-get install -y --no-install-recommends \
        build-essential git\
        libpq-dev \
        libqt5webkit5-dev \
        qt5-default xvfb curl \
	libfontconfig1 libxrender1 \
	&& curl -sL https://deb.nodesource.com/setup_10.x | sh - && apt-get install -y nodejs \
        && gem install bundler && bundle install && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        apt-get -yf remove curl build-essential libqt5webkit5-dev && apt-get autoremove -yf 

# Set /app as workdir
EXPOSE 3000

CMD /bin/sh -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
