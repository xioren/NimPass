import nimpass


var
  len = 16
  num = 10
let
  sep = "+"
  ext = false
  readable = false


when isMainModule:
  generate("w", sep, len, num, ext, readable)
  generate("p", sep, len, num, ext, readable)
