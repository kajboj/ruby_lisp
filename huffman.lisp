(begin
  (define null (list))

  (define leaf 
    (lambda (char weight) (list char weight null null)))

  (define fork 
    (lambda (chars weight left right) (list chars weight left right)))

  (define weight
    (lambda (tree) (car (cdr tree))))

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

  (define tree-cmp 
    (lambda (t1 t2)
      (> (weight t1) (weight t2))))

  (define pack
    (lambda (s t)
     (if (empty? s)
      (cons t null)
      (if (empty? t)
       (pack (cdr s) (leaf (car s) 1))
       (if (eql? (car s) (chars t))
        (pack (cdr s) (leaf (chars t) (+ (weight t) 1)))
        (cons t (pack s null)))))))

  (define msg (quote (h e l l o _ w o r l d)))
  (define sorted (sort msg null <))
  (define packed (pack sorted null))
)