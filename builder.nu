;; site builder

(set $siteName "programming.nu")
(set $siteTitle "Programming Nu")
(set $siteSubtitle "Website for the Nu programming language.")
(set $siteDescription "The Nu Language Website")
(set $siteAddress "http://programming.nu")

(load "RadKit")
(load "template")
;(load "NuMarkdown")

(class NSObject (+ objectWithYAML:(id) yaml is (yaml YAMLValue)))

(class NSString
     (- (id) markdownToHTML is
        (set x (NSString stringWithShellCommand:"markdown" standardInput:(self dataUsingEncoding:NSUTF8StringEncoding)))
	x))

 ;    (- (id) markdownToHTML is self)) ;; (NuMarkdown convert:self)))
     
(class NSDictionary
     
     (- (id) bodyAsHTML is
        (set body (self valueForKey:"body"))
        (case (self valueForKey:"format")
              ("markdown" (body markdownToHTML))
              (else body)))
     
     (- (id) extendedAsHTML is
        (set extended (self valueForKey:"extended"))
        (case (self valueForKey:"format")
              ("markdown" (extended markdownToHTML))
              (else extended))))     

(class NSDate
     
     (- descriptionWithCalendarFormat:format is
	(self descriptionWithCalendarFormat:format timeZone:(NSTimeZone timeZoneWithName:"America/Los_Angeles") locale:nil))

     ;; Get a nice representation of a date for display.
     (- descriptionForBlog is
        (set s (self descriptionWithCalendarFormat:"%A %B %e, %Y" timeZone:(NSTimeZone timeZoneWithName:"America/Los_Angeles") locale:nil))
        (s stringByReplacingOccurrencesOfString:" 0" withString:" "))

     ;;(- (id) descriptionForBlog is (self descriptionWithCalendarFormat:"%A, %d %b %Y"))
     
     ;; Get a y-m-d representation of a date.
     (- (id) ymd is
        (self descriptionWithCalendarFormat:"%Y-%m-%d"))
     
     (- (id) monthAndYear is
        (self descriptionWithCalendarFormat:"%B %Y"))
     
     ;; Get an RFC822-compliant representation of a date.
     (- (id) rfc822 is
        (set result ((NSMutableString alloc) init))
        (result appendString:
                (self descriptionWithCalendarFormat:"%a, %d %b %Y %H:%M:%S "
                      timeZone:(NSTimeZone localTimeZone) locale:nil))
        (result appendString:((NSTimeZone localTimeZone) abbreviation))
        result)
     
     ;; Get an RFC1123-compliant representation of a date.
     (- (id) rfc1123 is
        (set result ((NSMutableString alloc) init))
        (result appendString:
                (self descriptionWithCalendarFormat:"%a, %d %b %Y %H:%M:%S "
                      timeZone:(NSTimeZone timeZoneWithName:"GMT") locale:nil))
        (result appendString:((NSTimeZone timeZoneWithName:"GMT") abbreviation))
        result)
     
     ;; Get an RFC3339-compliant representation of a date.
     (- (id) rfc3339 is
        (set result ((NSMutableString alloc) init))
        (result appendString:
                (self descriptionWithCalendarFormat:"%Y-%m-%dT%H:%M:%S"
                      timeZone:(NSTimeZone localTimeZone) locale:nil))
        (set offset (/ ((NSTimeZone localTimeZone) secondsFromGMT) 3600))
        (cond ((< offset -9) (result appendString:"#{offset}:00"))
              ((< offset 0) (result appendString:"-0#{(* -1 offset)}:00"))
              (t (result appendString:"-0#{offset}:00")))
        result)
     
     (- (id) path is
        (self descriptionWithCalendarFormat:"%Y/%m/%d" timeZone:nil locale:nil)))

(macro render-partial (name)
     `(try
         (set __name ,name)
         (set __result (eval (NuTemplate codeForString:(NSString stringWithContentsOfFile:"views/_#{__name}.nuhtml"))))
         (unless __result
                 ;; log expanded template for debugging
                 (puts "error in template _#{__name}.nuhtml")
                 (puts ((NuTemplate scriptForString:(NSString stringWithContentsOfFile:"views/_#{__name}.nuhtml")) stringValue)))
         __result
         (catch (__exception)
                (puts "error in template _#{__name}.nuhtml (#{(__exception name)} #{(__exception reason)})")
                "")))

(macro render-page (name)
     `(try
         (set __name ,name)
         (eval (NuTemplate codeForString:(NSString stringWithContentsOfFile:"views/#{__name}.nuhtml")))
         (catch (__exception)
                (puts "error in template #{__name}.nuhtml (#{(__exception name)} #{(__exception reason)})")
                "")))

