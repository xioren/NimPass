import nimpass

var
  mode = "w"
  len: int
  num: int
  sep = "+"
  ext = false
  p = initOptParser("-m:w -n:8 -l:8")


proc test(m, sep: string, l, n: var int, e: bool) =
  generate_alpha(e)
  if n <= 0:
    n = 1
  for _ in 0..<n:
    assert generate_password(l).len == l


when isMainModule:
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      echo key
    of cmdShortOption, cmdLongOption:
      case key
      of "h", "help": discard
      of "v", "version": discard
      of "m", "mode": mode = val
      of "l", "len", "length": len = parseInt(val)
      of "n", "num", "number": num = parseInt(val)
      of "s", "sep", "separator": sep = val
      of "e", "ext", "extended": ext = true
    of cmdEnd: assert(false)

test(mode, sep, len, num, ext)
