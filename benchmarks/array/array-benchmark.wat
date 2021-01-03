(module
    ;; This benchmark tests the speed of array operations in wasm vs js.
    ;; by my testing it seems WASM (including call stack) is faster by ~0.5 ms. Adding the call stack slows it down by ~0.3 ms.

    ;; import memory
    (import "js" "memory" (memory 1))

    (global $arrLength i32 (i32.const 10000))

    (func $fillArr (export "fill")
        (local $index i32)
        (local $arr i32)
        
        call $initStack
        (i32.mul (global.get $arrLength) (i32.const 4))
call $stackAllocate ;; each member of arr is 4 bytes long
        local.set $arr

        (local.set $index (i32.const 0))
        loop
            ;; bit janky because the condition is checked after. how else to do this?
            (i32.store (i32.add (local.get $index) (local.get $arr) ) (local.get $index))

            ;; increment
            (local.set $index (i32.add (local.get $index) (i32.const 1)))

            (local.get $index)
            global.get $arrLength
            i32.lt_u
            br_if 0
        end
        call $terminateStack
    )

    (func (export "main")
        (local $i i32)

        ;; execute fill 10,000 times
        (local.set $i (i32.const 0))
        loop
            call $fillArr
            
            (local.set $i (i32.add (local.get $i) (i32.const 1)))

            (local.get $i)
            (i32.const 10000)
            i32.lt_u
            br_if 0
        end
    )

    (global $STACK_POINTER (mut i32) (i32.const 8))
    (global $FRAME_POINTER (mut i32) (i32.const 8))
    (global $STACK_ORIGIN i32 (i32.const 8))

    ;; initalize the stack frame
    (func $initStack
        (local $prevFramePointer i32)
        (local.set $prevFramePointer (global.get $FRAME_POINTER) )

        (global.set $FRAME_POINTER (global.get $STACK_POINTER) )

        ;; Store the previous frame's location as the first item in the new frame
        i32.const 4 ;; i32
        call $stackAllocate
        local.get $prevFramePointer
        i32.store
    )
    (func $terminateStack
        ;; the previous frame's location is the first 4 bytes of the current frame
        (global.set $STACK_POINTER (global.get $FRAME_POINTER) )
        (global.set $FRAME_POINTER (i32.load (global.get $FRAME_POINTER)) )
    )
    (func $stackAllocate
        (param $length i32) ;; length in bytes
        (result i32) ;; offset in memory
        (local $allocatedPtr i32)

        ;; set the location of the allocated memory
        (local.set $allocatedPtr (global.get $STACK_POINTER) )

        ;; update the stack pointer
        (global.set $STACK_POINTER (i32.add (global.get $STACK_POINTER) (local.get $length) ))
        
        ;; return the location of the allocated memory
        local.get $allocatedPtr
    )
)