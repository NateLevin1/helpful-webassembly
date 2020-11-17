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

const memory = new WebAssembly.Memory({initial:1});

WebAssembly.instantiateStreaming(fetch('fizzbuzz.wasm'), wasmImports).then((wasmInstance) => {
    const { main } = wasmInstance.exports;
    main();
    // logs fizzbuzz to the console
});