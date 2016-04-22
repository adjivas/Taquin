(defvar *size* 0)
(defvar *linear-size* 0)
;struct: bord to get tile with position, x and y to get positions with tiles
(defstruct (puzzle (:conc-name p-))
  board x y)

(defun init-puzzle (size)
  "Function that take a size to initialize the puzzle struct arrays
  @args: int
  @return: puzzle"
  (make-puzzle
    :board (make-array (* size size) :element-type 'integer)
    :x (make-array (* size size) :element-type 'integer)
    :y (make-array (* size size) :element-type 'integer)))

;maybe improve this later?
(defun copy-array (array)
 (let ((dim (array-dimensions array)))
   (adjust-array
    (make-array dim :displaced-to array :element-type 'integer)
    dim)))

(defun copy-puzzle (p)
  "Take a puzzle and make a copy
  @args: p:puzzle
  @return: puzzle"
  (make-puzzle
    :board (copy-array (p-board p))
    :x (copy-array (p-x p))
    :y (copy-array (p-y p))))

;getters
(defun get-tile (p x y)
  (aref (p-board p) (+ x (* y *size*))))

(defun get-x (p tile)
  (aref (p-x p) tile))

(defun get-y (p tile)
  (aref (p-y p) tile))

;setters
(defun set-tile (p tile x y)
  (setf (aref (p-board p) (+ x (* y *size*))) tile))

(defun set-x (p tile x)
  (setf (aref (p-x p) tile) x))

(defun set-y (p tile y)
  (setf (aref (p-y p) tile) y))

(defun set-coord (p tile x y)
  (set-x p tile x)
  (set-y p tile y))

(defun swap-tiles (p x1 y1 x2 y2)
  "Take a puzzle and a tile to swap with blank tile
  @args: p:puzzle; x1:int; y1:int; x2:int; y2:int
  @return puzzle"
  (let* ((new (copy-puzzle p))
         (tile (get-tile new x2 y2)))
    (set-tile new 0 x2 y2)
    (set-tile new tile x1 y1)
    (set-coord new 0 x2 y2)
    (set-coord new tile x1 y1)
    (return-from swap-tiles new)))

;return a list of all possible puzzle permutation
(defun permutation-list (p size)
  "return a list of possible puzzle successors
  @args: p:puzzle; size:int
  @return: puzzle list"
  (let ((x (get-x p 0)) (y (get-y p 0)) (lst '()))
    (and (> x 0) (setq lst(cons (swap-tiles p x y (- x 1) y) lst)))
    (and (< x size) (setq lst (cons (swap-tiles p x y (+ x 1) y) lst)))
    (and (> y 0) (setq lst (cons (swap-tiles p x y x (- y 1)) lst)))
    (and (< y size) (setq lst (cons (swap-tiles p x y x (+ y 1)) lst)))
    lst)
  )

;make a structure from a list
(defun list-to-puzzle (lst size)
  (let ((puzzle (init-puzzle size)))
    (loop for i below size do
          (loop for j below size do
                (let ((n (+ i (* j size))))
                  (set-tile puzzle (nth n lst) i j)
                  (set-coord puzzle (nth n lst) i j))))
    puzzle))
