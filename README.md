# dotfiles

Dotfiles for configuring macOS development environment on Apple M1 Macs.

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

- You need to have `git` installed on your machine. For MacOS:

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

Secret data should be stored in `custom/secret.zsh`

- For example:

  ```sh
  export SOME_TOKEN=abcdef123456
  ```

This file is ignored so it isn't accidentally committed with sensitive information.
