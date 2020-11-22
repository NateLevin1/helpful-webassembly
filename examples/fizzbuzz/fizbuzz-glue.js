const memory = new WebAssembly.Memory({initial:1});

const wasmImports = {
    console: {
        logString: (offset) => {
            const length = new Int32Array(memory.buffer, offset, 1)[0];
            const string = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset + 4/*<- 4 is the length in Uint8s of an int32*/, length));
            console.log(string);
        },
        logInt: (int) => {
            console.log(int)
        }
    },
    js: {
        memory
    }
}

const runWasmInstance = (wasmInstance) => {
    const { main } = wasmInstance.instance.exports;
    main();
    // logs fizzbuzz to the console
}

fetch('fizzbuzz.wasm').then(response =>
    response.arrayBuffer()
).then(bytes =>
    WebAssembly.instantiate(bytes, wasmImports)
).then(runWasmInstance);
