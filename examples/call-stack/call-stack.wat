(module
    ;; import console helper functions
    (import "console" "logInt" (func $console.logInt (param i32)))
    (import "console" "logString" (func $console.logString (param i32)))
    (import "console" "debugMemory" (func $console.debugMemory ))
    
    ;; import memory
    (import "js" "memory" (memory 1))

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
        ;; DEBUG BELOW! (REMOVE FOR PROD)
        ;; the reason this is debug is because
        ;; we can just we can just mark it as free
        ;; this loop will set all the bytes equal to 0
            ;; only run if the stack has some content
            global.get $FRAME_POINTER
            global.get $STACK_POINTER
            i32.lt_u
            if
                loop
                    ;; set currently pointed at to 0 until frame pointer reached
                    (global.set $STACK_POINTER (i32.sub (global.get $STACK_POINTER) (i32.const 1) ) )
                    (i32.store8 (global.get $STACK_POINTER) (i32.const 0) )
            
                    ;; this will re-run the loop if they aren't equal
                    global.get $FRAME_POINTER
                    global.get $STACK_POINTER
                    i32.lt_u
                    br_if 0
                end
            end
        ;; DEBUG ABOVE! (REMOVE FOR PROD)

        ;; the previous frame's location is the first 4 bytes of the current frame
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

    (func (export "main") 
        call $initStack

        i32.const 4
        call $stackAllocate
        i32.const 1
        i32.store

        i32.const 4
        call $stackAllocate
        i32.const 2
        i32.store

        call $console.debugMemory

        call $example

        call $terminateStack
        call $console.debugMemory
    )
    (func $example
        call $initStack
        i32.const 4
        call $stackAllocate
        i32.const 3
        i32.store
        call $console.debugMemory

        call $terminateStack
        call $console.debugMemory
    )
)