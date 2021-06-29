import strutils


const urandom = "/dev/urandom"


proc get_rand_bytes(): int {.inline.} =
  var
    file: File
    buffer = newString(7)

  if not file.open(urandom):
    raise newException(OSError, "/dev/urandom is not available")
  try:
    if file.readBuffer(addr(buffer[0]), 7) < 7:
      raise newException(OSError, "not enough entropy in /dev/urandom")
  finally:
    file.close()
  result = fromHex[int](toHex(buffer))


proc rand_below(n: int): int {.inline.} =
  result = get_rand_bytes() mod n


proc choose[T](choices: openarray[T]): T =
  choices[rand_below(choices.len)]
