(asdf:defsystem #:missionsday
  :depends-on (:cl-ppcre
               :hunchentoot
               :cl-json
               :clsql)
  :components ((:file "packages")
	       (:file "web"
		      :depends-on ("packages"))
	       (:file "data"
		      :depends-on ("packages"))))

