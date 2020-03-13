# Pavilion Invoices

This app manages Pavilion's invoices. It is based on [Siwapp](https://github.com/siwapp/siwapp), but has been modified significantly.

## Development

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

Then try again.

## Deployment

The app is deployed using git and [docker-compose](https://docs.docker.com/compose/production/). 

### Setup (first deployment)

Create a server in cloud provider such as [Digital Ocean](https://digitalocean.com). Point the domain you want to use for your invoices app to your server using an A record.

SSH into your server

```
ssh root@invoices.com
```

Follow the official guides to install [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [docker-compose](https://docs.docker.com/compose/install/).

Then pull the latest version of the code into ``/var/invoices``

```
cd /var
git clone https://paviliondev/invoices.git
cd /var/invoices
```

Create your own .env from .env.sample and add values where needed

```
cp .env.sample .env
vi .env
```

Update the permissions of ``init-letsencrypt.sh``

```
chmod +x init-letsencrypt.sh
```

Update the ``domains`` and ``email`` values near the top of ``init-letsencrypt.sh``

```
vi init-letsencrypt.sh
```

Run ``init-letsencrypt.sh``

```
./init-letsencrypt.sh
```

When the script completes you should see a "Congratulations!" message and nginx starting

```
2020/03/13 05:14:18 [notice] 9#9: signal process started
```

### First deploy

Run these commands in the ``/var/invoices`` directory of your server to build and deploy. [See further here](https://docs.docker.com/compose/production/).

```
docker-compose build
docker-compose up -d
```

### Redeploy

If the invoices code is updated, pull it, re-install gems and run migrations

```
git pull
bundle install
rake db:migrate
```

Deploy the updated code using

```
docker-compose build app
docker-compose up --no-deps -d app
```

### Backups

Backups are currently done manually via pg_dumpall, e.g. 

```
docker-compose exec -t db pg_dumpall -c -U postgres | gzip > /var/backups/dump_`date +%d-%m-%Y"_"%H_%M_%S`.gz
```

## API

See API_DOC.md
