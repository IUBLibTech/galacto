# Galacto
A multi-purpose digital repository application based on [Samvera](https://samvera.org/) [Hyrax](https://github.com/samvera/hyrax).

Features a [IIIF](https://iiif.io/) manifest structure editor,
bulk import using [Bulkrax](https://github.com/samvera-labs/bulkrax), and flexible metadata using [Allinson Flex](https://github.com/samvera-labs/allinson_flex).
## Quickstart
### Dependencies in Docker Compose
Starts the service dependencies in containers, but not the application server or job worker, which are run 
without containerization. Good for development as it allows easier debugging and code reloading.

1. `git clone` this repository
1. Install [Docker](https://www.docker.com/)
1. `docker compose up`
1. `bundle install`
1. `yarn install`
1. `rails db:setup`
1. `sidekiq`
1. `rails s`
1. [https://localhost:3000]()

### Everything in Docker Compose
Specifying `--profile dev` when using `docker compose` will enable the containerized server and worker. 

1. `git clone` this repository
1. Install [Docker](https://www.docker.com/)
1. `docker compose --profile dev build`
1. `docker compose --profile dev up`
1. `docker compose --profile dev exec app rails db:setup`
1. [https://localhost:3000]()

## Authentication
Uses the IU Login service for authentication, which requires SSL to be enabled.
In the development environment a self-signed certificate is used. (See [localhost gem](https://github.com/socketry/localhost))

After logging in, an initial admin user can be set via the console:
1. `rails c` or `docker compose --profile dev exec app rails c`
1. `User.first.roles << Role.find_or_create_by(name:'admin')`