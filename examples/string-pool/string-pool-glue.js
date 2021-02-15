var memory = new WebAssembly.Memory({initial:1});

const fs = require("fs");

const stringData = ["hello", "world"];
const stringPool = [];

const wasmInstance =
      WebAssembly.instantiate(new Uint8Array(fs.readFileSync("./string-pool.wasm")), {
        js: {
          memory,
          newString: (dataOffset)=>{
            stringPool.push(stringData[dataOffset]);
            return stringPool.length - 1; // returns index of string
          },
          appendToString: (addType, poolIndex, addValue)=>{
                let cur = stringPool[poolIndex];
                switch(addType) {
                    case 0:
                        // addValue = pointer to string literal in data
                        stringPool[poolIndex] = `${cur}${stringPool[addValue]}`;
                        break;
                    case 1:
                        // addValue = pointer to string literal in pool
                        stringPool[poolIndex] = `${cur}${stringData[addValue]}`;
                        break;
                    case 2:
                        // addValue = pointer to number
                        stringPool[poolIndex] =  `${cur}${new Float32Array(memory.buffer, addValue, 1)[0]}`;
                        break;
                    case 3:
                        // addValue = number
                        stringPool[poolIndex] = `${cur}${addValue}`;
                        break;
                    default:
                        throw `Unknown addType ${addType}`;
                }
            },
            printString: (poolIndex)=>{
                console.log(stringPool[poolIndex]);
            }
        }
      }).then(({ instance })=>{
        const { main } = instance.exports;
        main();
      });