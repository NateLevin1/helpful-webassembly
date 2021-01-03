// run in chrome browser so performance.now is accurate
var memory = new WebAssembly.Memory({initial:1});

const fillByIndex = ()=>{
    const array = new Array(10000);
    for(var i = 0; i < 10000; i++) {
        array[i] = i;
    }
}

let timeBetween = {};
fetch("array-benchmark.wasm")
.then(r=>r.arrayBuffer())
.then(buffer=>WebAssembly.instantiate(buffer, { js: { memory, "performance.now": (label)=>{timeBetween[label] ? console.log(performance.now() - timeBetween[label]) : timeBetween[label] = performance.now()} } }))
.then(wasm=>{
    let prevWasm = performance.now();
    wasm.instance.exports.main();
    let timeWasm = performance.now() - prevWasm;

    let prevJS = performance.now();
    for(var i = 0; i < 10000; i++) {
        fillByIndex();
    }
    let timeJS = performance.now() - prevJS;

    document.body.innerHTML += `<p class="bold">WASM:\n${timeWasm}</p><p class="bold">JS:\n${timeJS}</p>`;
});