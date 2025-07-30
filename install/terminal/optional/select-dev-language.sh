# Install default programming languages

AVAILABLE_LANGUAGES=("Ruby on Rails" "Node.js" "Go" "PHP" "Python" "Elixir" "Rust" "Java")
languages=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --height 10 --header "Select programming languages")

if [[ -n "$languages" ]]; then
  for language in $languages; do
    case $language in
    Ruby)
      mise use --global ruby@latest
      mise settings add idiomatic_version_file_enable_tools ruby
      mise x ruby -- gem install rails --no-document
      ;;
    Node.js)
      mise use --global node@lts
      ;;
    Go)
      mise use --global go@latest
      ;;
    PHP)
      if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -eq 12 ]; then
        sudo $INSTALLER  install -y php8.2 php8.2-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip}
      elif [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -ge 13 ]; then
        sudo $INSTALLER  install -y php php-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip}
      else
        echo "Unsupported Debian version for PHP install. Debian 12 or higher required."
        exit 1
      fi
      php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
      php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
      rm composer-setup.php
      ;;
    Python)
      mise use --global python@latest
      ;;
    Elixir)
      mise use --global erlang@latest
      mise use --global elixir@latest
      mise x elixir -- mix local.hex --force
      ;;
    Rust)
      bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
      ;;
    Java)
      mise use --global java@latest
      ;;
    esac
  done
fi
