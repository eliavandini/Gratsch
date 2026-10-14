#!/usr/bin/env bash
set -euo pipefail

# Typst local package manager
# Usage:
#   ./typst-package.sh install <path>
#   ./typst-package.sh uninstall <name> [version]
#   ./typst-package.sh list
#   ./typst-package.sh thumbnail <path>

TYPST_DIR="./packages/local"

# --- Helper function: read key=value from typst.toml ---
read_toml_field() {
  local field="$1"
  local file="$2"

  awk -F '=' -v key="$field" '
    $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
      value = substr($0, index($0, "=") + 1)

      # Trim leading and trailing whitespace
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)

      # Remove surrounding single or double quotes
      if (value ~ /^".*"$/ || value ~ /^'\''.*'\''$/) {
        value = substr(value, 2, length(value) - 2)
      }

      # Trim again after removing quotes
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)

      print value
      exit
    }
  ' "$file"
}

# --- Commands ---
case "${1:-}" in
  install)
    SRC_DIR="${2:-.}"

    if [[ ! -f "$SRC_DIR/typst.toml" ]]; then
      echo "Error: typst.toml not found in $SRC_DIR"
      exit 1
    fi

    PKG_NAME=$(read_toml_field name "$SRC_DIR/typst.toml")
    PKG_VER=$(read_toml_field version "$SRC_DIR/typst.toml")

    if [[ -z "$PKG_NAME" || -z "$PKG_VER" ]]; then
      echo "Error: Could not parse name or version from typst.toml"
      exit 1
    fi

    DEST_DIR="$TYPST_DIR/$PKG_NAME/$PKG_VER"

    echo "Installing Typst package:"
    echo "  Name:    $PKG_NAME"
    echo "  Version: $PKG_VER"
    echo "  From:    $SRC_DIR"
    echo "  To:      $DEST_DIR"
    echo

# Resolve absolute paths
SRC_ABS="$(cd "$SRC_DIR" && pwd -P)"
DEST_PARENT="$(mkdir -p "$(dirname "$DEST_DIR")" && cd "$(dirname "$DEST_DIR")" && pwd -P)"
DEST_ABS="$DEST_PARENT/$(basename "$DEST_DIR")"

if [[ "$SRC_ABS" == "$DEST_ABS" ]]; then
  echo "Source and destination are identical; skipping copy."
else
  rm -rf "$DEST_DIR"
  mkdir -p "$DEST_DIR"

  # Copy only non-hidden top-level files and directories,
  # excluding the install scripts
  find "$SRC_ABS" -mindepth 1 -maxdepth 1 \
    ! -name '.*' \
    ! -name 'typst-package.sh' \
    ! -name 'typst-package-inplace.sh' \
    -exec cp -R {} "$DEST_ABS/" \;
fi


    echo "Package installed successfully."
    echo "Package location: $DEST_DIR"
    ;;

  uninstall)
    PKG_NAME="${2:-}"
    PKG_VER="${3:-}"

    if [[ -z "$PKG_NAME" ]]; then
      echo "Usage: $0 uninstall <name> [version]"
      exit 1
    fi

    if [[ -z "$PKG_VER" ]]; then
      echo "Removing all versions of $PKG_NAME..."
      rm -rf "$TYPST_DIR/$PKG_NAME"
    else
      echo "Removing $PKG_NAME version $PKG_VER..."
      rm -rf "$TYPST_DIR/$PKG_NAME/$PKG_VER"
    fi

    echo "Package uninstalled."
    ;;

  thumbnail)
    TYP_PATH="${2:-./test.typ}"
    typst compile "$TYP_PATH" -f png --pages 1 ./thumbnail.png
    echo "Updated thumbnail"
    ;;

  list)
    echo "Installed local Typst packages:"

    if [[ -d "$TYPST_DIR" ]]; then
      find "$TYPST_DIR" -mindepth 2 -maxdepth 2 -type d \
        | sed "s|^$TYPST_DIR/||" \
        | sort
    else
      echo "None found."
    fi
    ;;

  *)
    echo "Typst local package manager"
    echo
    echo "Usage:"
    echo "  $0 install <path>     Install a package from directory"
    echo "  $0 uninstall <name> [version]  Uninstall a package"
    echo "  $0 list               List installed local packages"
    echo "  $0 thumbnail <path>   Regenerate the thumbnail"
    echo
    echo "Example:"
    echo "  $0 install ./packages/mytemplate"
    echo "  $0 uninstall mytemplate 0.1.0"
    ;;
esac
