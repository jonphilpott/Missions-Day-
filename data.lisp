(in-package :missionsday)


(clsql:connect '("missions.db") :database-type :sqlite3)

(clsql:enable-sql-reader-syntax)


(defun import-data (import-file) 
  (clsql:with-transaction ()
    (with-open-file (in import-file)
      (loop for line = (read-line in nil)
         while line do
           (let ((res (ppcre:split "," line)))
             (clsql:insert-records :into        [pledges]
                                   :attributes  '(id name amount)
                                   :values      (list (nth 0 res)
                                                      (nth 1 res)
                                                      0)))))))


(defun get-all-pledges ()
  (select [id] [name] [amount] 
          :from [pledges]
          :field-names nil))

(defun get-current-total ()
  (coerce (car (select [sum [amount]]
                       :from [pledges]
                       :flatp t
                       :field-names nil))
          'single-float))


(defun update-pledge (id amount)
  (update-records [pledges]
                  :attributes '(amount)
                  :values     (list amount)
                  :where      [= [id] id]))
  
(defun new-pledge (name amount)
  (insert-records :into [pledges]
                  :attributes '([name] [amount])
                  :values     (list name amount)))
          

(defun matching-contributors (name) 
  (select [id] [name] [amount]
          :from [pledges]
          :where [like [name] (concatenate 'string "%" name "%")]
          :field-names nil))
          
                                   
         


(disable-sql-reader-syntax)



