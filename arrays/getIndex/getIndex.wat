(module
    ;; import memory
    (import "js" "memory" (memory 1))

    ;; import getPointerToIndexOfArray func
    (import "wasm" "getPointerToIndexOfArray" (func $getPointerToIndexOfArray (param i32 i32 i32)(result i32)))

    (;
     Gets an i32 value at the specified array's index
     @param arrayOffset {i32} Offset of the array in memory
     @param index {i32} The index of the array that should have its value got

     @depends-on getPointerToIndexOfArray
    ;)
    (func $getIndexI32 (param $arrayOffset i32) (param $index i32) (result i32)
        local.get $arrayOffset
        local.get $index
        i32.const 4 ;; the number of bytes in an i32
        call $getPointerToIndexOfArray ;; get the index
        i32.load ;; push the number at the index on to the stack
    )

    (export "getIndexI32" (func $getIndexI32))
)