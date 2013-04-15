(set appname "ProgrammingNu")

(task "build" is
      (SH "nush builder.nu"))

(task "clean" is
      (SH "rm -rf site"))

(task "zip" => "build" is
      (SH "rm -rf build/#{appname}.app")
      (SH "mkdir -p build/#{appname}.app")
      (SH "cp -r #{appname} build/#{appname}.app/#{appname}")
      (SH "cp -r public build/#{appname}.app")
      (SH "cd build; zip -r #{appname}.zip #{appname}.app"))

(task "default" => "zip")


