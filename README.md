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
9. ruby (`ruby 3.1.3p185 (2022-11-24 revision 1a6b16756e) [x86_64-darwin21]`)
   - tooling (6/10)
      - Took a long time to get the module and interperter setup just right in the IDE
   - experience (2/10)
     - I've installed gems before...
   - sugar (9/10)
   - brevity (3/10)
     - So much boilerplate...
   - I love how classes and predicates feel. Lots of cool builtin functions too.
10. lua (`Lua 5.4.6`)
    - tooling (7/10)
    - experience (3/10)
    - sugar (4.5/10)
      - Pulling modules was easy with luarocks. The build-it-yourself mindset of the community sorta sucks.
    - brevity: (3/10)
    - This was a hard night. The final bfs implementation was pretty sketchy.
11. nim (`Nim Compiler Version 2.0.0`)
    - tooling (5/10)
    - experience (1/10)
    - sugar (5/10)
        - lots of std modules to pull.
    - brevity: (5/10)
    - the compiler errors I got were hard to make sense of
      ```text
        /Users/sullage/sandbox/aoc-2023-generic/day11/aoc.nim(67, 1) Error: type mismatch
        Expression: echo galaxies
        [1] galaxies: seq[Galaxy]
    
        Expected one of (first mismatch at [position]):
        [1] proc echo(x: varargs[typed, `$`])
      ```
12. typescript (`^5.3.3`)
    - tooling (6/10)
    - experience (7/10)
    - sugar(8/10)
      - very large (though perhaps not robust) ecosystem
    - brevity (5/10)
    - I know ts well. I prefer js. IMO, the strength of js and its kin is how few rules it has. Adding type safety doesn't make js better, imo.
13. java 1.8
    - tooling (9/10)
    - experience (9/10)
    - sugar(8/10)
    - brevity (3/10)
      - Like writing a book. But I like this book.
    - I wanted to use java 1.2 and compare it to java 21 later, but I found 1.2 wasn't supported by maven and I didn't want to keep a makefile up to date.
14. visual basic (`8.0.100`)
    - tooling (7/10)
      - Had to switch to rider
    - experience (5/10)
    - sugar(7/10)
    - brevity (2/10)
        - I don't like this book, though.
    - I just used one big file. Need to clean that up.
15. c++
    - tooling: (8/10)
    - experience: (4/10)
    - sugar: (6/10)
    - brevity: (4/10)
    - I like the std lib. It is already installed on a lot of machines.
16. c
    - tooling: (8/10)
    - experience: (5/10)
    - sugar: (3/10)
    - brevity: (3/10)
    - Not for day to day use. Runs fast, though.
17. zig
    - grr
18. python
    - tooling: (9/10)
    - experience: (4/10)
    - sugar: (8/10)
    - brevity: (6/10)
    - I enjoy python a lot. lots of resources online. permissive typing hints. I just wish it was whitespace agnostic.
19. java 21
    - tooling: (9/10)
    - experience: (8/10)
    - sugar: (10/10)
    - brevity: (3/10)
    - Feels like coming home after the disaster that was zig.
20. C#
21. kotlin
22. deno ( yes, I know this is cheating )
23. dart
24. go
25. javascript

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
- zig
  - The error messages are difficult to parse
  - Limited ide support
  - No ecosystem of answers