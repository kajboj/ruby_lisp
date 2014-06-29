(begin
  (define null (list))
  (define true (quote t))
  (define false null)

  (define empty? (lambda (l)
    (eql? l null)))

  (define contains? (lambda (lst elem)
    (if (empty? lst)
      false
      (if (eql? (car lst) elem)
        true
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

  (define and (lambda (a b)
    (if a
      (if b true false)
      false)))

  (define or (lambda (a b)
    (if a
      true
      (if b true false))))

  (define map (lambda (lst f)
    (if (empty? lst)
      null
      (cons (f (car lst)) (map (cdr lst) f)))))

  (define foldl (lambda (lst acc f)
    (if (empty? lst)
      acc
      (foldl (cdr lst) (f acc (car lst)) f))))
)