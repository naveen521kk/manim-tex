selected_scheme scheme-minimal
TEXDIR ./ManimTex/

TEXMFSYSCONFIG ./ManimTex/texmf-config
TEXMFLOCAL ./ManimTex/texmf-local
TEXMFSYSVAR ./ManimTex/texmf-var

option_doc 0
option_src 0
option_autobackup 0

portable 1
TEXMFCONFIG $TEXMFSYSCONFIG
TEXMFHOME $TEXMFLOCAL
TEXMFVAR $TEXMFSYSVAR
