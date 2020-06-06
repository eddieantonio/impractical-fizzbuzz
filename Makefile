main.wasm:

%.wasm: %.wat
	wat2wasm $<
