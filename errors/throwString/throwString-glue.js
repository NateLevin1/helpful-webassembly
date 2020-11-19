const memory = new WebAssembly.Memory({initial:1});

const throwString = (offset)=>{
    const length = new Int32Array(memory.buffer, offset, 1)[0];
    const string = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset+4/*<- 4 is the length in Uint8s of an int32*/, length));
    throw string;
}

const wasmImports = {
    js: {
        memory,
        throwString
    }
}

const wasmInstance = WebAssembly.instantiateStreaming(fetch('throwString.wasm'), wasmImports);
// this function wouldn't be used on its own, so no example is shown here.