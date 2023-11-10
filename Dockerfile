FROM ruby:2.3.7

RUN sed -i 's|http://deb.debian.|http://archive.debian.|g' /etc/apt/sources.list
RUN sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|' /etc/apt/sources.list
RUN sed -i 's|deb http://archive.debian.org/debian stretch-updates main||g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs postgresql-client
RUN gem install bundler -v 2.3.26
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
SHELL ["/bin/bash", "-c"]
RUN source /root/.bashrc
# RUN nvm install 8.0.0
RUN apt install -y chromium libgbm-dev libatk-bridge2.0-0 libgtk-3-0 libgtk-3-dev nano xvfb
# WORKDIR /grobr/lib/chrode
# RUN npm install

RUN export RECAPTCHA_SITE_KEY="6Lc6BAAAAAAAAChqRbQZcn_yyyyyyyyyyyyyyyyy"
RUN export RECAPTCHA_SECRET_KEY="6Lc6BAAAAAAAAKN3DRm6VA_xxxxxxxxxxxxxxxxx"

COPY Gemfile ./
# COPY Gemfile.lock ./
WORKDIR /project
RUN bundle install

COPY . ./

# Save rails console and irb history
RUN echo 'IRB.conf[:SAVE_HISTORY] = 10000' > /root/.irbrc

# Symlink important files so they remain across docker restarts
RUN ln -s ~/host/.irb_history ~/
RUN ln -s ~/host/.bash_history ~/

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]