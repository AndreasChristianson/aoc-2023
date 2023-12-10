# advent of code 2023

## 2023

The current plan for using a different language each day.

### ratings

- tooling: How easy was it to install, how easy to get to hello world, how was there ide support, did the errors messages make sense
- experience: How much experience did I have with this sort of language going in.
- sugar: How much syntactical sugar was built into the language? How easy was it to pull outside modules? How large is the ecosystem?
- brevity: How terse is the language? Is it good for doing things quickly? Is it a good fit for scripting?

1. erlang/OTP (`Erlang/OTP 26 [erts-14.0.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns] [dtrace]`)
   - tooling (6/10)
   - experience (3/10)
   - sugar (5/10)
   - brevity (4/10)
   - list comprehensions area pretty readable in erlang.
2. perl (`perl 5, version 30, subversion 3 (v5.30.3) built for darwin-thread-multi-2level`)
   - tooling (7/10)
   - experience (2/10)
   - sugar (7/10)
   - brevity (9/10)
   - Like bash but none of the variable prefix rules make sense.
   - Runtime feels "fast." Might just have been this problem.
3. scheme/lisp (`Racket v8.11.1 [cs]`)
   - tooling (4/10)
     - Error messages didn't have worthwhile stack traces. They were truncated and just method names with line numbers.
   - experience (4/10)
   - sugar (3/10)
   - brevity (3/10)
   - build your own mapping functions seems to be "the lisp way."
4. bash (`GNU bash, version 5.2.15(1)-release (x86_64-apple-darwin21.6.0)`)
   - tooling (6/10)
   - experience (7/10)
   - sugar (5/10)
   - brevity (9/10)
   - treating everything as a string made tonight easy. Having a wide range of SO questions also helped a lot.
5. F# (`dotnet 8.0.100`)
   - tooling (5/10)
     - Had to install Rider. :shrug:
   - experience (2/10)
   - sugar (6/10)
     - It has all the dotnet sugar, just in functional form
   - brevity (3/10)
   - Just parsing the text was pretty painful. My mind is not smart enough for languages like this.
   - Feels like scala.
6. PowerShell (`7.4.0`)
   - tooling (4/10)
     - IDE support sucked in intellij. Had to move to vs-code.
   - experience (2/10)
   - sugar (8/10)
     - Way more than I expected. Has all the dotnet sugar.
   - brevity (8/10)
   - Seems like a good bash replacement for most use cases; for example, if you're on windows.
7. rust (`rustc 1.74.0 (79e9716c9 2023-11-13)`)
   - tooling (7/10)
      - IDE support wasn't 100% in intellij. Wasn't really 80%.. But the error messaging on the build was well done.
   - experience (3/10)
   - sugar (6/10)
   - brevity (4/10)
   - Thinking about lifetimes shouldn't be my job if I don't want to.
8. groovy (`Groovy Version: 4.0.16 JVM: 21.0.1 Vendor: Homebrew OS: Mac OS X`)
   - tooling (4/10)
      - IDE support sucked in intellij. Type system didn't work.
   - experience (3/10)
   - sugar (6/10)
      - Without ide support the sugar tasted off...
   - brevity (6/10)
   - I think if I got my dev env set up correctly this would have rocked.
9. ruby
   - tooling (6/10)
      - Took a long time to get the module and interperter setup just right in the IDE
   - experience (2/10)
     - I've installed gems before...
   - sugar (9/10)
   - brevity (3/10)
     - So much boilerplate...
   - I love how classes and predicates feel. Lots of cool builtin functions too.
10. lua (`Lua 5.4.6`)
    - tooling: How easy was it to install, how easy to get to hello world, how was there ide support, did the errors messages make sense
    - experience: How much experience did I have with this sort of language going in.
    - sugar: How much syntactical sugar was built into the language? How easy was it to pull outside modules? How large is the ecosystem?
    - brevity: How terse is the language? Is it good for doing things quickly? Is it a good fit for scripting?
11. nim
12. typescript
13. java 1.2 ( first java with collection classes )
14. visual basic ( .NET core )
15. c++
16. c
17. zig
18. python
19. java 21
20. C#
21. kotlin
22. deno ( yes, I know this is cheating )
23. dart
24. javascript
25. go

## alternatives

If I can't get a language off the ground, or it seems like the language doesn't fit the problem, here are some backups.

- matlab
- ~~powershell~~
- oolong
- clojure
- fortran 2018
- actionscript
- ~~python~~
- scala

## outlawed

These have proved trying in the past.

- elixir
- swift/objective-c
- julia
- scheme 
  - too much build-your-own-helper mindset
- COBOL
  - After spending an hour, I was still researching out how to read records from a text file.