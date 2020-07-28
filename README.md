# dotfiles

## Welcome to Oneflare
We provide these dotfiles as a way for engineers (or anyone, really) to get up and running quickly at Oneflare.

They provide the necessary software and sane defaults for working with the various Oneflare codebases.

The idea is that they should get better over time and you should be able to customise them to your liking.

So hit that fork button and get coding!


## Install

### Prerequisites

* You need to have `git` install on your machine. For MacOS:

```sh
xcode-select --install
```

* Ensure you haven't installed any additional programs, e.g. Google Chrome.

  This will interfere with the setup script and cause it to fail.

### Setup

```sh
git clone https://github.com/Oneflare/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

## Post-Install

Once the script has completed successfully, quit `Terminal` and open `iTerm`

### Configure

* iTerm
  * P10k will prompt you for setup, press `q` to ignore for now
  * Go to Preferences -> Profiles -> Text
  * Select "FuraCode Nerd Font Mono" and "Use Ligatures"
  * Go to Colors tab and select a Theme
    * Many more Themes available [here](https://iterm2colorschemes.com)
  * Quit iTerm and reopen to run through P10k customisation
    * We don't need the suggested font, so decline installation
* Git
  * Run the following, replacing values with your own:

   It is recommended to use your GitHub-provided `noreply` address: [Setting your commit email address](https://help.github.com/en/github/setting-up-and-managing-your-github-user-account/setting-your-commit-email-address#setting-your-commit-email-address-on-github)
  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```
  * For extra credit, [setup GPG signing](https://help.github.com/en/github/authenticating-to-github/signing-commits) for your commits:
  ```sh
  git config --global commit.gpgsign true
  git config --global gpg.program "gpg"
  ```
* SSH
  * Either restore your ssh key or [generate a new key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

### Secrets

Secret data should be stored in `custom/secret.zsh`

For example:

```
export SOME_TOKEN=abcdef123456
```

This file is ignored so it isn't accidentally committed with sensitive information.
