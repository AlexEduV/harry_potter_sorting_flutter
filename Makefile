clean-build-hard:
	dart run build_runner clean
	$(MAKE) build-verbose-delete-conflicting-outputs

build-hard:
	dart run build_runner build -v --delete-conflicting-outputs

show-coverage:
	PATH=$$PATH:$$HOME/.pub-cache/bin \
	flutter test --coverage --concurrency=4 --exclude-tags integration
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

run-all-tests:
	flutter test --concurrency=4 --exclude-tags integration