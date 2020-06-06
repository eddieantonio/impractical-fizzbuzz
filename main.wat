(module
  (memory (import "js" "mem") 1)
  (global $ptr (import "js" "ptr") (mut i32))
  (func $logBuffer (import "import" "logBuffer") (param i32))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; io ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; Writes a single character to the line. When a newline is seen, the buffer
  ;; is flushed and written to the screen
  (func $putchar (param $cp i32)
        ;; (uint32_t*) *ptr = cp
        (i32.store (global.get $ptr) (get_local $cp))
        ;; increment the ptr by the number of bytes in one codepoint
        (global.set $ptr (i32.add (global.get $ptr) (i32.const 4)))
        (if (i32.eq (local.get $cp) (i32.const 0x0A))
          ;; received newline; flush the buffer
          (then
            (call $logBuffer (i32.div_u (global.get $ptr) (i32.const 4)))
            (global.set $ptr (i32.const 0)))))

  ;; Returns non-zero (true) if buffer is empty
  (func $empty? (result i32)
        (i32.eq (global.get $ptr) (i32.const 0)))

  ;; Writes a single Mayan numeral to the line
  (func $putdigit (param $n i32)
       (call $putchar (i32.or (i32.const 0x1D2E0) (local.get $n))))

  ;; Writes a number to the line, as a Mayan numeral
  (func $itoa (param $n i32)
        (if (i32.lt_u (local.get $n) (i32.const 20))
          (then
            (call $putdigit (local.get $n)))
          (else
            (call $itoa (i32.div_u (local.get $n) (i32.const 20)))
            (call $putdigit (i32.rem_u (local.get $n) (i32.const 20))))))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; main ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (func $fizzbuzz (export "fizzbuzz")
        (local $i i32)
        (set_local $i (i32.const 1))

        (loop
          (if (i32.eq (i32.rem_u (get_local $i) (i32.const 3)) (i32.const 0))
            (then
              ;; fizz
              (call $putchar (i32.const 0x1043A))
              (call $putchar (i32.const 0x10432))
              (call $putchar (i32.const 0x10446))))
          (if (i32.eq (i32.rem_u (get_local $i) (i32.const 5)) (i32.const 0))
            (then
              ;; buzz
              (call $putchar (i32.const 0x10441))
              (call $putchar (i32.const 0x1042E))
              (call $putchar (i32.const 0x10446))))
          (if (call $empty?)
            ;; Haven't written anything yet? Then print the digit!
            (then
              (call $itoa (local.get $i))))

          ;; Finish it with a newline
          (call $putchar (i32.const 0x0A))

          ;; i++
          (set_local $i (i32.add (get_local $i) (i32.const 1)))
          ;; while (i <= 100)
          (br_if 0 (i32.le_s (get_local $i) (i32.const 100))))))
