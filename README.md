# My dotfiles

Dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/).
Configuration packages live directly in this repository and mirror paths beneath
`$HOME`. For example, `zsh/.zshrc` links to `~/.zshrc`. The repository
`.stowrc` sets the home target. Stow uses its default directory folding.

## Installation

Install Xcode command-line tools:

```bash
xcode-select --install
```

Clone the repository and run the setup script:

```bash
mkdir -p ~/git
git clone https://github.com/Faria22/dotfiles-public.git ~/git/dotfiles
cd ~/git/dotfiles/setup
./startup.sh
```

The setup script installs Homebrew packages, including Stow, and links all
dotfiles. To link them without running the full setup:

```bash
brew install stow
~/git/dotfiles/scripts/stow-dotfiles
```

## Managing links

From the repository root, use Stow directly:

```bash
cd ~/git/dotfiles
stow --simulate --verbose zsh shell
stow zsh shell
stow --delete zsh
```

Select configuration packages explicitly; `scripts/` and `setup/` are repository
tooling and must not be stowed. The helper below also works from other
directories. Stow reads `.stowrc` from the current directory and your home directory; it does not search for this
repository automatically. To invoke Stow directly from elsewhere, provide all
settings explicitly:

```bash
stow --dir="$HOME/git/dotfiles" --target="$HOME" zsh shell
```

Preview or apply selected packages:

```bash
~/git/dotfiles/scripts/stow-dotfiles --simulate --verbose zsh shell
~/git/dotfiles/scripts/stow-dotfiles zsh shell
```

Running the script without arguments applies all packages. When supplying flags,
include the package names explicitly. Packages are independent; `zsh` does not
automatically select `shell`, `git`, or other packages.

Remove or rebuild a package's links:

```bash
~/git/dotfiles/scripts/stow-dotfiles --delete zsh
~/git/dotfiles/scripts/stow-dotfiles --restow zsh
```

The `.stowrc` targets `$HOME`. Stow can link an entire directory when its
contents belong to one package. It shares existing directories when they contain
other files or links from multiple packages. Existing unrelated
files cause conflicts; review them before moving anything. Do not use `--adopt`
unless you intend to replace repository files with the existing target files.

The `qmk` package links its keymap into
`~/git/qmk_firmware/keyboards/crkbd/keymaps/Faria22` and is included when the
helper runs without arguments.

To add a configuration, put it at its intended home-relative path inside a
package, then apply that package. Add new package names to the wrapper's default
list if they should be included in a full setup.

## Automatically update Homebrew

Open the crontab with `crontab -e` and add:

```crontab
0 0 * * * /bin/bash $HOME/git/dotfiles/scripts/update_packages > /dev/null 2>&1
```
