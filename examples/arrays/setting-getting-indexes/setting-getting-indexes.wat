(module
  ;; import console helper functions
  (import "console" "logInt" (func $console.logInt (param i32)))
  (import "console" "debugMemory" (func $console.debugMemory ))
  
  ;; import memory
  (import "js" "memory" (memory 1))
  
  (func $makeArray (param $newOffset i32) (param $arrayLength i32)
  	(i32.store (local.get $newOffset) (local.get $arrayLength) ) ;; store length
  )
  
  (func $getPointerToIndexOfArray (param $offset i32) (param $index i32) (param $bytesInItem i32) (result i32)
    (local $length i32)
    (local $startOfArray i32)
    (local.set $length (i32.load (local.get $offset)) )
    (local.set $startOfArray (i32.add (local.get $offset) (i32.const 1)) ) ;; start of array is equal to offset + the length of the length counter
    ;; the mul below is so that it increases the amount it needs to every time (e.g we don't end up indexing from the second byte of an i32)
    (return (i32.add (local.get $startOfArray) (i32.mul (local.get $index) (local.get $bytesInItem))) )
  )
  
  (func (export "main")
    ;; TODO: Exceptions (index out of bounds)
    
    ;; ARRAY SETUP
    i32.const 0 ;; array offset
    i32.const 4 ;; 4 long array
    call $makeArray
    
    ;; SET VALUE AT INDEX
    i32.const 0 ;; offset
    i32.const 0 ;; index
    i32.const 4 ;; sizeof i32
    call $getPointerToIndexOfArray ;; get the index
    i32.const 1234
    i32.store ;; store the number 1234 at the index
    
    ;; GET VALUE AT INDEX
    i32.const 0 ;; offset
    i32.const 0 ;; index
    i32.const 4 ;; sizeof i32
    call $getPointerToIndexOfArray ;; get the index
    i32.load ;; push the index's value onto the stack
    call $console.logInt ;; log the value
    
    
    ;; show memory
    call $console.debugMemory
    )
)