(begin
  (define null (list))

  (define leaf 
    (lambda (char weight) (list (list char) weight null null)))

  (define fork 
    (lambda (chars weight left right) (list chars weight left right)))

  (define weight
    (lambda (tree) (car (cdr tree))))

  (define char
    (lambda (leaf) (car (chars leaf))))

  (define chars
    (lambda (tree) (car tree)))

  (define empty?
    (lambda (l) (eql? l null)))

  (define merge 
    (lambda (elem sorted cmp)
     (if (empty? sorted)
      (cons elem null)
      (if (cmp elem (car sorted))
       (cons elem sorted)
       (cons (car sorted) (merge elem (cdr sorted) cmp))))))

  (define sort 
    (lambda (unsorted sorted cmp)
     (if (empty? unsorted)
      sorted
      (if (empty? sorted)
       (sort (cdr unsorted) (cons (car unsorted) null) cmp)
       (sort (cdr unsorted) (merge (car unsorted) sorted cmp) cmp)))))

  (define pack
    (lambda (s t)
     (if (empty? s)
      (cons t null)
      (if (empty? t)
       (pack (cdr s) (leaf (car s) 1))
       (if (eql? (car s) (char t))
        (pack (cdr s) (leaf (char t) (+ (weight t) 1)))
        (cons t (pack s null)))))))

  (define tree-cmp 
    (lambda (t1 t2)
      (< (weight t1) (weight t2))))

  (define cadr (lambda (list) (car (cdr list))))
  (define cddr (lambda (list) (cdr (cdr list))))

  (define singleton? 
    (lambda (xs) (eql? (length xs) 1)))

  (define combine-chars
    (lambda (t1 t2)
      (append (chars t1) (chars t2))))

  (define combine-weights
    (lambda (t1 t2)
      (+ (weight t1) (weight t2))))

  (define combine
    (lambda (t1 t2) 
      (fork
        (combine-chars t1 t2)
        (combine-weights t1 t2)
        t1
        t2)))

  (define build-tree 
    (lambda (trees)
      (if (singleton? trees)
        (car trees)
        (build-tree
          (merge 
            (combine (car trees) (cadr trees))
            (cddr trees)
            tree-cmp)))))

  (define msg (quote (h e l l o _ w o r l d)))
  (define sorted-msg (sort msg null <))
  (define packed (pack sorted-msg null))
  (define sorted-leaves (sort packed null tree-cmp))
  (define coding-tree (build-tree sorted-leaves))
)