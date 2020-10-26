import parseopt, strutils
include rand, word_list

export parseopt, strutils


const
  core = Letters + Digits
  readable_core = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M',
                   'N', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a',
                   'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n',
                   'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '2',
                   '3', '4', '5', '6', '7', '8', '9'}
  # NOTE: https://owasp.org/www-community/password-special-characters
  punc = {'!', '"', '#', '$', '%', '&', '\'', '(',')', '*', '+', ',', '-', '.', '/',
          ':', ';', '<', '=', '>', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}',
          '~'}
  readable_punc = {'@', '#', '$', '%', '^', '&', '*', '='}
var
  alphabet: string


proc generate_alpha(ext, readable: bool) =
  if readable:
    for chr in readable_core:
      alphabet.add(chr)
    if ext:
      for chr in readable_punc:
        alphabet.add(chr)
  else:
    for chr in core:
      alphabet.add(chr)
    if ext:
      for chr in punc:
        alphabet.add(chr)


proc generate_passphrase(len: int, sep: string): string =
  var words: seq[string] = @[]

  for _ in 0..<len:
    words.add(choose[string](dictionary))
  result = join(words, sep)


proc generate_password(len: int): string =
  for _ in 0..<len:
    result.add(choose[char](alphabet))


proc generate*(mode, sep: string, len, num: var int, ext, readable: bool) =
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

  if num <= 0:
    num = 1
  if len <= 0:
    len = 16
  if mode == "w":
    generate_alpha(ext, readable)

  for _ in 0..<num:
    echo "---BEGIN---"
    if mode == "w":
      echo generate_password(len)
    else:
      echo generate_passphrase(len, sep)
    echo "----END----\n"

when isMainModule:
  const
    version = "0.0.4"
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
    -r --readable                   exclude ambiguous characters

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
    len = 16
    num = 1
    ext = false
    readable = false

  when isMainModule:
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
        of "r", "readable": readable = true
      of cmdEnd: assert(false)

  generate(mode, sep, len, num, ext, readable)
