# GALACTO
A multi-purpose digital repository application based on [Samvera](https://samvera.org/) [Hyrax](https://github.com/samvera/hyrax).

Features a [IIIF](https://iiif.io/) manifest structure editor,
bulk import using [Bulkrax](https://github.com/samvera-labs/bulkrax), and flexible metadata using [Allinson Flex](https://github.com/samvera-labs/allinson_flex).
## Quickstart
### Lando
Starts the service dependencies in containers, but not the application server which is run 
without containerization. Good for development as it allows easier debugging and code reloading.

1. `git clone` this repository
1. Install [Docker](https://www.docker.com/) and [Lando](https://lando.dev/)
1. `lando start`
1. `bundle install`
1. `yarn install`
1. `rails db:setup`
1. `rails s`
1. [https://localhost:3000]()

### Docker Compose
Starts everything in containers.

1. `git clone` this repository
1. Install [Docker](https://www.docker.com/)
1. `docker compose up`
1. `docker compose exec app rails db:setup`
1. [https://localhost:3000]()

## Authentication
Uses the IU Login service for authentication, which requires SSL to be enabled.
In the development environment a self signed certificate is used. (See [localhost gem](https://github.com/socketry/localhost))

After logging in, an initial admin user can be set via the console:
1. `rails c` or `docker compose exec app rails c`
1. `User.first.roles << Role.find_or_create_by(name:'admin')`