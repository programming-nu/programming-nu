
(task "build" is
      (SH "nush builder.nu"))

(task "preview" is 
      (SH "nunjad -s site"))

(task "publish" is 	;; requires a password
      (SH "rsync -ave ssh site/public/ programming.nu:/Sites/programming.nu/public/"))

(task "clean" is
      (SH "rm -rf site"))

(task "default" => "build")

