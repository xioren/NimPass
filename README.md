# NimPass

quickly generate secure passwords and passphrases

#### changelog v0.2.1:
  + misc code clean up and improvmenets.

### Installation
```bash
nimble install nimpass
```

### Usage
```
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
  -s --sep --separator            Separator used with passphrases (default "+")

Examples:
  nimpass
  nimpass -l32 -n8
  nimpass --phrase --length 8 --sep ":"
```
