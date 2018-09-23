echo "Setting up Popcorn Night"

echo "Checking for Bundler"
if ! [ -x "$(command -v bundle)" ]; then
    echo "Need to install Bundler"
    gem install bundler
fi

echo "Running bundle install"
bundle install

echo "Installing pods"
bundle exec pod install

echo "Setup complete"
