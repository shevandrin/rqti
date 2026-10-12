(in-package :maxima)
(defun $rqti_json_string (s)
  (with-output-to-string (out)
    (write-char #\" out)
    (loop for c across s do
      (case c
        (#\" (write-string "\\\"" out))
        (#\\ (write-string "\\\\" out))
        (otherwise (if (< (char-code c) 32)
                       (format out "\\u~4,'0x" (char-code c))
                       (write-char c out)))))
    (write-char #\" out)))
