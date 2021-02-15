(module
    ;; this should print
    ;; helloworldworld100.5100
    (import "js" "memory" (memory 1))
    (import "js" "newString" (func $js.newString (param $dataOffset i32) (result i32)))
    (import "js" "appendToString" (func $js.appendToString (param $poolIndex i32) (param $addType i32) (param $addValue i32)))
    (import "js" "printString" (func $js.printString (param $poolIndex i32)))
    (func (export "main")
        (local i32 i32)

        i32.const 0 ;; "hello"
        call $js.newString
        local.set 0

        i32.const 1 ;; "world"
        call $js.newString
        local.set 1

    ;; APPENDING
        i32.const 0
        local.get 0
        i32.const 1
        call $js.appendToString

        i32.const 1
        local.get 0
        local.get 1
        call $js.appendToString

        i32.const 2
        local.get 0
        i32.const 0
        f32.const 100.5
        f32.store
        i32.const 0
        call $js.appendToString

        i32.const 3
        local.get 0
        i32.const 100
        call $js.appendToString

        local.get 0
        call $js.printString
    )
)