package selector

var noSongsBanner = `
                  Hello there
        ████                      ████
      ██░░░░██                  ██░░░░██
      ██░░░░██                  ██░░░░██
    ██░░░░░░░░██████████████████░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██
  ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██
██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
`

var noSongsWithHelpBanner = `
                  Hello there
        ████                      ████
      ██░░░░██                  ██░░░░██
      ██░░░░██                  ██░░░░██
    ██░░░░░░░░██████████████████░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██
  ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██
██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██`

var noResultsBanner = `
                  No results!
        ████                      ████
      ██░░░░██                  ██░░░░██
      ██░░░░██                  ██░░░░██
    ██░░░░░░░░██████████████████░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██
  ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██
██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██`

var justACat = `
        ████                      ████
      ██░░░░██                  ██░░░░██
      ██░░░░██                  ██░░░░██
    ██░░░░░░░░██████████████████░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██
  ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██
██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██`

var sadCat = `
        ██            ██
      ██░░██        ██░░██
      ██░░▒▒████████▒▒░░██                ████
    ██▒▒░░░░▒▒▒▒░░▒▒░░░░▒▒██            ██░░░░██
    ██░░░░░░░░░░░░░░░░░░░░██            ██░░░░██
  ██▒▒░░░░░░░░░░░░░░░░░░░░▒▒████████      ██▓▓██
  ██░░░░██░░░░██░░░░██░░░░░░▓▓░░▓▓░░██    ██░░██
  ██░░░░░░░░██░░██░░░░░░░░░░▓▓░░▓▓░░░░██████▓▓██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓██
    ██▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓██
      ██▓▓░░▓▓▓▓░░▓▓░░░░░░▓▓░░▓▓▓▓░░▓▓██
        ██░░████░░██████████░░████▒▒██
        ████    ████      ████    ████ `
