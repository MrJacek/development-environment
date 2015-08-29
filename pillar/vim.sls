vim:
  config:
    syntax: 'on'
    colors: desert

  settings:
    et:
    cin:
    ru:
    bs: indent,eol,start
    showcmd:
    showmatch:
    smartcase:
    incsearch:
    autowrite:
    hidden:
    mouse-: a
    number:
    backspace: 2
    noerrorbells:
    novisualbell:
    background: dark
    ai:
    si:
    cindent:
    expandtab:
    tabstop: 2
    softtabstop: 2
    shiftwidth: 2
    nowrap:
    nocompatible: 
    swapsync: ''


  mappings:
    <C-u>: :tabp<enter>
    <C-i>: :tabn<enter>
    <C-J>: <C-W>j
    <C-K>: <C-W>k
    <C-H>: <C-W>h
    <C-L>: <C-W>l

  lets:
    &colorcolumn: join(range(121,121),",")

