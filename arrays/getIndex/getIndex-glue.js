const memory = new WebAssembly.Memory({initial:1});

const wasmImports = {
    js: {
        memory
    }
}

const wasmInstance = WebAssembly.instantiateStreaming(fetch('getIndex.wasm'), wasmImports);
// this function wouldn't be used on its own, so no example is shown here.