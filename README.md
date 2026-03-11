# dotfiles

My personal dotfiles for macOS on Apple Silicon.

## Quick Options

- Full setup: `./bootstrap.sh`
- Stow only (skip Homebrew): `./bootstrap.sh --stow-only`
- Work machine secrets: `WORK=true ./bootstrap.sh`
- Reset stored profile: `rm -f ~/.config/dotfiles-bootstrap/profile`

## Notes

- Designed for Apple Silicon Macs
- Idempotent: can be run multiple times safely
- Uses GNU stow for symlink management
- Keyboard remapping is repo-managed via kanata; Karabiner is installed only for its macOS driver
- Secret configurations stored in iCloud Drive
- Remembers your home/work choice (remove `~/.config/dotfiles-bootstrap/profile` to re-prompt)
- Supports home/work environment configurations (use `WORK=true` to force work mode)

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
cd ~/dotfiles  # Important: The bootstrap script needs to run from the dotfiles directory
./bootstrap.sh
```

The bootstrap script will:
1. Install Homebrew if not already installed
2. Install essential packages including GNU stow for dotfile management
3. Prompt once to choose between home or work configuration (stored in `~/.config/dotfiles-bootstrap/profile`)
4. Stow configuration files to their appropriate locations
5. Configure kanata from dotfiles and install its launch daemon when sudo is available
6. Set up additional secret configurations from iCloud (if available)

### Home vs Work profile

- First run: respond to the prompt (h/w). Your answer is saved to `~/.config/dotfiles-bootstrap/profile`.
- Subsequent runs reuse the saved value automatically so both Brewfile selection and secret configs stay in sync.
- Temporarily override by exporting `WORK=true`; delete the profile file if you want to be prompted again.

## Post-Setup Configuration

- **SSH Keys**: [Generate new SSH keys](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) or restore from backup
- **Secret Files**: Place profile-scoped secrets in `~/Library/Mobile Documents/com~apple~CloudDocs/stow/home/` and `~/Library/Mobile Documents/com~apple~CloudDocs/stow/work/` for automatic linking
- **Keyboard remapping**: `kanata` reads `~/.config/kanata/kanata.kbd`; `karabiner-elements` is installed only for the VirtualHID driver on macOS.
- **Helper commands**: `kanata-check` validates the repo-managed config and `kanata-start` runs it via `sudo`

### Secret profile layout

Store secret stow packages under the active profile so bootstrap only links the
correct set for the machine:

```text
~/Library/Mobile Documents/com~apple~CloudDocs/stow/
  home/
    ssh/
      .ssh/
        personal/
        personal_include.conf
  work/
    ssh/
      .ssh/
        personal/
        personal_include.conf
        work/
        work_include.conf
    zsh/
      .config/zsh/custom/
```
