const memory = new WebAssembly.Memory({initial:1});

// errors: feel free to add to this list depending on what you want
const errors = [
    "A generic error was thrown",
    "Segmentation fault (core dumped)",
    "Attempted to index out of an bounds"
]

const throwError = (errNo)=>{
    throw errors[errNo];
}

const wasmImports = {
    js: {
        memory,
        throw: throwError
    }
}

const wasmInstance = WebAssembly.instantiateStreaming(fetch('throw.wasm'), wasmImports);
// this function wouldn't be used on its own, so no example is shown here.