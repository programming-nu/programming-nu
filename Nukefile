
(task "build" is
      (SH "nush builder.nu"))

(task "pub" is 
      (SH "cd public; git init; git add .; git commit -a -m \"Initial commit.\"; git push git@github.com:programming-nu/programming-nu.github.io master -f"))

(task "clean" is
      (SH "rm -rf site"))

(task "default" => "build")


