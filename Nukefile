

(task "build" is
      (SH "nush builder.nu"))

(task "publish" is
      (SH "rsync -ave ssh site/public/ helium:/Sites/programming.nu/public/"))

(task "default" => "build")

(task "clean" is
      (SH "rm -rf site"))
