set shell := ["zsh", "-cu"]
LOCATION_PYTHON := `python -c "import sys;print(sys.executable)"`

# just manual: https://github.com/casey/just/#readme

# Ignore the .env file that is only used by the web service
set dotenv-load := false

K3D_VERSION := `k3d version`
CURRENT_DIR := "$(pwd)"
PATH_TO_TRAEFIK_CONFIG := CURRENT_DIR / "mounts/var/lib/rancer/k3s/server/manifests/traefik-config.yaml"

# base64_cmd := if "{{os()}}" == "macos" { "base64 -w 0 -i cert.pem -o ca.pem" } else { "base64 -b 0 -i cert.pem -o ca.pem" }
base64_cmd := if "{{os()}}" == "macos" { "base64 -w 0 -i cert.pem -o ca.pem" } else { "base64 -w 0 -i cert.pem > ca.pem" }
grep_cmd := if "{{os()}}" =~ "macos" { "ggrep" } else { "grep" }
conntrack_fix := if "{{os()}}" =~ "linux" { "--k3s-arg '--kube-proxy-arg=conntrack-max-per-core=0@server:*' --k3s-arg '--kube-proxy-arg=conntrack-max-per-core=0@agent:*'" } else { "" }

en0_ip := `ifconfig en0 | grep inet | cut -d' ' -f2 | grep -v ":"`


_default:
		@just --list

info:
		print "Python location: {{LOCATION_PYTHON}}"
		print "PATH_TO_TRAEFIK_CONFIG: {{PATH_TO_TRAEFIK_CONFIG}}"
		print "OS: {{os()}}"

# verify python is running under pyenv
which-python:
		python -c "import sys;print(sys.executable)"

#  /Users/malcolm/.jupyter/jupyter_server_config.py
jupyter-config:
  jupyter server --generate-config

start-jupyter:
  start-notebook.py

install:
  conda install -c conda-forge 'jupyterlab=4.1.0' 'jupyterlab-lsp=5.1.0' 'jupyter-lsp-python=2.2.4'
  conda install -c conda-forge jedi-language-server
  conda install -c conda-forge ipywidgets
  npm install --save-dev bash-language-server
  npm install --save-dev dockerfile-language-server-nodejs
  npm install --save-dev pyright
  npm install --save-dev sql-language-server
  npm install --save-dev typescript-language-server
  npm install --save-dev unified-language-server
  npm install --save-dev vscode-json-languageserver-bin
  npm install --save-dev yaml-language-server
  pip install langchain_community tiktoken langchain-openai langchainhub chromadb langchain langchain-cli
  pip install rich bpython better_exceptions
  pip install black isort mypy pre-commit==3.2.2
  pip install yapf flake8 black ruff isort autopep8 autoflake pylint better_exceptions rich bpython python-dotenv
  pip install openapi-schema-pydantic openapi-pydantic wikipedia docarray
