FROM ruby:2.4.1

ENV APP_HOME /app
WORKDIR $APP_HOME
# ADD Gemfile* $APP_HOME/
# ADD *.gemspec $APP_HOME/
# ADD *.gemspec $APP_HOME/
# RUN bundle --retry 5 --jobs 4
ADD . $APP_HOME
