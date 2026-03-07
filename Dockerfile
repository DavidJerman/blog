# Use the official Jekyll image as the base
FROM jekyll/jekyll:latest

# Set our working directory inside the container
WORKDIR /srv/jekyll

# Copy your Gemfile into the container
COPY Gemfile ./

# Install the dependencies (jekyll-remote-theme) globally in the image
RUN bundle install

# Expose the port Jekyll uses
EXPOSE 4000

# The default command to run your live server
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--watch", "--force_polling"]
