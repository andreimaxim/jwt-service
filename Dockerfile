FROM jruby:9.1.12.0

# The home directory of the application.
#
# During development, make sure that the APP_DIR environment variable is
# identical to the variable in your .env file, otherwise things might fail.
ENV APP_DIR="/opt/token-app"

# Install the same version of bundler as Heroku is using. Also, perform this
# as root otherwise there will be some permission issues.
RUN gem install bundler -v 1.15.1

# Create a non-root user
RUN groupadd -r app \
    && useradd -m -r -g app app
    && mkdir -p ${APP_DIR} \
    && chown -R app:app ${APP_DIR}

USER app

# Move to the application directory in the container.
#
# This has to be set as a volume in the docker-compose.yml file otherwise
# things might fail.
WORKDIR ${APP_DIR}

# Copy the Gemfile and Gemfile.lock files so `bundle install` can run when the
# container is initialized.
#
# The added benefit is that Docker will cache this file and will not trigger
# the bundle install unless the Gemfile changed on the filesystem.
COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 5 --path ${HOME}/.bundle --binstubs

# Copy over the files, in case the Docker Compose file does not specify a
# mount point.
COPY . .

# Setup the Rails app to run when the container is created, using the CMD as
# extra params that can be overriden via the command-line or docker-compose.yml
#
# In this case, we're prefixing everything with `bundle exec` so we don't have
# to do this every time we start the container or when running commands.
ENTRYPOINT [ "jruby", "-G" ]
CMD [ "puma", "-C", "config/puma.rb" ]