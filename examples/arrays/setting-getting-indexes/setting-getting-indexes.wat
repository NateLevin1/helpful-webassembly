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
  (;
   Sets an i32 value at the specified array's index
   @param arrayOffset {i32} Offset of the array in memory
   @param index {i32} The index of the array that should have its value changed
   @param newValue {i32} The value that should be set as the index's value
  ;)
  (func $setIndexI32 (param $arrayOffset i32) (param $index i32) (param $newValue i32)
    local.get $arrayOffset
    local.get $index
    i32.const 4 ;; the number of bytes in an i32
    call $getPointerToIndexOfArray ;; get the index
    local.get $newValue
    i32.store ;; store the number 1234 at the index
  )
  
  (;
   Gets an i32 value at the specified array's index
   @param arrayOffset {i32} Offset of the array in memory
   @param index {i32} The index of the array that should have its value got
  ;)
  (func $getIndexI32 (param $arrayOffset i32) (param $index i32) (result i32)
    local.get $arrayOffset
    local.get $index
    i32.const 4 ;; the number of bytes in an i32
    call $getPointerToIndexOfArray ;; get the index
    i32.load ;; push the number at the index on to the stack
  )
  
  (func (export "main")
    ;; TODO: errors (index out of bounds)
    
    ;; ARRAY SETUP
    i32.const 0 ;; array offset
    i32.const 4 ;; 4 long array
    call $makeArray
    
    ;; SET VALUE AT INDEX
    i32.const 0 ;; offset
    i32.const 0 ;; index
    i32.const 1234 ;; new value
    call $setIndexI32
    
    ;; GET VALUE AT INDEX
    i32.const 0 ;; offset
    i32.const 0 ;; index
    call $getIndexI32
    call $console.logInt ;; log the value
    
    
    ;; show memory
    call $console.debugMemory
    )
)