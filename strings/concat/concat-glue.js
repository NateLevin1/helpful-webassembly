const memory = new WebAssembly.Memory({initial:1});

const copyImports = { // this is only used for copy, use wasmImports below for concat
    js: {
        memory
    }
}
const wasmImports = {
    js: {
        memory
    },
    wasm: {
        copy: (await WebAssembly.instantiateStreaming(fetch("../../memory/copy/copy.wasm"), copyImports)).instance.exports.copy
    }
}

const wasmInstance = await WebAssembly.instantiateStreaming(fetch('concat.wasm'), wasmImports);
// do something