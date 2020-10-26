# NimPass

quickly generate secure passwords and passphrases

#### changelog v0.0.4:
  + added readable option for excluding ambiguous characters
  + output is now clearer and easier to read
  + fixed readable argument no val error
  + misc code cleanup and improvements

### Installation
```
nimble install nimpass
```

### Usage
```
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
```

#### NOTE
currently only compatible with unix systems
