(begin
  (define leaf (lambda (char weight)
    (list (list char) weight null null)))

  (define fork (lambda (chars weight left right)
    (list chars weight left right)))

  (define leaf? (lambda (tree)
    (and (null? (left tree)) (null? (right tree)))))

  (define weight (lambda (tree)
    (car (cdr tree))))

  (define char (lambda (leaf)
    (car (chars leaf))))

  (define chars (lambda (tree)
    (car tree)))

  (define left (lambda (tree)
    (car (cdr (cdr tree)))))

  (define right (lambda (tree)
    (car (cdr (cdr (cdr tree))))))

  (define pack (lambda (string)
    (begin
      (define pack-acc (lambda (s t)
       (if (empty? s)
        (cons t null)
        (if (empty? t)
         (pack-acc (cdr s) (leaf (car s) 1))
         (if (eql? (car s) (char t))
          (pack-acc (cdr s) (leaf (char t) (+ (weight t) 1)))
          (cons t (pack-acc s null)))))))
      (pack-acc string null))))

  (define tree-cmp (lambda (t1 t2)
    (< (weight t1) (weight t2))))

  (define combine-chars (lambda (t1 t2)
    (append (chars t1) (chars t2))))

  (define combine-weights (lambda (t1 t2)
    (+ (weight t1) (weight t2))))

  (define combine (lambda (t1 t2)
    (fork
      (combine-chars t1 t2)
      (combine-weights t1 t2)
      t1
      t2)))

  (define build-tree (lambda (trees)
    (if (singleton? trees)
      (car trees)
      (build-tree
        (merge 
          (combine (car trees) (cadr trees))
          (cddr trees)
          tree-cmp)))))

  (define encode-char (lambda (char tree)
    (if (leaf? tree)
      null
      (if (contains? (chars (left tree)) char)
        (cons 0 (encode-char char (left tree)))
        (cons 1 (encode-char char (right tree)))))))

  (define encode (lambda (str tree)
    (foldl
      str
      null
      (lambda (acc char) (append acc (encode-char char tree))))))

  (define msg (quote (h e l l o _ w o r l d)))
  (define sorted-msg (sort msg <))
  (define packed (pack sorted-msg))
  (define sorted-leaves (sort packed tree-cmp))
  (define coding-tree (build-tree sorted-leaves))
  (define encoded-r (encode-char (quote r) coding-tree))
  (define encoded (encode msg coding-tree))
)