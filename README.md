# Helpful WebAssembly
Helper functions for WebAssembly Text Format. Use them for making compilers or when you're just playing around with WAT.

Each function has a `name.wat` file, a `name.wasm` file and a `name-glue.js`. The glue code contains an object called `wasmImports` which contains the import object for the wasm.

## Use

### Copy and paste into the .wat file (Best for one file)
Simply take the function and copy paste it into the file you want it to be in. You probably will want to remove it as an export. Simple and effective.

### 2. Import into .wat files (Best for multiple files)
You will need to instantiate the helper function's wasm file in javascript and pass the export in as an import to your .wat file. For example, in your javascript you can add something like
```js
const exampleFuncObj = await WebAssembly.instantiateStreaming(fetch('helper-func.wasm'), {...});

const yourWasm = await WebAssembly.instantiateStreaming(fetch('your-wasm.wasm'), {
    helpers: {
        exampleFunc: exampleFuncObj.instance.exports.exampleFunc
    }
});

const yourWasm2 = await WebAssembly.instantiateStreaming(fetch('your-wasm2.wasm'), {
    helpers: {
        exampleFunc: exampleFuncObj.instance.exports.exampleFunc
    }
});
```

## Development
Use `npm run build` to build all `.wat` files to wasm. Use `npm run generate-html` to do the same but also generate HTML files that allow you to navigate through the folders.


MIT License
