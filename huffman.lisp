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
    (foldl str null
      (lambda (acc char) (append acc (encode-char char tree))))))

  (define decode (lambda (bits tree)
    (begin
      (define decode-char (lambda (bits subtree)
        (if (leaf? subtree)
          (cons (char subtree) (decode bits tree))
          (if (eql? (car bits) 0)
            (decode-char (cdr bits) (left subtree))
            (decode-char (cdr bits) (right subtree))))))
      (if (empty? bits)
        null
        (decode-char bits tree)))))

  (define quick-encode (lambda (msg)
    (begin
      (set! coding-tree 
        (build-tree (sort (pack (sort msg <)) tree-cmp)))
      (list (encode msg coding-tree) coding-tree))))

  (define center-chars (lambda (chars width)
    (if (< (length chars) (- width 1))
      (center-chars (append (append (list (quote .)) chars) (list (quote .))) width)
      chars)))

  (define render-nodes (lambda (tree width)
    (if (leaf? tree)
      (list (center-chars (chars tree) width))
      (append 
        (list (center-chars (chars tree) width))
        (append
          (render-nodes (left tree) (/ width 2))
          (render-nodes (right tree) (/ width 2)))))))

  (define traverse-tree (lambda (tree f depth acc)
    (if (empty? tree)
      acc
      (traverse-tree 
        (left tree) f (+ depth 1)
        (traverse-tree 
          (right tree) f (+ depth 1) 
          (f acc depth (chars tree)))))))

  (define msg (quote (h e l l o _ w o r l d)))
  (define sorted-msg (sort msg <))
  (define packed (pack sorted-msg))
  (define sorted-leaves (sort packed tree-cmp))
  (define coding-tree (build-tree sorted-leaves))
  (define encoded-r (encode-char (quote r) coding-tree))
  (define encoded (encode msg coding-tree))
  (define decoded (decode encoded coding-tree))  

  (define centered (center-chars (quote (a b c)) 50))
  (define rendered-nodes (render-nodes coding-tree 50))

  (define traversed
    (traverse-tree coding-tree (lambda (acc depth chars) (cons depth acc)) 0 null))
)