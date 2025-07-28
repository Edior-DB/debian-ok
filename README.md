# Debian-Omakub (Debian-Ok)

> **Note:** This fork of Omakub is a heavily refactored and extended version of the original [Basecamp Omakub](https://github.com/basecamp/omakub). It is not fully tested and may contain bugs or incomplete features. Use at your own risk and please report issues.

Turn a fresh Debian 12 installation into a fully-configured, beautiful, and modern web development system by running a single command. Debian-Ok is an opinionated take on what Linux can be at its best, and is a direct fork of Omakub.

** The changes are not necessarily optimal - they just reflect the personal preferences of the author **

## Essential Changes from Basecamp's Original Omakub

- **Debian 12 only:** This fork supports only Debian 12+ with robust OS detection and package handling. All Ubuntu support has been removed.
- **Strict GNOME/GDM3 requirement:** Installer halts if not running under GNOME or GDM3.
- **Core vs. Optional Apps:** Only core terminal tools and GNOME-tweaking scripts are installed by default. All other apps (including Docker, Neovim, Chrome, LibreOffice, etc.) are now optional and can be installed later via the DebianOk app or optional scripts.
- **Fastfetch and Alacritty:** Now required and installed early in the process.
- **Flatpak:** Now a required dependency, installed/configured before any app install.
- **Application launchers:** All launchers are safe to source and do not exit the parent process. They check for dependencies and remove launchers if missing.
- **GNOME extension setup:** Improved for Debian compatibility, with checks for extension/key existence before configuration.
- **Idempotency and error handling:** All scripts are idempotent, robust, and provide improved error handling and user feedback.
- **Directory structure:** Optional and required scripts are now clearly separated. Obsolete and legacy scripts have been removed.

## Quick Install

You can install Debian-Ok with a single command:

```sh
wget -qO- https://raw.githubusercontent.com/Edior-DB/debian-ok/master/boot.sh | bash
```

## OS Compatibility and Package Handling

Debian-Ok supports **Debian 12+** only. All installer and desktop scripts have been refactored to:
- Use environment variables (`OMAKUB_OS_ID`, `OMAKUB_OS_VERSION_ID`) for robust OS detection (retained from Omakub for compatibility).
- Handle missing or non-repo packages (like `eza`, `fastfetch`, `tree-sitter-cli`, `ulauncher`, `typora`, `pinta`, `obsidian`, `rubymine`, etc.) on Debian by downloading binaries or `.deb` files from official GitHub or vendor releases, with idempotent checks to avoid reinstalling if already present.
- Use `libmariadb-dev`/`libmariadb-dev-compat` for MySQL/MariaDB development on Debian.
- All PostgreSQL-related packages (`libpq-dev`, `postgresql-client`, `postgresql-client-common`) are available and installed from standard repos on Debian.
- All direct `.deb`/external installs are now idempotent: the script checks if the tool is already installed before downloading/installing.
- Flatpak/Flathub is now a required dependency and is installed/configured before any app install. Some apps (e.g., Pinta) use Flatpak with automatic remote setup and aliasing for user convenience.
- Improved error handling: failed commands and exit codes are displayed, and the script halts for user review.
- After GNOME installation, the user is prompted to reboot or continue with terminal-only setup, ensuring a smooth first-time experience.
- **Only core terminal tools and GNOME-tweaking desktop scripts are installed by default.** All other apps (including Docker, Neovim, Chrome, LibreOffice, etc.) are now optional and can be installed later via the Debian.Ok app or optional scripts.

### Optional Apps

Debian-Ok now separates core and optional apps. To install optional apps (like Docker, Neovim, Chrome, LibreOffice, etc.), launch the Omakub app after setup, or run the relevant script from the `install/terminal/optional/` or `install/desktop/optional/` directories.


## Credits: Chris Titus Visuals and Configs

This project uses and adapts visual and configuration files for Alacritty and Kitty terminals from Chris Titus's open source repositories:

- [ChrisTitusTech/dwm-titus](https://github.com/ChrisTitusTech/dwm-titus) (Alacritty and Kitty config files)
- [ChrisTitusTech/linutil](https://github.com/ChrisTitusTech/linutil) (setup scripts and configuration inspiration)

The installer fetches and applies his Alacritty and Kitty themes and configuration files by default, while retaining Debian-Ok's own keybinds and other custom settings. Many thanks to Chris Titus for sharing his work with the community.

**These changes were contributed by [GitHub Copilot](https://github.com/features/copilot) as part of a comprehensive cross-distro compatibility, idempotency, and robustness refactor (2025).**

## Contributing to the documentation

Please help us improve Debian-Ok's documentation on the [Edior-DB/debian-ok-site repository](https://github.com/Edior-DB/debian-ok-site).

## License

Debian-Ok is released under the [MIT License](https://opensource.org/licenses/MIT).

## Extras

While Debian-Ok is purposed to be an opinionated take, the open source community offers alternative customization, add-ons, extras, that you can use to adjust, replace or enrich your experience.

[⇒ Browse the Debian-Ok extensions.](EXTENSIONS.md)
