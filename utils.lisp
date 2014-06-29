(begin
  (define null (list))

  (define empty? (lambda (l)
    (eql? l null)))

  (define contains? (lambda (lst elem)
    (if (empty? lst)
      null
      (if (eql? (car lst) elem)
        1
        (contains? (cdr lst) elem)))))

  (define cadr (lambda (list) (car (cdr list))))
  (define cddr (lambda (list) (cdr (cdr list))))

  (define singleton? (lambda (xs)
    (eql? (length xs) 1)))

  (define merge (lambda (elem sorted cmp)
   (if (empty? sorted)
    (cons elem null)
    (if (cmp elem (car sorted))
     (cons elem sorted)
     (cons (car sorted) (merge elem (cdr sorted) cmp))))))

  (define sort (lambda (unsorted cmp)
   (begin
    (define sort-acc (lambda (unsorted sorted cmp)
     (if (empty? unsorted)
      sorted
      (if (empty? sorted)
       (sort-acc (cdr unsorted) (cons (car unsorted) null) cmp)
       (sort-acc (cdr unsorted) (merge (car unsorted) sorted cmp) cmp)))))
    (sort-acc unsorted null cmp))))
)