(macro render-xml (name)
     `(try
         (set __name ,name)
         (eval (NuTemplate codeForString:(NSString stringWithContentsOfFile:"views/#{__name}.nuxml")))
         (catch (__exception)
                (puts "error in template #{__name}.nuxml (#{(__exception name)} #{(__exception reason)})")
                "")))

(puts "reading site description")

(set pages (array))
(set pageFiles ((NSString stringWithShellCommand:"ls pages") lines))
(puts (+ "reading " (pageFiles count) " pages"))
(pageFiles each:
     (do (pageFile)
         (set info (NSObject objectWithYAML:(NSString stringWithContentsOfFile:(+ "pages/" pageFile "/info.yml"))))
         (set body (NSString stringWithContentsOfFile:(+ "pages/" pageFile "/body.txt")))
         (set extended (NSString stringWithContentsOfFile:(+ "pages/" pageFile "/extended.txt")))
         (info setObject:body forKey:"body")
         (info setObject:extended forKey:"extended")
(info creationDate:((info creationDate:) stringByReplacingOccurrencesOfString:"-0800" withString:"-08:00"))
(info creationDate:((info creationDate:) stringByReplacingOccurrencesOfString:"-0700" withString:"-07:00"))
         (info setObject:(NSDate dateWithString:(info "creationDate")) forKey:"creationDate")
         (info setObject:YES forKey:"permanent")
         (pages << info)))

(set posts (array))
(set postFiles ((NSString stringWithShellCommand:"ls posts | sort -r") lines))
(puts (+ "reading " (postFiles count) " posts"))
(postFiles each:
     (do (postFile)
         (set info (NSObject objectWithYAML:(NSString stringWithContentsOfFile:(+ "posts/" postFile "/info.yml"))))
         (set body (NSString stringWithContentsOfFile:(+ "posts/" postFile "/body.txt")))
         (set extended (NSString stringWithContentsOfFile:(+ "posts/" postFile "/extended.txt")))
         (info setObject:body forKey:"body")
         (info setObject:extended forKey:"extended")
(info creationDate:((info creationDate:) stringByReplacingOccurrencesOfString:"-0800" withString:"-08:00"))
(info creationDate:((info creationDate:) stringByReplacingOccurrencesOfString:"-0700" withString:"-07:00"))
         (info setObject:(NSDate dateWithString:(info "creationDate")) forKey:"creationDate")
         (info setObject:(+ "/posts/" ((info "creationDate") path) "/" (info "permalink")) forKey:"linkForDate")
         (posts << info)))

(puts "building site")

;; create the site directory
(system "rm -rf public")
(system "mkdir -p public")
(system "cp -rp assets/* public")

;; build the index page
(set index-page (render-page "index"))
(index-page writeToFile:"public/index" atomically:NO)
(index-page writeToFile:"public/index.html" atomically:NO)

;; render pages
(pages each:
       (do (post)
           (puts (+ "rendering " (post "permalink")))
           ((render-page "show") writeToFile:(+ "public/" (post "permalink")) atomically:NO)))

;; render posts
(posts each:
       (do (post)
           (puts (+ "rendering " (post "permalink")))
           (set path (+ "public/posts/" ((post "creationDate") path)))
           (system (+ "mkdir -p " path))
           ((render-page "show") writeToFile:(+ path "/" (post "permalink")) atomically:NO)))

;; render feeds
(set feedposts (posts subarrayWithRange:'(0 7)))

(let (path "public/xml/rss20")
     (system (+ "mkdir -p " path))
     ((render-xml "rss") writeToFile:(+ path "/feed.xml") atomically:NO))
(let (path "public/xml/atom10")
     (system (+ "mkdir -p " path))
     ((render-xml "atom") writeToFile:(+ path "/feed.xml") atomically:NO))

