(module
    ;; import memory
    (import "js" "memory" (memory 1))
    (import "js" "throwString" (func $jsThrowString (param $offset i32)) )

    (func $throwString (param $offset i32)
        local.get $offset
        call $jsThrowString
        unreachable
    )

    (export "throwString" (func $throwString))
)