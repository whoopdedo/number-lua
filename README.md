```
   _________________                _     _             _
  | ____________    /              | \   | |           | |
  |'           /   /               |  \  | |           | |
              /   /    ||          |   \ | |_   _ ____ | |_   ___  _ __
             /   /  ___||___       | |\ \| | | | |    \|   \ / _ \| '__|
            /   /   ———  ———       | | \   | |_| | | | | () |  __/| |
           /   /       ||          |_|  \__|\___/|_|_|_|\__/ \____|_|
          /   /        ||                                                        
         /   /                       _____           _       _
        /   /                       / ____|         (_)     | |
       /   /                       | (___   ___ _ __ _ _ __ | |_
      /   /                         \___ \ / __| '__| | '_ \| __|
     /   /                          ____) | (__| |  | | |_) | |_
    /   /                          |_____/ \___|_|  |_| .__/ \__|
   /   /___________,|                                 | |
  /_________________|                                 |_|

```

NumberScript is a little language that compiles into Lua.

NumberScript is mathematically proven to be the most readable possible
language.

* No braces
* No significant whitespace
* No operators of any sort (unreadable line noise otherwise)
* [Hindu-arabic](https://en.wikipedia.org/wiki/Hindu-Arabic_numeral_system)
base 10 numerals only. All other bases are completely inferior.

NumberScript for Lua is a port of the original [javascript NumberScript](https://github.com/substack/number-script).

Just install the number-lua package from [luarocks](http://luarocks.org):

```
$ luarocks install number-lua
```

Now we can write our first script. Here's the canonical "hello world" example:

```
9795508356633822141337704998199448662254090
```

Now to run our script, just do:

```
$ number-lua hello.number
Hello Lua!
```

You can use NumberScript interactively too. Just type `number-lua`:

```
$ number-lua
> 135939986443043984033130762
5
> =41568140212747864206438434
'beep boop'
> =12345
9
```

Valid numbers will compile to Lua. 
Fortunately, infinitely many such numbers exist.
Unfortunately, infinitely many numbers will not compile to Lua.

It's your job as a NumberScript programmer to find valid numbers and publish
them to [luarocks](http://luarocks.org).

To compile a valid number to Lua, just do:

```
$ number-lua -c hello.number 
print"Hello Lua!"
```

Hideous output I know, but apps can read these unreadable so-called
"lua scripts".

Similarly, you can decompile one of these unreadable "lua scripts" into a much
more readable, mathematically pure form:

```
$ number-lua -d sieve.lua
683618167793882147267823374730660143482772519680815206038235619099610566325479529232019401499979092900222642463505749024860967659660889174394472063176217093831415885374385264178342989315183076773832744418506528348052735028196030928328976430772513606974743423232406479459400280081478702527624049885729535411208876124455574033069112730690640214686750942192702224538623422024108712828238103104924239195363525891690724633786013741551785449185880847588906594691526777825986459554120310180389721568837447868509281256763887744098401766467410046003753440787470651932557097653575353108780260832968267627271028366502855765801115675492370703415586883025470702101694568276485313440909933938696647108334160510453236588749916729454711336554461097239631743747675529190186641940377188
```

NumberScript can also cross-compile to Javascript and is compatible with the
[original NumberScript](https://github.com/substack/number-script). This is
useful for web apps that need to generate client-side code.

NumberScript also comes with advanced error detection, unlike some other
Lua transpilers. For instance, if you try to run or compile a number that
is not contained in the set of all valid NumberScript numbers, the compiler
will helpfully tell you:

```
Invalid number.
```

This is the only error message necessary.

At any rate you should prove your programs correct and submit them for peer
review before you actually run them.

This NumberScript program generates the set of all valid NumberScript programs,
including itself:

```
110346170011702804292006846486574510466543972997015549805570813034190378542030005200488574340499638168256318585616741604506390345547025493135531785432694420257506660429259634540801260563405374251444928453556800758273425409681088558794193086116810698948998332472659776113436345672066610342171704373204362976407126228565885194462232929473206020094603527685999008888862814421202648908903234635085849676749173436598168305936860067227185296105534374731141046532391650674888192555132684163795803984186467946929616200636683928192508834566694646930943704470074213509397500090539598043838199241070419478087239720419506783057787758911901600722248118380938148353526977460862954806174598038556796828445354469823085240849714745295200736575046832985336584042451119223343745185403682609746734062392255893075548952083032815866718319277861694718194122521074488175585782694600699740244232369882424330
```

usage
=====

```
Usage: number-lua [options] path/to/script.number

  -c, --compile      compile to Lua
  -d, --decompile    decompile Lua back to NumberScript
  -i, --interactive  run an interactive NumberScript REPL
  -o, --output       set a file to output to ("-" goes to stdout)
  -v, --version      display NumberScript version
  -h, --help         display this message
  
```

license
=======

MIT
