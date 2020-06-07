.PHONY: build
build: index.html index.js main.wasm
	mkdir $@
	cp $^ $@/

%.wasm: %.wat
	wat2wasm $<
