const wasmImports = {
    js: {
        memory
    }
}

const memory = new WebAssembly.Memory({initial:1});
const wasmInstance = WebAssembly.instantiateStreaming(fetch('copy.wasm'), wasmImports);
// this function wouldn't be used on its own, so no example is shown here.
// see /strings/concat for a good example of this function