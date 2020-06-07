const BYTES_PER_CODEPOINT = 4;
const CODEPOINTS_PER_LINE = "𐑁𐐮𐑆𐐺𐐲𐑆\n".length;
const BUFFER_SIZE = BYTES_PER_CODEPOINT * CODEPOINTS_PER_LINE;

let mem = new WebAssembly.Memory({ initial: BUFFER_SIZE });
let ptr = new WebAssembly.Global({ value: 'i32', mutable: true }, 0);

loadWasm()
  .then(({fizzbuzz}) => fizzbuzz());

/////////////////////// internal functions /////////////////////////////

async function loadWasm() {
  let response = await fetch('main.wasm');
  let wasm = await response.arrayBuffer();
  let compilation = await WebAssembly.instantiate(wasm, {
    js: { mem, ptr },
    import: { logBuffer }
  });

  return compilation.instance.exports;
}

function logBuffer(length) {
  let output = document.getElementById("output");
  output.innerText += UTF32BufferToString(mem.buffer, length);
}

function UTF32BufferToString(buffer, length) {
  let codepoints = new Uint32Array(buffer);
  let result = '';
  let i = 0;
  for (let codepoint of codepoints) {
    if (codepoint === 0 || i >= length)
      break;
    result += String.fromCodePoint(codepoint);
    i++;
  }
  return result;
}
