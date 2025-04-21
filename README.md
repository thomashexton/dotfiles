# dotfiles

My personal dotfiles for macOS on Apple Silicon.

## Setup

```sh
git clone https://github.com/thomashexton/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

## Notes

- Designed for Apple Silicon Macs
- Idempotent: can be run multiple times safely
- Uses GNU stow for symlink management
- Secret configurations stored in iCloud Drive
- Supports home/work environment configurations

## Table of Contents

1. [Before Setup](#before-setup)
   - [Prerequisites](#prerequisites)
2. [Setup](#setup)
3. [After Setup](#after-setup)
   - [Git](#git)
   - [SSH](#ssh)
   - [Secrets](#secrets)

## Before Setup

### Prerequisites

- You need to have `git` installed on your machine:

  ```sh
  xcode-select --install
  ```

## Setup

To set up your environment with these dotfiles, execute the following commands:

```sh
git clone https://github.com/thomashexton/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

The bootstrap script will:
1. Install Homebrew if not already installed
2. Install essential packages including GNU stow for dotfile management
3. Prompt you to choose between home or work configuration
4. Stow configuration files to their appropriate locations
5. Set up additional secret configurations from iCloud (if available)

## After Setup

### Git

- Replace values with your own, and then run.

Note: it is recommended to use your GitHub-provided `noreply` address ... [see setting your commit email address](https://help.github.com/en/github/setting-up-and-managing-your-github-user-account/setting-your-commit-email-address#setting-your-commit-email-address-on-github).

  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```

<!-- - For extra credit, [setup GPG signing](https://help.github.com/en/github/authenticating-to-github/signing-commits) for your commits.

```sh
git config --global commit.gpgsign true
git config --global gpg.program "gpg"
``` -->

### SSH

- Either restore your ssh key or [generate a new key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

### Secrets

Secret configurations are managed through iCloud. They should be placed in:
`~/Library/Mobile Documents/com~apple~CloudDocs/stow/`

The bootstrap script will automatically link these configs if the directory exists.
