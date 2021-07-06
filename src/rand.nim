import strutils


const urandom = "/dev/urandom"


proc get_rand_bytes(bytesToRead: int): int {.inline.} =
  var
    file: File
    buffer = newString(bytesToRead)

  if not file.open(urandom):
    raise newException(OSError, "/dev/urandom is not available")
  try:
    if file.readBuffer(addr(buffer[0]), bytesToRead) < bytesToRead:
      raise newException(OSError, "not enough entropy in /dev/urandom")
  finally:
    file.close()
  result = parseHexInt(toHex(buffer))


proc rand_below(n: int): int {.inline.} =
  var bytes: int
  if n > 255:
    bytes = 2
  else:
    bytes = 1
  result = get_rand_bytes(bytes)
  while result >= n:
    result = get_rand_bytes(bytes)


proc choose[T](choices: openarray[T]): T =
  choices[rand_below(choices.len)]
