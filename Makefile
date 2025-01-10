.DEFAULT_GOAL := setup_local_environment

RUBY_VERSION := 2.7.7
ZSH_SHELL := /bin/zsh

DERIVED_DATA_PATH = .derivedData
BUILD_RESULT_BUNDLE_PATH = Reports/BuildForTestingResults
TEST_RESULT_BUNDLE_PATH = Reports/TestResults
DESTINATION = 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=latest'
PARALLEL_TESTING_ENABLED = YES
PARALLEL_WORKER_COUNT = 3

setup_local_environment: \
	install_ruby \
	install_bundler \
	install_jenkins_lts \
	install_ngrok \
	install_danger_swift \
	install_swiftlint \
	install_swiftformat \
	install_mockolo \
	install_pre_commit \
	install_sonar_scanner \
	install_xcbeautify \
	install_xclogparser \
	install_grafana \
	install_influxdb \
	configure_zshrc
	
setup_ci_environment: \
	install_bundler \
	install_danger_swift \
	install_sonar_scanner

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

install_jenkins_lts:
	$(info Installing Jenkins LTS ...)
	@if ! brew list --formula | grep -q '^jenkins-lts$$'; then \
		brew install jenkins-lts; \
	else \
		echo "Jenkins LTS is already installed."; \
	fi

install_ngrok:
	$(info Installing ngrok...)
	@if ! brew list --cask | grep -q '^ngrok$$'; then \
		brew install ngrok/ngrok/ngrok; \
	else \
		echo "ngrok is already installed."; \
	fi

install_swiftlint:
	$(info Installing SwiftLint ...)
	@if ! brew list --formula | grep -q '^swiftlint$$'; then \
		brew install swiftlint; \
	else \
		echo "SwiftLint is already installed."; \
	fi

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

install_danger_swift:
	$(info Installing Danger swift ...)
	brew install danger/tap/danger-swift

install_sonar_scanner:
	$(info Installing sonar-scanner ...)
	@if ! brew list --formula | grep -q '^sonar-scanner$$'; then \
		brew install sonar-scanner; \
	else \
		echo "Sonar Scanner is already installed."; \
	fi
	
install_xcbeautify:
	$(info Installing xcbeautify ...)
	@if ! brew list --formula | grep -q '^xcbeautify$$'; then \
		brew install xcbeautify; \
	else \
		echo "xcbeautify is already installed."; \
	fi
	
install_xclogparser:
	$(info Installing xclogparser ...)
	@if ! brew list --formula | grep -q '^xclogparser$$'; then \
		brew install xclogparser; \
	else \
		echo "xclogparser is already installed."; \
	fi
	
install_grafana:
	$(info Installing grafana ...)
	@if ! brew list --cask | grep -q '^grafana$$'; then \
		brew install grafana; \
	else \
		echo "Grafana is already installed."; \
	fi
	
install_influxdb:
	$(info Installing influxdb ...)
	@if ! brew list --formula | grep -q '^influxdb$$'; then \
		brew install influxdb; \
		brew install influxdb-cli; \
	else \
		echo "InfluxDB and CLI are already installed."; \
	fi

install_bitrise_cli:
	$(info Installing the Bitrise CLI with Homebrew ...)
	@if ! brew list --formula | grep -q '^bitrise$$'; then \
		brew install bitrise; \
	else \
		echo "Bitrise CLI is already installed."; \
	fi

clean_reports:
	@echo "Cleaning up report directories..."
	@if [ -d "Reports" ]; then \
		rm -rf Reports/BuildForTestingResults; \
		rm -rf Reports/TestResults; \
		find Reports -name '*.xcresult' -type d -exec rm -rf {} +; \
	else \
		echo "Reports directory does not exist. Skipping cleanup."; \
	fi

build_and_run_tests:
	$(info Building for Testing ...)
	xcodebuild build-for-testing \
		-workspace Example.xcworkspace \
		-scheme Example \
		-sdk iphonesimulator \
		-destination $(DESTINATION) \
		-allowProvisioningUpdates \
		-testPlan Example \
		-enableCodeCoverage YES \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-resultBundlePath $(BUILD_RESULT_BUNDLE_PATH)

	$(info Running Tests without Building ...)
	xcodebuild test-without-building \
		-workspace Example.xcworkspace \
		-scheme Example \
		-sdk iphonesimulator \
		-destination $(DESTINATION) \
		-allowProvisioningUpdates \
		-testPlan Example \
		-enableCodeCoverage YES \
		-parallel-testing-enabled $(PARALLEL_TESTING_ENABLED) \
		-parallel-testing-worker-count $(PARALLEL_WORKER_COUNT) \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-resultBundlePath $(TEST_RESULT_BUNDLE_PATH) | xcbeautify

generate_coverage:
	chmod +x Scripts/xccov-to-sonarqube-generic.sh
	Scripts/xccov-to-sonarqube-generic.sh  Reports/TestResults.xcresult > Reports/sonarqube-generic-coverage.xml

run_unit_test: clean_reports build_and_run_tests generate_coverage
	@echo "Running sonar analysis for source branch: $(branch)"
	bundle exec fastlane ios sonar_analysis source_branch: $(branch)

.PHONY: setup_local_environment setup_ci_environment install_homebrew install_rbenv install_ruby install_bundler configure_zshrc install_jenkins_lts install_ngrok install_swiftlint install_swiftformat install_mockolo install_pre_commit install_danger_swift install_sonar_scanner install_xcbeautify install_xclogparser install_grafana install_influxdb  install_bitrise_cli clean_reports build_and_run_tests generate_coverage run_unit_test
