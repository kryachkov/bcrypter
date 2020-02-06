FROM ruby:2.6.2

ENV RACK_ENV=production
EXPOSE 4567
RUN gem install bundler
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY myapp.rb .
COPY views views
ENTRYPOINT ["bundle", "exec", "ruby", "myapp.rb"]
