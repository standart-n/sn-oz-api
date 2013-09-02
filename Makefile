DATE = $(shell date +%I:%M%p)


install: 
	@mkdir -p ./script/
	@npm install
	@./node_modules/.bin/grunt all


build:
	@./node_modules/.bin/grunt


finish:
	@echo "\nSuccessfully built at ${DATE}."


.PHONY: test bootstrap
