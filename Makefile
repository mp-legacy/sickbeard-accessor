
usage:
	@echo ''
	@echo 'make dep             : install deependencies'
	@echo ''


dep: clean setup

clean:
	rm -rf lib
	rm -rf node_modules

setup:
	npm install
