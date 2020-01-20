# Pavilion Invoices

This app manages Pavilion's invoices. It is based on [Siwapp](https://github.com/siwapp/siwapp), but has been modified significantly.

There are 4 services in the app, each with their own docker container.

1. Data. A Postgres database.

2. App. A Rails app.

3. Web. An Nginx webserver.

4. Certbot.

## Setup

The app assumes you have a ``.env`` file in the app directory. The variables in this file become environment variables in the deployed container.

As ``.env`` contains secrets, it has not been checked into Github. There is a sample file in the repository. For the production .env file, please ask Angus for a copy.

## Development

There are two ways to run this app in development, in a local docker environment, or natively.

### Native

1. Install RVM and the current ruby version the app is using (see Gemfile).

2. In the app directory, run:

     ```
     bundle install
     bundle exec rake db:setup
     rails s
     ```
     
The ``db:setup`` may fail with ``role "invoices_db_user" does not exist``. If it does run

```
psql -d postgres
create role postgres login createdb superuser;
\q
```

and try again.

### Docker

The Docker file is setup to work for a production instance. It should be relatively straightforward to create a development version of the file, e.g. remove asset pre-compilation. If you do this successfully, please commit any changes to master so others can use Docker in development if they wish.

## Deployment

The app is deployed using [docker-compose](https://docs.docker.com/compose/production/). 

### Install the machine

Docker does not yet have easy way to share "machines" between computers to allow multiple developers to deploy to the same Docker host. However, if you make changes to this app and you'd like to deploy it, there is a way:

1. Install [machine-share](https://github.com/bhurlow/machine-share).

2. Import the ``invoices`` machine using the machine config file (ask angus).

3. Run ``eval $(docker-machine env invoices)``.

### Deploy

Once you have the "invoices" docker machine setup, and the ``.env`` file in place, you can deploy your local version to production using

```
docker-compose build app
docker-compose up --no-deps -d app
```

For an explanation of these commands and their arguments [see here](https://docs.docker.com/compose/production/).

### Backups

Backups are currently done adhoc via pg_dumpall, e.g. 

```
docker-compose exec -t db pg_dumpall -c -U postgres | gzip > ~/google/pavilion/admin/invoices/backups/dump_`date +%d-%m-%Y"_"%H_%M_%S`.gz
```

An automated, chron-based solution in its own container is the next step here.

## API

See API_DOC.md
