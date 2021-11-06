import std/sysrand


proc randBelow(n: int): int {.inline.} =
  doAssert urandom(cast[var array[2, byte]](result.addr))
  while result >= n:
    doAssert urandom(cast[var array[2, byte]](result.addr))


proc choose[T](choices: openarray[T]): T =
  choices[randBelow(choices.len)]
