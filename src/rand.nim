import strutils


const
  urandom = "/dev/urandom"


proc get_rand_bytes(n: int): int =
  var
    file: File
    buffer = newString(n)

  if not file.open(urandom):
      raise newException(OSError, "/dev/urandom is not available")
  try:
    let read = readBuffer(file, addr(buffer[0]), n)
    if read < n:
      raise newException(OSError, "not enough entropy in /dev/urandom")
  finally:
    file.close()
  result = parseHexInt(toHex(buffer))


proc rand_below(n: int): int =
  # TODO: add bit len check here
  var bytes: int
  if n <= 255:
    bytes = 1
  else:
    bytes = 2

  result = get_rand_bytes(bytes)
  while result >= n or result < 0:
    result = get_rand_bytes(bytes)


proc choose[T](choices: openarray[T]): T =
  choices[rand_below(choices.len)]
