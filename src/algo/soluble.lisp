(deftype soluble () '(member solvable unsolvable))

(defun soluble_out_of_xy (width pos)
    (let ((x (- pos (* (floor (/ pos width)) width)))
          (y (floor (/ pos width))))
      (+ (* y width) x)
    )
)

(defun soluble_inversion (acc cells)
  "Function that count the number of inversion
   @args: acc:int cells:list
   @return: (boolean)"

   (if (not (> (length cells) 0))
     acc
     (let ((first (pop cells)))
        (if (> first 0)
           (progn
             (loop for cell in cells do
               (if (and (> first cell) (> cell 0))
                (incf acc)
               )
             )
           )
        )
        (soluble_inversion acc cells)
     )
  )
)

(defun soluble_index_pos (acc index cells)
  "Function that found the position of index
   @args: acc:int index:int cells:list
   @return: (int)"

  (if (and (> (length cells) 0) (not (eq (pop cells) index)))
    (soluble_index_pos (+ acc 1) index cells)
    acc))

(defun soluble_solve! (start_inversion end_inversion)
  "Function that check if the board is resolvable
   @args: start_cells:list end_cells:list
   @return: (boolean)"

  (if (eq (mod start_inversion 2) (mod end_inversion 2))
      :solvable
      :unsolvable))

(defun is_solvable (start_cells end_cells width)
  "Function that determine if the board is resolvable
   @args: start_cells:list end_cells:list width:int
   @return: (boolean)"

  (let ((start_inversion (soluble_inversion 0 start_cells))
        (end_inversion (soluble_inversion 0 end_cells)))
    (if (eq (mod width 2) 0)
      (soluble_solve! (+ start_inversion
                        (floor (/ (soluble_out_of_xy width (soluble_index_pos 0 0 start_cells)) width)))
                      (+ end_inversion
                        (floor (/ (soluble_out_of_xy width (soluble_index_pos 0 0 end_cells)) width))))
      (soluble_solve! start_inversion end_inversion))))
