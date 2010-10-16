
(task "build" is
      (SH "nush builder.nu"))

(task "preview" is 
      (SH "nunjad -s site"))

(task "publish" is 	
      (SH "rsync -av site/public/ /home/nu/site/public/"))

;; requires a password
;;    (SH "rsync -ave ssh site/public/ programming.nu:/projects/sites/programming.nu/public/"))

(task "clean" is
      (SH "rm -rf site"))

(task "default" => "build")

