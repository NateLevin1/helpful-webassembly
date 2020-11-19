var memory = new WebAssembly.Memory({initial:1});

const errors = [
"A generic error was thrown",
"Segmentation fault (core dumped)",
"Attempted to index out of an array's bounds",
"Attempted to index out of an string's bounds"
]

const wasmInstance =
      new WebAssembly.Instance(wasmModule, {
      	console: {
          	logStringWithLength: (offset, length)=>{
              	const string = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset+4/*<- 4 is the length in Uint8s of an int32*/, length));
              	console.log(string);
            },
         	logString: (offset)=>{
              	// console.log("offset: "+offset+" arr: "+new Int32Array(memory.buffer, 0));
              	const length = new Int32Array(memory.buffer, offset, 1)[0];
            	const string = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset+4/*<- 4 is the length in Uint8s of an int32*/, length));
              	console.log(string);
            },
          	logIntFromOffset: (offset)=>{
            	console.log(new Int32Array(memory.buffer, offset, 1));
            },
          	logInt: (int)=>{
              console.log(int)
            },
          	debugMemory: ()=>{
              console.log("memory: "+new Int32Array(memory.buffer, 0));
            }
        },
        js: {
          memory,
          throw: (errNo)=>{
          	throw errors[errNo];
          },
          throwString: (offset)=>{
          	const length = new Int32Array(memory.buffer, offset, 1)[0];
            const string = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset+4/*<- 4 is the length in Uint8s of an int32*/, length));
            throw string;
          }
        }
      });
const { main } = wasmInstance.exports;
main();