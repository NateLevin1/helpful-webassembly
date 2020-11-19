(module
    ;; import memory
    (import "js" "memory" (memory 1))

    (;
     Copy a location in memory to another location in memory.
     @param currentOffset {i32} The offset of the location in memory wanted to be copied
     @param newOffset {i32} The offset of the location where memory should be copied to
     @param length {i32} How many i32s to copy from currentOffset - note that not only i32s can be copied, just that it must be copied 4 bytes at a time
    ;)
    (func $copy (param $currentOffset i32) (param $newOffset i32) (param $length i32) (local $i i32)
        (local.set $i (i32.const 0))
        loop $l
        
            (i32.store (i32.add (local.get $newOffset) (local.get $i)) (i32.load (i32.add (local.get $currentOffset) (local.get $i))) )
        
            (local.set $i (i32.add (i32.const 1) (local.get $i)) )
            local.get $i
            local.get $length
            i32.le_u
            br_if $l
        end
    )
    
    (export "copy" (func $copy))
)