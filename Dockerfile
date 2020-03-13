FROM ruby:2.6.1

ENV DEBIAN_FRONTEND noninteractive

# install ubuntu packages
RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    apt-get install apt-transport-https

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

# install Yarn for npm
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && apt install yarn

# Setting env up
ENV RAILS_ROOT=/var/www/app
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# setup folders and install gems
WORKDIR /var/www/app
COPY Gemfile* ./
RUN bundle install
COPY . .

# precompile assets
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE "$SECRET_KEY_BASE"
RUN bundle exec rake SECRET_KEY_BASE=${SECRET_KEY_BASE} assets:precompile

# add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
