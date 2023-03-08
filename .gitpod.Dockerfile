# The main image, using the GitPod default
# If you wanted to VNC into your workspace you could use gitpod/workspace-full-vnc
FROM gitpod/workspace-full
FROM gitpod/workspace-postgres
USER gitpod

ARG RUBY_VERSION=3.2

# Use the latest Yarn and Node LTS versions
# See https://stackoverflow.com/questions/60908878/webpacker-compilation-failed-error-errno-21-is-a-directory-bin
RUN curl -sL https://deb.nodesource.com/setup_lts.x | sudo bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN sudo apt-get update
RUN sudo apt-get install -y redis-server build-essential git zlib1g-dev sassc libsass-dev curl yarn nodejs

RUN sudo rm -rf /var/lib/apt/lists/*

# Install Ruby using the recipe suggestd by GitPod
# Install the Ruby version specified in '.ruby-version'
COPY --chown=gitpod:gitpod .ruby-version /tmp
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install $RUBY_VERSION && rvm use $RUBY_VERSION --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc
