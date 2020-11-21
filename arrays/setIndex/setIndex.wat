(module
    ;; import memory
    (import "js" "memory" (memory 1))

    ;; import getPointerToIndexOfArray func
    (import "wasm" "getPointerToIndexOfArray" (func $getPointerToIndexOfArray (param i32 i32 i32)(result i32)))

    (;
     Sets an i32 value at the specified array's index
     @param arrayOffset {i32} Offset of the array in memory
     @param index {i32} The index of the array that should have its value changed
     @param newValue {i32} The value that should be set as the index's value
    ;)
    (func $setIndexI32 (param $arrayOffset i32) (param $index i32) (param $newValue i32)
        local.get $arrayOffset
        local.get $index
        i32.const 4 ;; the number of bytes in an i32
        call $getPointerToIndexOfArray ;; get the index
        local.get $newValue
        i32.store ;; store the number 1234 at the index
    )
    
    (export "setIndexI32" (func $setIndexI32))
)