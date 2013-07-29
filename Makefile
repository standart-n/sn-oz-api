DATE = $(shell date +%I:%M%p)


build:
	@./node_modules/.bin/grunt


install: 
	@mkdir -p ./script/
	@npm install
	@./node_modules/.bin/grunt all
	

finish:
	@echo "\nSuccessfully built at ${DATE}."


.PHONY: test bootstrap
