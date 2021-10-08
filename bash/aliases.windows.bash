alias ifconfig="ipconfig"

function venv() {
  if ! which python > /dev/null; then
    echo "Python is not installed"
    return 1
  fi

  if [[ ! -d $(pwd)/.venv/ ]]; then
    python -m venv .venv/
  fi

  source .venv/Scripts/activate
}
