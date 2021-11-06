import std/[parseopt, strutils]
include rand, word_list


const
  core = Letters + Digits
  readableCore = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M',
                   'N', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a',
                   'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n',
                   'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '2',
                   '3', '4', '5', '6', '7', '8', '9'}
  # NOTE: https://owasp.org/www-community/password-special-characters
  punc = {'!', '"', '#', '$', '%', '&', '\'', '(',')', '*', '+', ',', '-', '.', '/',
          ':', ';', '<', '=', '>', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}',
          '~'}
  readablePunc = {'@', '#', '$', '%', '^', '&', '*', '='}
var alphabet: string


proc generateAlpha(ext, readable: bool) =
  if readable:
    for chr in readableCore:
      alphabet.add(chr)
    if ext:
      for chr in readablePunc:
        alphabet.add(chr)
  else:
    for chr in core:
      alphabet.add(chr)
    if ext:
      for chr in punc:
        alphabet.add(chr)


proc generatePassphrase(length: int, sep: string): string =
  for _ in 0..<length.pred:
    result.add(choose(dictionary) & sep)
  result.add(choose(dictionary))


proc generatePassword(length: int): string =
  for _ in 0..<length:
    result.add(choose(alphabet))


proc generate*(mode, sep: string, wlen, plen, num: int, ext, readable: bool) =
  ## generate n pass(words/phrases)
  ##
  ## Parameters:
  ##  mode: char
  ##    choose pass - (w)ord or (p)hrase
  ##  len: int
  ##    length of pass(phrase/word)
  ##  num: int
  ##    number of pass(words/phrases) to generate
  ##  ext: bool
  ##    extended char set
  ## readable: bool
  ##    exlude ambiguous chars

  if mode == "w":
    generateAlpha(ext, readable)

  for _ in 0..<num:
    echo "---BEGIN---"
    if mode == "w":
      echo generatePassword(wlen)
    else:
      echo generatePassphrase(plen, sep)
    echo "----END----\n"


proc main() =
  const
    version = "0.2.1"
    help = """
  Usage: nimpass [options]

  Options:
    -h, --help                      Print this help message
    -v, --version                   Print version information
    -w, --word                      Generate pass(w)ord (default)
    -p, --phrase                    Generate pass(p)hrase
    -l, --len --length              Length of password or passphrase
    -n, --num --number              Number of pass's to generate
    -e --ext --extended             Use extended character set
    -r --readable                   Exclude ambiguous characters
    -s --sep --separator            Separator used to separate words (default "+")

  Examples:
    nimpass
    nimpass -l32 -n8
    nimpass --phrase --length 8 --sep ":"
  """
    sNoVal = {'e', 'p', 'w', 'r'}
    lNoVal = @["ext", "extended", "phrase", "word", "readable"]
  var
    mode = "w"
    sep = "+"
    wlen = 16
    plen = 8
    num = 1
    ext = false
    readable = false

  for kind, key, val in getopt(shortNoVal=sNoVal, longNoVal=lNoVal):
    case kind
    of cmdEnd:
      return
    of cmdArgument:
      discard
    of cmdShortOption, cmdLongOption:
      case key
      of "h", "help":
        echo help
        return
      of "v", "version":
        echo version
        return
      of "w", "word":
        mode = "w"
      of "p", "phrase":
        mode = "p"
      of "l", "len", "length":
        if not val.isEmptyOrWhitespace():
          wlen = parseInt(val)
          plen = parseInt(val)
      of "n", "num", "number":
        if not val.isEmptyOrWhitespace():
          num = parseInt(val)
      of "s", "sep", "separator":
        if not val.isEmptyOrWhitespace():
          sep = val
      of "e", "ext", "extended":
        ext = true
      of "r", "readable":
        readable = true

  if num <= 0:
    num = 1
  if plen <= 0:
    plen = 8
  elif wlen <= 0:
    wlen = 16

  generate(mode, sep, wlen, plen, num, ext, readable)


when isMainModule:
  main()
