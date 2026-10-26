#!/bin/zsh
# Builds the encrypted page (index.html) from the latest explorer, ready for the Bernaz/NESP-Explorer repo.
# Asks for the team password without showing it; the password is never saved to a file.
#   ./publish.sh          build index.html and show it in Finder (then upload it on github.com)
#   ./publish.sh --push   build, commit and push with git (needs a working GitHub login on this Mac)
set -e
cd "$(dirname "$0")"
SRC="/Users/bernardocantone/Downloads/JCU/NESP/Documents/SEQ Land for Wildlife Explorer.html"
ENC="/Users/bernardocantone/Downloads/JCU/NESP/R codes/_explorer/encrypt_for_github.js"
read -rs "pw?Team password (10+ characters): "; echo
read -rs "pw2?Same password again: "; echo
[[ "$pw" == "$pw2" ]] || { echo "The two passwords differ. Nothing was built."; exit 1; }
EXPLORER_PASSWORD="$pw" node "$ENC" "$SRC" index.html
if [[ "$1" == "--push" ]]; then
  git add index.html README.md .nojekyll publish.sh
  git commit -qm "Update the SEQ Land for Wildlife Explorer" && git push -u origin main
  echo "Pushed. The page updates at https://bernaz.github.io/NESP-Explorer/ within a minute or two."
else
  echo "Built index.html. Upload it (and README.md) at https://github.com/Bernaz/NESP-Explorer/upload/main"
  open -R index.html
fi
