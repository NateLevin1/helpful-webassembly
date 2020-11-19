(module
    ;; import memory
    (import "js" "memory" (memory 1))
    (import "js" "throwString" (func $jsThrowString (param $offset i32)) )

    (;
     Throws a string error given the string's offset.
     Use this for custom errors.
     @param offset {i32} The offset of the string
    ;)
    (func $throwString (param $offset i32)
        local.get $offset
        call $jsThrowString
        unreachable
    )

    (export "throwString" (func $throwString))
)