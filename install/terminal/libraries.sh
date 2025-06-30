# This script installs core libraries required for various applications and tools on Ubuntu or Debian systems.



# Install core libraries (including MySQL/MariaDB dev)
if [ "$OMAKUB_OS_ID" = "debian" ]; then
  sudo $INSTALLER install -y \
    build-essential pkg-config autoconf bison clang rustc \
    libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
    libvips imagemagick libmagickwand-dev mupdf mupdf-tools gir1.2-gtop-2.0 gir1.2-clutter-1.0 \
    redis-tools sqlite3 libsqlite3-0 libmariadb-dev libmariadb-dev-compat libpq-dev postgresql-client postgresql-client-common
else
  echo "Unsupported OS for core libraries installation."
  exit 1
fi
