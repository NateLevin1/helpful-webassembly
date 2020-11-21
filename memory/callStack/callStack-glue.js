const memory = new WebAssembly.Memory({initial:1});

const wasmImports = {
    js: {
        memory
    }
}

const wasmInstance = WebAssembly.instantiateStreaming(fetch('setIndex.wasm'), wasmImports);
// these functions wouldn't be used on their own, so no example is shown here.