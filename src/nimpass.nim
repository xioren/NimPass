import parseopt, strutils
include rand, word_list

export parseopt, strutils

const
  core = Letters + Digits
  # NOTE: https://owasp.org/www-community/password-special-characters
  punc = {'!', '"', '#', '$', '%', '&', '\'', '(',')', '*', '+', ',', '-', '.', '/',
          ':', ';', '<', '=', '>', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}', '~'}
var
  alphabet: string


proc generate_alpha*(ext: bool) =
  for chr in core:
    alphabet.add(chr)
  if ext:
    for chr in punc:
      alphabet.add(chr)


proc generate_passphrase*(len: int, sep: string): string =
  var words: seq[string] = @[]

  for _ in 0..<len:
    words.add(choose[string](dictionary))
  result = join(words, sep)


proc generate_password*(len: int): string =
  for _ in 0..<len:
    result.add(choose[char](alphabet))


proc generate*(mode, sep: string, len, num: var int, ext: bool) =
  ## generate n pass(words/phrases)
  ##
  ## Parameters:
  ##  mode: char
  ##    choose pass - (p)hrase or (w)ord
  ##  len: int
  ##    length of pass(phrase/word)
  ##  num: int
  ##    number to generate
  ##  ext: bool
  ##    extended char set

  if num <= 0:
    num = 1
  if len <= 0:
    len = 16
  if mode == "w":
    generate_alpha(ext)

  for _ in 0..<num:
    if mode == "w":
      echo generate_password(len)
    else:
      echo generate_passphrase(len, sep)


when isMainModule:
  const
    version = "0.0.2"
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
    nimpass --phrase --length 8 --sep ":"
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
    # TODO: seperate word/phrase default lengths
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
