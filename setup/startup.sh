#!/bin/bash

# --- Configuration ---
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE_PATH="$REPO_DIR/setup/Brewfile"

# --- Functions ---

check_homebrew() {
    if command -v brew &> /dev/null; then
        echo "Homebrew is already installed."
        return 0 # Homebrew is installed
    else
        echo "Homebrew is not installed."
        return 1 # Homebrew is not installed
    fi
}

install_homebrew() {
    echo "Attempting to install Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -eq 0 ]; then
        echo "Homebrew installed successfully."
        # Add Homebrew to PATH for the current session if it wasn't already there
        eval "$(/opt/homebrew/bin/brew shellenv)"
        return 0
    else
        echo "Error: Homebrew installation failed. Please check the output for details."
        return 1
    fi
}

run_brew_bundle() {
    if [ -f "$BREWFILE_PATH" ]; then
        echo "Found Brewfile at: $BREWFILE_PATH"
        echo "Running brew bundle..."
        brew bundle --file="$BREWFILE_PATH"
        if [ $? -eq 0 ]; then
            echo "brew bundle completed successfully."
        else
            echo "Error: brew bundle failed. Please check the output for details."
            exit 1
        fi
    else
        echo "Error: Brewfile not found at $BREWFILE_PATH."
        echo "Please ensure your Brewfile is in the correct location or update BREWFILE_PATH."
        exit 1
    fi
}

# --- Main Script Logic ---
echo "Starting Homebrew and Brewfile setup..."

# Check if Homebrew is installed
if ! check_homebrew; then
    install_homebrew
    if [ $? -ne 0 ]; then
        echo "Exiting due to Homebrew installation failure."
        exit 1
    fi
else
    # Ensure Homebrew is in the current session's PATH
    # This is crucial for newly opened terminals or scripts
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Run brew bundle
run_brew_bundle

# Link dotfiles
"$REPO_DIR/scripts/stow-dotfiles" || exit $?
source ~/.zshrc

pip install -r "$REPO_DIR/setup/requirements.txt"

echo "Script completed."
