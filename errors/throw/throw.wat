(module
    ;; import memory
    (import "js" "memory" (memory 1))
    (import "js" "throw" (func $jsThrow (param $errNo i32)) )

    (;
     Throws an error given the error's number
     @param errNo {i32} The number of the error / The index of the error in the `errors` array.
    ;)
    (func $throw (param $errNo i32)
        local.get $errNo
        call $jsThrow
        unreachable
    )
    
    (export "throw" (func $throw))
)