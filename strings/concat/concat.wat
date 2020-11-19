(module
    ;; import memory
    (import "js" "memory" (memory 1))
    
    ;; import copy func
    (import "wasm" "copy" (func $copy (param i32 i32 i32)) )

    (;
     Concatenate two strings given their offsets and length.
     Creates an entirely new string.
     @param offset1 {i32} The offset of the first string
     @param length1 {i32} The length of the first string
     @param offset2 {i32} The offset of the second string
     @param length2 {i32} The length of the second string
     @param newOffset {i32} The offset where the new string should be made
     @result {i32} The length of the created string. If you don't want to use it you can just `drop` after calling. Equal to length1+length2

     @depends-on copy
    ;)
    (func $strConcat 
    (param $offset1 i32) (param $length1 i32)
    (param $offset2 i32) (param $length2 i32)
    (param $newOffset i32) (result i32)
    (local $newLength i32)
    
    
    local.get $offset1
    local.get $newOffset
    local.get $length1
    call $copy
    (i32.add (i32.const 1) (local.get $offset2) )
    (i32.add (local.get $newOffset) (i32.add (i32.const 4 (; size of the length int ;) ) (local.get $length1)) )
    local.get $length2
    call $copy
    
    (local.set $newLength (i32.add (local.get $length1) (local.get $length2)) )
    
    (i32.store (local.get $newOffset) (i32.add (local.get $newLength) (i32.const 4)) )
    
    local.get $newLength
  )

  (export "strConcat" (func $strConcat))
)