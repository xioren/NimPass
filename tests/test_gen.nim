import nimpass

let
  wlen = 8
  plen = 16
  num = 10
  sep = "+"
  ext = false
  readable = false


when isMainModule:
  generate("w", sep, wlen, plen, num, ext, readable)
  generate("p", sep, wlen, plen, num, ext, readable)
