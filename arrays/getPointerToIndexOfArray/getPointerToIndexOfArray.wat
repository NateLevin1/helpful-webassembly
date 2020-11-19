(module
    ;; import memory
    (import "js" "memory" (memory 1))

    (;
     Get a pointer to the specified index of an array. Returns the pointer.
     @param offset {i32} Pointer to the array
     @param index {i32} The index that the returned pointer should be at
     @param bytesInItem {i32} The number of bytes in each item. For example, for an i32 this should be 4, and for an i64 this should be 8.

     @result {i32} The pointer to the index.
    ;)
    (func $getPointerToIndexOfArray (param $offset i32) (param $index i32) (param $bytesInItem i32) (result i32)
        (local $length i32)
        (local $startOfArray i32)
        (local.set $length (i32.load (local.get $offset)) )
        (local.set $startOfArray (i32.add (local.get $offset) (i32.const 1)) ) ;; start of array is equal to offset + the length of the length counter
        ;; the mul below is so that it increases the amount it needs to every time (e.g we don't end up indexing from the second byte of an i32)
        (return (i32.add (local.get $startOfArray) (i32.mul (local.get $index) (local.get $bytesInItem))) )
    )

    (export "getPointerToIndexOfArray" (func $getPointerToIndexOfArray))
)