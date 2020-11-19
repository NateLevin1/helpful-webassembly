(module
    ;; import memory
    (import "js" "memory" (memory 1))

    (;
     Make an array given where it should go and its length. All it does is store the length.
     @param newOffset {i32} The position in memory the length bytes should be at
     @param arrayLength {i32} The length of the array
    ;)
    (func $makeArray (param $newOffset i32) (param $arrayLength i32)
        (i32.store (local.get $newOffset) (local.get $arrayLength) ) ;; store length
    )
)