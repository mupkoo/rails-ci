FROM ruby:2.4.3
MAINTAINER Mirko Akov

# Initial setup
RUN \
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update -yq && \
  apt-get install -y \
    apt-transport-https \
    build-essential \
    cmake \
    nodejs \
    python-software-properties \
    software-properties-common \
    unzip

# Install Chrome
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update -yqqq && \
  apt-get install -y google-chrome-stable > /dev/null 2>&1 && \
  sed -i 's/"$@"/--no-sandbox "$@"/g' /opt/google/chrome/google-chrome

# Install chromedriver
RUN \
  wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
  rm /tmp/chromedriver.zip && \
  chmod ugo+rx /usr/bin/chromedriver

# Install yarn
RUN \
  curl -o- -L https://yarnpkg.com/install.sh | bash && \
  export PATH=$HOME/.yarn/bin:$PATH

# Install dpl and heroku-cli
RUN \
  add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./" && \
  curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add - && \
  apt-get update -yq && \
  apt-get install heroku -y && \
  gem install dpl
