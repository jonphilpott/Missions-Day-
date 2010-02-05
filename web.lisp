(in-package :missionsday)

(defvar *server*
  (make-instance 'hunchentoot:acceptor :port 8080))

(defvar *tv-total* 0)
(defvar *year-goal* 45000)

(hunchentoot:start *server*)

(setf hunchentoot:*show-lisp-errors-p* t)

(push 
 (create-prefix-dispatcher "/search" 'ajax-search)
 hunchentoot:*dispatch-table*)

(push 
 (create-prefix-dispatcher "/enter" 'ajax-enter)
 hunchentoot:*dispatch-table*)

(push 
 (create-prefix-dispatcher "/total" 'ajax-total)
 hunchentoot:*dispatch-table*)


(push 
 (create-prefix-dispatcher "/updatetv" 'ajax-updatetv)
 hunchentoot:*dispatch-table*)

(push 
 (create-prefix-dispatcher "/tvtotal" 'ajax-tvtotal)
 hunchentoot:*dispatch-table*)


(push 
 (create-folder-dispatcher-and-handler "/static/" "./static/")
 hunchentoot:*dispatch-table*)





(defun obj->json (obj)
  (with-output-to-string (str)
    (json:encode-json obj str)))

(defun ajax-search ()
  (let ((name (parameter "name")))
    (if name
        (obj->json (matching-contributors name)))))
            

(defun ajax-enter ()
  (let ((id      (parameter "id"))
        (new     (parameter "new"))
        (amount  (parameter "year")))
    (when (and (cl-ppcre:scan "^[0-9.]+$" amount)
               (cl-ppcre:scan "^[0-9.]+$" id))
        (if (and (zerop  (length new))
                 (>      (parse-integer id) 0))
            (update-pledge id amount)
            (new-pledge new amount))
      "success")))

(defun ajax-total ()
  (obj->json (get-current-total)))

(defun ajax-updatetv ()
  (let ((amount (parameter "amount")))
    (setf *tv-total* (read-from-string amount))))

(defun ajax-tvtotal ()
  (obj->json (list *tv-total* *year-goal*)))



