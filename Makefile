.DEFAULT_GOAL := setup_local_environment

RUBY_VERSION := 2.7.7
ZSH_SHELL := /bin/zsh

setup_local_environment: \
	install_ruby \
	install_bundler \
	install_swiftformat \
	install_mockolo \
	install_pre_commit \
	configure_zshrc

install_homebrew:
	@echo "Checking if Homebrew is installed..."
	@if ! command -v brew > /dev/null; then \
		echo "Homebrew not found. Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "Homebrew is already installed."; \
	fi

install_rbenv:
	@echo "Checking if rbenv is installed..."
	@if ! command -v rbenv > /dev/null; then \
		echo "Installing rbenv and ruby-build..."; \
		brew install rbenv ruby-build; \
	else \
		echo "rbenv is already installed."; \
	fi

install_ruby: install_homebrew install_rbenv
	@echo "Installing Ruby $(RUBY_VERSION)..."
	@if ! rbenv versions | grep -q $(RUBY_VERSION); then \
		rbenv install $(RUBY_VERSION) -s; \
		rbenv global $(RUBY_VERSION); \
		rbenv rehash; \
		echo "Ruby $(RUBY_VERSION) installed and set as global default."; \
	else \
		echo "Ruby $(RUBY_VERSION) is already installed."; \
	fi

install_bundler:
	@echo "Installing Bundler..."
	@if ! gem list bundler -i > /dev/null; then \
		gem install bundler; \
		rbenv rehash; \
		echo "Bundler installed."; \
	else \
		echo "Bundler is already installed."; \
	fi

configure_zshrc:
	@echo "Configuring .zshrc for Jenkins user..."
	@USER_ZSHRC=~/.zshrc; \
	if ! grep -q 'rbenv init' $$USER_ZSHRC; then \
		echo 'export PATH="$$HOME/.rbenv/bin:$$PATH"' >> $$USER_ZSHRC; \
		echo 'eval "$$(rbenv init -)"' >> $$USER_ZSHRC; \
		echo ".zshrc updated to include rbenv setup."; \
	else \
		echo ".zshrc already configured for rbenv."; \
	fi
	@$(ZSH_SHELL) -c 'source ~/.zshrc'


install_swiftformat:
	$(info Installing SwiftFormat ...)
	@if ! brew list --formula | grep -q '^swiftformat$$'; then \
		brew install swiftformat; \
	else \
		echo "SwiftFormat is already installed."; \
	fi

install_mockolo:
	$(info Installing Mockolo ...)
	@if ! brew list --formula | grep -q '^mockolo$$'; then \
		brew install mockolo; \
	else \
		echo "Mockolo is already installed."; \
	fi

install_pre_commit:
	$(info Installing Pre-commit hooks ...)
	@if ! brew list --formula | grep -q '^pre-commit$$'; then \
		brew install pre-commit; \
		pre-commit install; \
	else \
		echo "Pre-commit is already installed."; \
	fi

.PHONY: setup_local_environment install_homebrew install_rbenv install_ruby install_bundler configure_zshrc install_swiftformat install_mockolo install_pre_commit
