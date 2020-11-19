(module
    ;; import memory
    (import "js" "memory" (memory 1))
    (import "js" "throw" (func $jsThrow (param $errNo i32)) )

    (func $throw (param $errNo i32)
        local.get $errNo
        call $jsThrow
        unreachable
    )
    
    (export "throw" (func $throw))
)