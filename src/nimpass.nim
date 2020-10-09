import parseopt, strutils
include rand, word_list

export parseopt, strutils

const
  punc = {'!', '"', '#', '$', '%', '&', '\'', '(',')', '*', '+', ',', '-', '.', '/',
          ':', ';', '<', '=', '>', '?', '@', '[', ']', '^', '`', '{', '|', '}', '~'}
var
  alphabet: string


proc generate_alpha*(e: bool) =
  for ch in IdentChars:
    alphabet.add($ch)
  if e:
    for ch in punc:
      alphabet.add($ch)


proc generate_passphrase*(length: var int, sep: string): string =
  var words: seq[string] = @[]

  for _ in 0..<length:
    words.add(choose[string](dictionary))
  result = join(words, sep)


proc generate_password*(length: var int): string =
  for _ in 0..<length:
    result.add(choose[char](alphabet))


proc generate*(m, sep: string, l, n: var int, e: bool) =
  ## generate n pass(words/phrases)
  ##
  ## Parameters:
  ##  m: char
  ##    choose pass - (p)hrase or (w)ord
  ##  l: int
  ##    length of pass(phrase/word)
  ##  n: int
  ##    number to generate
  ##  e: bool
  ##    extended char set
  generate_alpha(e)
  if n <= 0:
    n = 1
  for _ in 0..<n:
    if m == "w":
      echo generate_password(l)
    else:
      echo generate_passphrase(l, sep)


when isMainModule:
  const
    version = "0.0.1"
    help = """
  Usage: nimpass [options]

  Options:
    -h, --help                      Print this help message.
    -v, --version                   Print version information.
    -w, --word                      Generate pass(w)ord (default)
    -p, --phrase                    Generate pass(p)hrase
    -l, --len --length              Length of password or passphrase
    -n, --num --number              Number of pass's to generate
    -e --ext --extended             Use extended character set

  Examples:
    nimpass
    nimpass -l32 -n8
    nimpass --phrase --length 8 --sep "*"
  """
    sNoVal = {'e', 'p', 'w'}
    lNoVal = @["ext", "extended", "phrase", "word"]
  var
    mode = "w"
    len = 16
    num = 1
    sep = "+"
    ext = false

  when isMainModule:
    # FIXME: handle - arg error
    for kind, key, val in getopt(shortNoVal=sNoVal, longNoVal=lNoVal):
      case kind
      of cmdArgument:
        discard
      of cmdShortOption, cmdLongOption:
        case key
        of "h", "help": echo help;quit(0)
        of "v", "version": echo version;quit(0)
        of "w", "word": mode = "w"
        of "p", "phrase": mode = "p"
        of "l", "len", "length":
          if val != "":
            len = parseInt(val)
        of "n", "num", "number":
          if val != "":
            num = parseInt(val)
        of "s", "sep", "separator":
          if val != "":
            sep = val
        of "e", "ext", "extended": ext = true
      of cmdEnd: assert(false)

  generate(mode, sep, len, num, ext)
