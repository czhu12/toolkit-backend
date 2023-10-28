FROM ruby:3.2

ARG NODE_VERSION=20.8.1
ARG YARN_VERSION=1.22.19
ENV BINDING="0.0.0.0" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="omit" \
    GEM_HOME="/usr/local/bundle"

RUN gem update --system && gem cleanup

# Install JavaScript dependencies
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# App dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends imagemagick libvips libvips-dev libvips-tools libpq-dev poppler-utils && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt

# App
WORKDIR /app

COPY ./Gemfile* ./.ruby-version /app/
COPY ./lib/jumpstart/ /app/lib/jumpstart/
COPY ./config/jumpstart.yml* /app/config/jumpstart.yml
RUN bundle install --jobs $(nproc) --retry 5

COPY package.json yarn.lock /app/
RUN yarn install

COPY . .

RUN gem install foreman

# Entrypoint prepares the database.
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/dev"]
