###
### windows/switcher.tcl: part of Scid
### Copyright (C) 2000-2004  Shane Hudson.

# Try to keep compatablity with Scid as best as can.
# Order of ~some~ icons (such as tactics, clipbase and pgn) is important

# Leave Tactics as number 16 icon
# This is the database type for mate in N puzzles
# 10decimal is not related to 16decimal
# index.cpp:    case 'T': flag = IDX_FLAG_TACTICS;    break;
# index.h:      define  IDX_FLAG_TACTICS      10   // Tactics flag.
# tactics.tcl:  if {[sc_game flag T [sc_game number]]}

set icons {
{Unknown}
{
R0lGODlhIAAgAIAAAFpaWlpaWiH5BAEKAAEALAAAAAAgACAAAAIejI+py+0P
o5y02ouz3rz7D4biSJbmiabqyrbuC5sFADs=
}

{Temporary database}
{
R0lGODlhIAAgAOfkAEpLSUpMSkxOS01PTE9RTlBST1FTUFJUUVNUUlRVU1VW
VFZXVVZYVVdZVllbWFpcWVtdWlxeW11fXF5gXTpmojtno2BiXzVsqGJkYWNl
YmRlY2VmZDtxrWdoZkNwpmhpZz1yrmlraEVyqGpsaWxua0h1rG1vbEp2rW5w
bUt3rm9xbkx4r014sHFzcE96snN1cnR2c3Z4dVl9sHd5dlp+sVt/snp8eVeF
tn1/fH+BfluJuoCCf2GItYGDgIKEgYOFgoWHhIaIhYeJhoiKh4mLiIqMiWyT
wIyOi42PjI6QjY+RjpCSj3qWuZGTkJKUkZOVkpSWk3ubxJWXlJaYlZeZlpia
l5qbmJudmYahxJyem6Cfl4OkzJ6gnZ+hnqGjoIGr0pCnxZSnwKOloqSmo6Wn
pI+rzqaopaepppSsyqiqp6mrqKqsqZevzautqpiwzqCvwp2xyZ6yype307Cy
rrGzr6W1yLO1srS2s6i4y6y4xbW3tKC806m5zK25xqe607a4tau6za66x6i7
1Le5tp+/3Li6t628z7m7uLq8ubu9uqfC2rC/07y+u72/vL7BvcDCvrTE18HD
v6zI38LEwbXI4bTM3rjM5cjKx8HN28rMycvOysDQ48jQ2M7QzMLS5s/Rzs3S
1dDSz8TU6MvT3NHT0MXV6c3W3svX5c3Z59bY1dTb0Nja1s/b6tnb19Tc5dDd
69rc2dvd2tbe59ze29Tg7t3f3NXh797g3d/h3tfj8eDi39jk89vk7OHk4N3l
7uPl4d7m79rn9eHm6eTm49/n8OXn5Obo5eDp8efp5uHq8ujq5+nr6OPs9Obs
7urs6eTt9eft7+Xu9+vu6u3v6+jw+e7w7ezx9O/x7vDy7/Hz8PL08fP18vT3
8/b49Pf59vj69/n7+Pr8+fv9+vz/+///////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXDjQipUsXLJYkeIkyZEhQHrgsBHjBYoRHzRsSGglnDhx4E6qFBeuJbiX
MMF9+4YBoRNxwmIJ28mzp0+e3zQgXCIOlDBQxlrVapXUmLFaTqNGBbcAoRJx
t4yBsiaMUSFEhf4UOjSobKFCiXaCE3oQiTimUI39nCuXKsIj4motdXoIESJG
gBs5Gjy40TJh4qoeJPJNmNy5kI1ZS4wwSDhhrWY5fdRIsKNHjyKJHi2X8kEf
34zNMabssU+uy5TBthZOscEd4BzXEqZsEug7WpoMQWIlzaFHk2TbPYjD2+Nq
yJTVGrPGmDeUyxJZ6WStmrBvtgv+2gD3tJYzYYiQtPK2qAYFFmCsWVsy55o1
cAkQwnDu1JozK6tYAwIWpdhSShkVjFINEpJ9g4B+jTmGDChpaCODH8dQIwwx
sggigjCXtGGNNw8e1AJ/xjizRit4RBEMM9ZQc0wwlmxhxDZJjAgAQh+QJ1c1
VhjjAiG5+MIMM8kQQ4mHzmgBijg7HvSBc445U0QtFQhyCiuysMIKJHC4wcIo
WpACTpQGTalaik60QoMbtNhCDDGviLIJJSyAYsWTaBakAXk7VbNGJ2Ho4IYf
gPQRSB54YCHDLUBc802fBGnwzTJOVUOKGdawUAYlm6BCCyqVpMCJIy/widAC
4CCDjDDF1TS5ijMl8IBGHW9EUQEm12iiRguOUDrQAjj92MwtUqzyjSE3XCAD
HP5pcogVZLRQokELXIqMZMtMcggVavzCzUzGIDKDFogEYoUYOIQ3EALfbGtM
NfJBY00rd1iRhBNaZGKNEFoMku8ZS7j7DwK59YfMMtVUc4028smXjX1I5BCI
HmIMcoa7CFuzzTXehLxNd9Mss4y8j1mhAh2PrNILA9guILPMCSSAwM0IAKDz
zjojoIEdvahxAENEDwTAAUMXrTRBAQEAOw==
}

Clipbase
{
R0lGODlhIAAgAOekAGBBE2lGFHBLFnFMFXFMFnJMFXFNFnJNFXJNFnVNFndP
FlxcXF1dXF5eXl9fX2BgXolgH4thH41iH45jH5BlIJJmIJNnIJVoIJdpIJhq
IZprIZxsIZ1tIZ9uIaFvIqJxIqNxIqRyIqZzIqh0I6l1I6t2I39/ca13I654
I4CAfbB5JIGDfrJ7JIGDf7N8JIKEgIKFgLV9JLd+Jbh/JYyGeLqAJYeJhIaK
hIeKhIeKhYqKfbyBJYiKhIiKhYeLhYeLhpCJeb2CJb2CJpGKeb+DJsGEJouO
icKFJoyPipaNeo6Oi8SHJsWHJ42Ri46RjMaIJ5GRjZeXipmZjZiYl5ubjqGh
laOjoKSkmaOjoqSkmqionaqqoKqqoauroKuroqmrqaysoaysoq2toq6uo7a2
rLa2rbe3rbe3rri4rri4r7m5r7m5sLq6sby8s8PDw8TEw8TExMTFxMXFxMXF
xcbGvsbGxcbGxsfHxsjIx8nJwtDQz9DQ0NTU1NXV1dXW1NbW1tjY2Nnb2dzc
297e3uPj4ubm5ejo6Onp6Onp6erq6erq6uvr6uvr6+zs6+zs7O3t7O3t7e7u
7e7u7u/v7u/v7/Dw7/Dw8PHx8fLy8vPz8/T09Pb29vf39/j4+Pn5+Pn5+fr6
+vv7+/39/f7+/v//////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH+FUNyZWF0ZWQgd2l0aCBUaGUgR0lNUAAh+QQB
CgD/ACwAAAAAIAAgAAAI/gD/CRxIUOCCgwgPFlzIcOECKVQiUpGyoKFFgg8Q
6jDB0YQOhA8u/lNwgIBJkwyqXFkZpWWUlVeqMBBwkkCBBAQRMHnCk+cCNl3A
CAUjpqiYMW0WBOn5pAgCggR4JulBdUGeNWrSoEFzxkwZMmToLFhBdUiIJwSg
8uxBqq0DLWHCeJnLpe6WLVkcYGrb4wNatU/YVqqEpUHCwwsaTClUiVQPD38H
Rl0ieDAhQJgzawYkKFLjHh0iC4x6pPLg06hTT5rkmIPof1GLmE5Ne/WkSI43
vI5KpDKe38CD3xleJxIkxxp2Pwkym3al1ZGiP3rkOIPyHc1Rr5YUHdIjR40c
/mNQXsO3cOJ15siRM6gRI8cXlM/IDt34dPCMGC1ybEG5jNn1RXKfe/opoohj
FSgXQ2XD2VFHenLA8cYbbrhhYCKIiNIDBcq5wJZt3Q1YoCIYImJIKD1MoBwL
H4b4HYGLkIiIiYYY8kkPEiinAlvRrSdhhRXuMeMhNSLiyI0RKIcCW96B516M
MtJoCCOSXAJKDxAod0IPo7w4Yok1GqIIJJZoYkkgOGSZlmRPlNCDKDBGSaQh
iEByw503IHGDD2qqRUIPoYw4ZJGOUIKJD3388YceTmCp3Ag9eHLhjGFSeYkm
nNygaBxIvODomqM9IUIPm4BZ45hlcgKKJk3w8cUPUy0oYUOfbIbQgyaZYHLJ
rphoskknoIgiih83GAFDClBYMatyIABB1bPQQpsDDjxQZYMNNNAqkAFFMOXt
t+DyJIQBBAUwQE3opquuSQMAINK7IgUEADs=
}

{PGN file}
{
R0lGODlhIAAgAOeiADMzM0tLS0xMTE5OTk9PT1BQUFFRUVJSUlNTU1RUVFVV
VVZWVldXV1hYWFlZWVpaWltbW1xcXH5YHV1dXX9ZH4BaIGBgYIFbIoJdJINe
JWNjY4RfJ2RkZIRgKGZmZoZiK4ZjLGhoaIhlL2pqamtra21tbW9vb41rN3Bw
cI1sOHJyco9uPHNzc5BvPI9wP5FwPpFxP3Z2dnd3d5R0Q5J1R3p6epV2RpZ4
SX19fZh6S5l8TYCAgJp9T4GBgZt+UYODg4SEhJ2BVJ6CVoaGhqCEWYiIiImJ
iYuLi6OIXoyMjKOJX6SKYY6Ojo+Pj6aNZJCQkKeNZZKSkpOTk6qQapaWlpmZ
mZycnLGadp6enrijg7qlhrunibGxscW0mse3nsm6ob6+vr+/v8DAwM2+qMHB
wc7AqcLCws/Bq8PDw8TExMbGxsfHx8jIyNXItd3TxN/Vx9/WyODXydva19va
2Nzc3N/f3+Dg4OHh4eLi4uji2OPj4+Tk5OXl5ebm5ufn5+jo6Ovo5Onp6erq
6u/q4+vr6+zs7PDs5e3t7e7u7vLu6O/v7/Dw8PPw6/Hx8fLy8vPy8PPz8/T0
9PX19ff18vb29vj39Pf39/n39fj4+Pn5+fr59/r6+vv6+Pv7+/z7+vz8/P39
/f7+/v//////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXCjQisOHVqhIaZKkCJAeOGrEUGGCRAgOHBQgtAIKVKhNoUqW/MSyk8tN
MDPJxCTyIEk6onLq3MlTJx6aI0PRkCABg4gyob6suNBihRdROYi+QSLhRk2D
VkLNkdCiEogPYyRc4TQICg9RmooKSfvoakGSdSS8MNRBhA8JiXJ6cpNTQhYJ
cSQAtQkqLtEUbWZI8CQqCFEdoiQwykBEsFuCJO1IgKFzioQ8oiaJwBtZlBai
mB4gHAJKjoQUoXK+kbDkEhwKEtBK0ARog2AHCH+AckG0i84zJyrYcJI7qhJR
WwQ3QLjjE56e2HUWEkUIEwOEOD7+6clOXlShwQZriN9zh5AfMmDAhJk/X4x9
MWgOHcKUAKGMTnvwcUchfwQSiCCEFFKIfog06CAimByAEAsACkggGfTdJwYZ
HJKRhiKKYFIAQih0wkcfeBxyYIIMgrjIizAuYskACJVgIooqIrggIoq82MiP
QMooAEIjbNKHH3ocIogZYdjXoRlQmoGGGo40YkkACHlgJBd8KMkij4s04ggk
kEQSCZmOXImQBkYKkiQhaDhJBpRo1FnnGmeqeZAFmRy5ByJf9ihmmZJQQokk
kkSip0ET9PnHn3A6SWedaVTKRqKLFuRAJn48CuiCgo4ZSaGWYGLJoZkStAAm
nUIaJ4dKk65RqqmoYnkQApj04emXYYpK6qmY2moQAbnuumOPvhZqaLAIGXAq
JZCYasm01FZrrSUGIKTAttwu4O234Ia7AAMAMGTuueieGxAAOw==
}

{My games}
{
R0lGODlhIAAgAMZkACEhISYmJioqKi4uLjQ0NDU1NTg4ODk5OTs7Ozw8PD4+
PkBAQEFBQUJCQkZGRkdHR0pKSktLS09PT1BQUFJSUlNTU1RUVFdXV1hYWFlZ
WVxcXF1dXWBgYGFhYWJiYmVlZWZmZmdnZ2lpaWtra3BwcHJycnR0dHZ2dnh4
eHl5eXp6enx8fH19fYCAgIKCgoODg4aGhoiIiIuLi4yMjJCQkJGRkZKSkpOT
k5WVlZaWlp2dnZ6enp+fn6CgoKGhoaKioqOjo6ampqmpqaqqqqysrLGxsbKy
srS0tLa2tri4uLm5ubq6uru7u7y8vL29vb6+vr+/v8DAwMHBwcLCwsjIyMrK
ys3Nzc7OztDQ0NTU1NbW1tfX19jY2Nzc3N7e3uLi4uTk5Onp6evr6+3t7f//
////////////////////////////////////////////////////////////
/////////////////////////////////////////////////yH5BAEKAH8A
LAAAAAAgACAAAAf+gH+Cg4SFhoeIiYqLjI2Oj4pRUJOUlVBTkIJFO5ydnp1J
mUpPTk49p0alSKdATZlNY7Eps1KxWLMpPZlJYr0mv0+9Vr8mODXHyMnJQYJH
Yc8k0UzPVdEkMjrZ2tvbzH8xKuFb4zrhNuNbKSPr7O3tLYIsIPNg9TnzMPVg
J/P9/v8mBKHwQPCLQRsEXRj8UoKgw4cQSQiawaNip4oWOX3YwLGjR48jBPnw
QhKDSSIknZhcybIlyxCCdHSZaaGmkJlLaurcyXOnB0E3qAjlQPSH0CESkipd
ylTpBkEdIEjlQrWF1KtYs2qFkEGQBgdgtYhdAbas2bNoHVgQdIGB2yx3cFG4
nUu3rl0GEwStIMLXIYQEgAMLHkw4giAYWBIbWMy4sePHjR8IenGlMoHLmDNr
3py5gSARNEIPGE26tOnTpRUIWiCgtevXsGPLPiAIQYDbuHPr3s27gCAFAIIL
H068uHHfgihUWM68ufPnzzNJn069uvVGgQAAOw==
}

{Large database}
{
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
}

{Correspondence chess}
{
R0lGODlhIAAgAOesAGVkYGxrZ21saW5taG5tanBvbHFvbHFwbXJxbXNzb3V0
cXZ2c3d2cnl4c3p6dXx6d3x7d359eYGAeoGAfIKBfIODfoSDfYSDfoWEgIaF
gIaFgoiGgYiHgYmIg4qJg4uKhIuKhY2Mh4+NiY6OiJCPiZCPi5KRi5KRj5ST
jZWVjpaVkJeWj5iXkZqZk5qZl5yalpyblJ2clZ6clp+dmKCfmqKhmqKinp6l
np6mnp+mn6emoKimoaOpo6yspa2tqKqxqquxq6yxrK60rrC2sLS0tLK4sra2
tre8t7q6uru7u7y8vL29vb6+vrzBvLzCvMDAwMHBwb/Ev8LCwsHEwcPDw8TE
xMPGw8XFxcbGxsfHx8jIyMnJyMrKysjMyMnNyczMzMrOysvOy83Nzc7OzszQ
zM/Pz9DQ0NHR0dLS0tDU0NPT09TU1NPV09XV1dTW1NbW1tXX1dfX19bY1tjY
2NfZ19fa19nZ2dja2Nra2tvb29zc3Nzd3N3d3dze3Nzf3N7e3t7f3t/f397g
3uDg4OHh4eHi4eLi4uLj4uPj4+Tk5OXl5ebm5ufn5ufn5+jo6Ofp5+np6enq
6erq6uvr6+rs6uzs7O3t7e7u7u/v7+/w7/Dw8PHx8fLy8vPz8vPz8/P08/T0
9PX09PX19fb29vf39/j4+Pn5+fr6+vv7+/z8/P39/f7+/v//////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBGW+OBhA4YLEyoknEhQxSZVqlJpTNVJBMWJNk6NsjQJkqNFijaVevHx4A5U
nkqeVISI0CBIpFi2HOgD1SZJMxEZGvSHTx5Folzs/NcDlSZHjWgODWQUz5w4
hjadaKnjFKaoiaby0WM1Tps1aAJV0kCxhqlNi8ISCvSHrJ04b9CeKTNmkKIH
CWeE4pSoJl09ee7mVbP3yxIjVQzxWXCQBqNRNYkitjNnsZksRLAgKrWKiRZH
WxIYlJEKEVGjnN+0+YLkSR5Qq1ShMmWqEhQxkw4YjKFKch6ra6QkWXNJ1apU
p0iNGiUKlCklXC4hGL5KkJ4vSsb+OELFSlV06qBAefLEaRMnR200bS8YY5Uo
MKBYrUJVqrp6Tu1togkmmFxiiRmSYGIAd55sEgYn/wU4YIGWWFJJJZJkkYgk
lixYEAyrACjJEZZMaKCFlUwiiSSQQHJFHi1W4iFBMKgioCaHDNGISTyaBFUj
i1yBhiNQyWhQjQReckkdQeSRB2JOPukkFVg0AuQiRn6oipIVVtIFEFPcIOYN
OOSAAw9ILIKSIolkSaMqKE6i4hBCZILKKJtMkkggVvzQRyKAIuLmQDCgIueK
jjRBRimTWKmmIpDSUcQdQhkyyYyEmrIiJIdEQQknV0LKZmGIAOKEG4QQMskA
R5pi0h5yaZAiyZqjIlJpqoR4wYaqARxZSiN+POLJmoHeiiuucMgxSa8fklLI
J5PUauyx1O4RCbMEtWDKKP9tIiCFF8op7riTWCKAQSuwkAIKJpAwQgggdMBB
BhZQIEEEEDjQAAMKJIBAAQQAsNTABBds8MEIFxQQADs=
}

{Computer Chess}
{
R0lGODlhIAAgAOf/ACEkUBcjhyYoVSkqVyosWSstWi0vXC8wXjAxXy4tejEy
YC40ZzExdzM0YjIwfTM2XjY0aTA3ajY3ZS82gTM5bDY1fDg4ZzQ6bTU7bjs5
bjY8bzQ4izk4fzg9cTw4hz88cj0/aDo/c0A9cz46iTg9ij09fjtAdD87ijk+
izxBdUFAcEI/dTpAhz1Cd0RAd0I9jUdJRklKSEFFekZDeURBikZFdUdEe0VH
cUtMSkRGgUlFfExOS0pGfUtJbkdGiUtHfk5QTUxIf0RJkUtKe09RTk1JgVBS
T0tKjVFTUE9Lgk1OeVJUUVBMhFNVUk5MkE9Qe1VXVFNTclFSfVZYVVFRjlJU
f01TlVhZV1ZRiVJSkFdVe1NTkVlbWE9VmFhTi1RYfVlUjFVVklRXjVtdWlpX
fVtYf1Zbf11fXFdcgV5gXVxcfFhdgllZl19hXl1dfWBiX15efl9ff2JkYWBg
gGNlYmFhgWJigmNjg2BkimZoZWRkhGdkf2Fjm2ZmhmlraGpmgmRojmxohGxu
a2ZooG1qhW1pkW5rhnBtiHJuinNvi25yjHN1cnB0jnF1j3Z4dW5zpnh5d3N3
kXt9end6lX59dX1/fH+Bfn5+k4GDgIOFgoCJhIWHhIaIhYGErIiKh4qMiYuN
ioyOi42PjI6QjZGTkJOVkpCTr5WXlJOakJuakpqbmJeXupyem56gnaGgmKCi
n6GjoKOloqOiuaSmo6aopaeppqmrqKqsqautqqqqwKyuq62vrK6wrbCyr62x
wLO1sra2rbW3tLa4tbq8ubS9xbe7y7rBtr2/vL/BvsTGw8PKv8bIxcfJxsrJ
wMvKwcnLyMfOw87NxMvOysnQxdDPxsvSx87QzdDSz9XUy9PV0dTW09fWzdPa
z9bY1dva0dnb19vd2t/e1d3f3Nvi19/h3d3k2eDi397l2uPj2eHk4N3m4eXk
2+Pl4eHn3OLo3eTm4+Xn5OPq3+bo5eno3+jq5unr6Ors6evu6u3v6+7w7fDy
7/Hz8PL08fP18vT38////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JLDVKlMGD
CEN98sRpUyZMlipJkgTJkSSBGP+V0tevo8ePHfmJHMmv3z5++SBlFAiLX7EX
YWI6mTlzy5YsVKhkAWNzi5Nu+TKt/FdLX65Ck5JeWro0EaNEiQ4ZUmSoqpNY
10QN5aVvVaBJl6AqQtRHkVRCffro2bOnzx4f2eyVGiosX6dCicoqQkvoD9u/
dvqsUfOFxS9hrIYew/dIj6E/atXe6YNnjWA3Zno8EACgQjZ5sYYmq8cHjx49
dlLHiWPGDZwvakAI4Dx7grBbuIY+m8fGzpw4a8yYUTP8SxQQAwgUKDCguYNs
5HqtBCWNXhjhaoiT2S6lx4ICB8L+H0CgQEGCY7OCjck4Sps8J2W2k/lSRUsP
CwogjC8PIX+EBMx8M8wZGYnSjTtWVFGFFE9IoQQIEUSgQAMQWFChBRhawAAx
3yDTRkahgIOOE0+UqMQNGWCYQYosZvDBix844Ms3yVyRkSfmkOOEEkPU8IEG
GrhogQofqLCCCCokqYIIDMiSjTUfYrSJPN+gQCSRKyTpgggtcOnCCi640IIM
NVRgyjXP2IgRJvKMQ0MLRrpQwwwzyCCDDTrwIEMQdhYRRBEldHJNNmoKBAk9
34xgpwx5yuCnDEnIwEQSTEyaRA5i5PCINNkgkREk9XATAAovnEACqae+cCoK
q6Lg6gb+GwxCTTY4fGoPNtRUU4000/A6DTTSAAMMM9A88ww0yijTTDPJBBjD
p3HdY8+09dBDjzzyqMOOOuuksy057KQjjjjkgJNMrRktIogffuSRBx1vvHGF
vFfU2wQSOOSLQwz8xoDuUBkZsQkvvIxisEKj7GLLLCoB7LBAS7DSy8S87LJL
LxXboooqr7wySy2zAJyHHG+kkUa9KE8BxRJX4NByvv7qS4cttNySkRzkgpsO
Oej0TM7P7JCTDrbhsmM0OWrWYgtGp6jCytNQb+x01E+r8o3Uqsz1Dyy1CETH
MbTMMovUvmzcCtZhz0LLM7CIPcsxY9CytEB5HFOLL3frYstzLb7wokvfvugC
S+C69PKLL7fYgswbK81yCiWQUBILJJFTDjnkm6RCeSWqUNPQJq10jVEa36xD
zjrlmI5OOuj8vDo67KwzzzzyyD4PPerMM44RGE1xBRdcoEzEEkgYQTwSSyTf
BPEsG4HEFSzn+/D01GcUEAA7
}

{Index of games}
{
R0lGODlhIAAgAOcIAEVFRUdHR0hISE1NTVFRUVJSUlRUVFdXV1paWl1dXV9f
X2FhYWNjY2RkZGVlZWZmZmdnZ2hoaGlpaWpqamtra2xsbG1tbW5ubm9vb3Bw
cHFxcXJycnNzc3R0dHV1dXZ2dnd3d3h4eHl5eXp6ent7e3x8fH19fX5+fn9/
f4CAgIGBgYKCgoODg4SEhIWFhYaGhoeHh4iIiImJiYqKiouLi4yMjI2NjY6O
jo+Pj5CQkJGRkZKSkpOTk5SUlJWVlZaWlpeXl5iYmJmZmZqampubm5ycnJ2d
nZ6enp+fn6CgoKGhoaKioqOjo6SkpKWlpaampqenp6ioqKmpqaqqqqurq6ys
rK2tra6urq+vr7CwsLGxsbKysrOzs7S0tLW1tba2tre3t7i4uLm5ubq6uru7
u7y8vL29vb6+vr+/v8DAwMHBwcLCwsPDw8TExMXFxcbGxsfHx8jIyMnJycrK
ysvLy8zMzM3Nzc7Ozs/Pz9DQ0NHR0dLS0tPT09TU1NXV1dbW1tfX19jY2NnZ
2dra2tvb29zc3N3d3d7e3t/f3+Dg4OHh4eLi4uPj4+Tk5OXl5ebm5urq6uvr
6+3t7e/v71paWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpa
WlpaWlpaWlpaWlpaWlpaWiH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
BAFg2MBQg0MNDDc8hNjwYcSJE/4JuDOoj6IoTpaYmfRn0hcnT7BMwhOpDRMn
TiARWtSnSRMmOTTm4dLiEZIQJ8bIiSFICwoSUdSscIKGxYkigFLk2NNjBZAb
GvE8WQAJCQQJYO4UEGQFgYEmcwQcQUPigBBHIlTkiaEAB1YBa3CAODMlxQwy
Uz508eJiBZYyH5KgsYHCiZwRN+LwMBFkh0YhO274eOSGkJ0dNnj84WMHEegd
bxSlgSTkhg4ukb5IUqIxSI4VPRhFkUMnh4odfc50MaRDRY42e5Y8CuLihhZF
m2kLACLCQI5DGZLIaTFghp4bKQT+zSCAQo0VB4h6IOBwhc5Y6V3AZEFj5QWO
L2SymOFSY0aWM1mIEQYPMESBhhZelEHEC0n0oBEcjjiySA4xxCBFhI0kUWEQ
jUSoRYU1GBIhGzJUOINGbzDCSCI3vPACFCoucoSLPiyi4hUuzkCIimq4+MKJ
ArBhiCGD3AADDE8MWYgRR/owpCFVHEnDH0OacSQMQPZQIQ15AAIIGSay4eUc
JcbghZd84FChE14CUoRGOKCAwgp9FFIIGXKm0Iaddsh5Ahd2BgKDnErYuaRG
NpRQAgp7DDKIGIqasIajdJigqBaO/tGCokc4OogRGhUBBBBCgDHGGFaMGoQW
p3YRxKj+VJwaxhCjNnHqGD9ohIYff+yRAgggCOGHH33oBcILw/qRBLAl3PGH
H1wACwIMGp3BBx95mOBBBz9cu4cNHnjQwrV8HNGBByLQca0W53rwgkZl6KHH
HSQw1IO8edDA0Ap5yFsEQyDIIe8VHDDkgkZA2GDDDVdooUUTCtsQhcNURLyE
w1jkoPAQDmvhoAAuWGCBBm3UUQcVImPQhclmXCAyEybH4YHIOZhcxxAatUAB
BRisMcccUexswRY/k1HBzkr8/AYHO9/w8xxCaPQCBguRscYaTVCdgRVXe0E1
BkdcfcYHVNtw9RpAaOTFGm+okYELHsjQxhtroDACCiDMzUb+DhnEUIEZbrCx
hAQ5RMCC2mOAcUYFO4jwghlgmFGCCjJwgAYYZNjAARARjBGGGElIkIQDK2jU
hRZXkDFBDyS0AIYVYIzQAg0akHFFFzR0MMQDYFyRxRERPMGACqHKAIMOMgzx
gw01yHADDUEIMYPGM2hGxAw7vHA8Dkf0p1EJPbDLReBDSCDFAkZkoYUTD/Rw
AQ9nrBGG+UGkEEYaYuQqwAgnSJHAFKcKggrS8AEk0AEPUJjBH6iggzS4gQsW
iEIVTnCFKGxBf3ExAgOogIQk/GACuzOCEpLAPiOA4AZNSIIVGuCDFpAACkmY
gg/+EQAVrIAFKtABDnBggxuq4AYWO/QNC1ZAgx3q4IYsgEEOcKADFPwjIAA7
}

{Player collection}
{
R0lGODlhIAAgAOfBAEhISE5OTlFRUTlbiFZWVldXV1pbXVxcXDVkojRlpDZl
oTRmpDVmpTZmpDdmpV9fXzloozhopjlopDlop2FhYTdqpz1poGJiYj5poTpq
qGNjY1BrjGdnZ0ptmkZuoGhoaEBwrGlpaVpsgmpqakRyqVBwmGtra21tbVlx
kWZvem5ubl1yjm9vb1Z1m3BwcEt4sXFxcXJyclB5rXJzdHNzc3R0dGp3iHV1
dXZ2dnd3d3h4eHl5eVeAs3p6elGDvXt7e1mCtH19fVqEt3l+g1WGvVqFuX5+
fliHvH9/f3CCmICAgFeKwoGBgYKCgoSEhIWFhYaGhoeHh4iIiGmPwImJiYqK
imGUy4uLi2OUyoyMjI2NjWaWzGWXzI6OjmaXy2aXzGaYzGeYzJCQkGiZzWmZ
zGmZzWqZzGqZzZGRkWqazWuazZKSkpOTk26cznWaxpSUlG+dznCdzpWVlXCe
znGeznGez5aWlnKeznKfznOfz5iYmHWhz3Wh0Hah0Hai0Zqamnei0Jubm3ij
0Hmk0Xqk0YGjzHyl0p6enoKkzHym0n2m0p+fn36n0qGhoYGp04Gp1KKioqOj
o4Sr1aSkpIWs1Yas1Yur0aampqenp42t0omv14qv16mpqaqqqoyx16urq4+z
2JSy1pGz2a2trZG02Ze115S22pW22pa325e427Kysp262re3t7i4uKK93Lm5
uaG/3rq6ury8vKnD37+/v6vE4cHBwazH4sLCwsPDw7TL5bbM5bbN5rfO5rnP
5rrQ587Ozv//////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXMiw4cEeOCJKnLjDoUEcwHLZoiUr1qtWrFhRsVhQhyo9dtaI6ZKlChUp
bGKQHFgDF6ZJjQ4FQimHzRsaLFy4YEGUhQoVMBLS+CRGC5UoTpooQRKkKppD
ixY1gnSpEycTCVmwOvTHDpumV55GgQIlShQqVbSIYcOGQ8ITkaQ8YWLkx44c
NWjEgEGYRg0cOnoEMXIhYYhRdpIkmEy5suXLkxkQ/PCHCQpEv0KLHk06dC9e
vHrtakBQQ6MuLTKhYkS7tu3bjBw9eqRpVgSCF9b06FBKFO7juCWtmkDwgRwp
Hlx5Qk6dkSBJoTIQPBAlB4ZalargHxdEZ5OlCgQLVHECQZcj8bYVAaJDB1Qh
BwQJIJkhwRd82ooMkgd9dJziRkECGDEECbccp4ghhBAyiCB94EEgfahMUVAA
N6QgAywAEiLIHhZeaCKBpghREAA02MBDKoTwcceJNF5IygsGjSACEJTU6COB
noBg0AcrFJHIHHEkGQccTDbZZBtQRikJcwVpsMERdaihZRpcdpnGGWeUIaaY
ZJBhhh8LGERBCUSMEUYYYMT5xZxfeEHnnV9swQUW+BVkgAVLWCHooIQWaqgP
Chg0AGaMMorATJBGKumklFZqaUAAOw==
}

{Tournament}
{
R0lGODlhIAAgAMIDAAAAAAAA/zw8PMi9vci9vci9vci9vci9vSH5BAEKAAQA
LAAAAAAgACAAAANoOLrc/jDKCaqt497JO9WZFYpeaZ5oFCjr0L5sKs9SYNsK
oAh7P/A/H0dHixBlN1ww4wM6hZ5j0SEtJVtP5jILRFWni28t2fQRuUUxWN24
lre595SdHt/eaG0XrOUzxG5wgll0foaHDQkAOw==
}

Internet
{
R0lGODlhIAAgAOf/AC8uUTIzYTY3VTg4Zzs4bjY8bzg9cT07cDk/cz4+bTxA
dUFId0dGdjRQhydYk01MfSpalUlQfyxblk5PelNTXC5cmExSgjxYj0dVgzxa
izBemTJfmzRhnVRWgTtfllFXhzZjny5nojdmnD9jmlBejTponkFlnDRrpzxq
oD5soldllDpwrEFupVhokUhunz1zr0xxo1FwnUdzqmttamtsdUF2sk5zpUJ5
r0R4tGRtmG5qkkt3rlF2qEx4r1d2o2tvlVN4qk18rVB7s3FxklZ6rUqAtlJ9
tWp2mmd3oVd+qlKAsWN7pHV1ll99q1yAs1yDsFeFtmOBrn1/fFOIv3t7nX97
mFuJunCDp3mAoH5+oGeIr12LvWaNum+LrWuMtHiIs2OQw22OtnOMtXmMsIeH
qYWJpGeTxoOKq3GSuW2UwYuLoX2QtHOUvIqNqGuXynCXxHmVuHaXv46RrHyY
u4uSs3WbyXqaw4SYvH+bvXifzH2ex4KewXuhz5mZr4Sgw4Chyn6k0oeixoOj
zJ+doYuiwImlyIGn1aCin4+mxIeo0ZGlyoyoy6KhuJSnwJGoxqajqI6pzaWn
pJOryY2t1pSsyp2pw5msxZKu0pevzautqou03Jmwz6Gww6ysw6+svZi01520
0pW236mxxqG0zaqyx5u32pW63LSxwqC41qS40Ji835+737a3waq91qO/47q8
uZ7D5bi8zKzA2anB37DA06DF6L+9wa/C26fH5LrC16XJ7LLG37DH5rfG2qvL
6KzM6rzI1rbJ48LG1rzL37jM5bXN7L/O4rvP6MLO3LPT8LfT6r3R6sTQ3s3N
18HR5LbW9L3V9NDR28jU4rzY8MXV6bna98rW5MXY8snY7M3Z58Hd9M3c8Mnd
99Le7Mbi+svj9c3h+9Xh79ni6tXl+dLm/9nl9NPn/9jo/N/n8Nzo99Xt/+Lr
8+Ds+t3t/+Tt9eft7+Pv/u/s8erv8uby/+ny+u7z9uv0/O31/vD2+PL3+vT5
/PX7/fj9//n///3//P///yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXLhQgYICBAo4ZKgwQQESawgp8qNI0ZkPESkWLIAE1LJCPp48wWPKlCpF
KgqI/KfjxyhZghIV44IHVLFfq1DtyhatUxaGWegM2+bsVrVtn8qxo4ZOHzpQ
iexQEtVm4Rlx+/A5c0bPHj1+/vzdU3aJSxARLJLkUPiDmj5//N6VS3fvblp/
8pzhMeFhAwsYBhBm6RUNHb961Mp9m4eXX750u0j1enerSQUYHg4YjNcBkqNW
xrLBmzeP373X9IZBCgWGCB5xyGywSFwwGgk2Ygilggevb7t28+CdU7YIjZ4/
ZnrEkYeogUFhY54Q4XLt3Dx95sL+szvHTQ8LFimA2EBRAYW0O7wHtjEWCNas
aeH2hTdHzts1SDCwUEIJInBgQgkS3EDLBAUl0E0wnxTjjT7jeGMhN9Mko4QL
Ao4gwggVsOAABGH8MNIl6KCyjT7scMMNNNc8kwwvAapgAgiFbVDCBhtc0UFB
A5iEjz75OHOMNskUw4surjiBAgolgCCCBxI4oEEIPshE0AGbEFNPWtaMMosr
tdTiiiqa7EAEDyJUIIEEFzjgwhKiEaTAHcHQkxY6o8AhyCqmhDLJJIbwUQcK
bVZgpRYtaElQDrjoQ40z4ojDBgo95KFJIonkkccbUdjQRBAmaDHGAgcdsBko
kviBSDTmksDABSCemuFGHnqEsQYchEiyhKMEJVAJNZB4wQMIIeDRyy1/vGGG
GXEkAgkloLRCSyNHMICQHKCkYUUJhXEQwifKyNLsH5fQghY915qIEBlYpAFG
CRV4IAIRU0wBRiKmoCILO38hw0gfClVhARg7jHhCEQzfcIMVf6QiT1r7NOMJ
QwEk4AMLI8iwgwwvvLBCEJSIY4w47zQTiy0UATDBBU4ocUOAKIjhTC+NWNLJ
Kay8kolINDAxwQc5dGGJOL1c0cIQWZTxSCSDzPSPFIOwEosnZExQwAABCEDB
DFJILfbYZJctUkAAOw==
}

{GM games}
{
R0lGODlhIAAgAOevACAgICUlJSoqKi4uLjEwMDMzMzY2Njg4ODo6Ojw8PD09
PT49PT8+Pj8/P0BAQEREREZEREVFRUlHR0lISEpKSk1KSk1LS0xMTE5OTlFR
UVVSUlNTU1ZWVllVVVhYWFtYWFxaWltbW1xcXF1cXF5cXF9cXF5dXWJfX2Bg
YGFhYWViYmVjY2RkZGZmZmllZWplZWhoaGtnZ2xoaGxpaWpqam1qam9ra3Ft
bW9vb3FxcXR0dHhzc3Z2dnd3d3p2dnh4eH13d3x4eHp6en15eX55eXt7e4B6
enx8fIB8fIN9fX9/f4CAgIR/f4GBgYZ/f4KCgomCgomDg4WFhYaGhoqFhYyG
ho6Hh4qKio+IiIuLi5CJiZCLi5KMjJCQkJaOjpGRkZKSkpeQkJeRkZSUlJWV
lZqTk5uUlJ6Xl5qampycnKGamqKamp2dnaKbm6Sbm56enqScnKWdnaCgoKef
n6KioqmgoKqhoaWlpayjo62kpKioqK+lpbCmpqurq6ysrLOpqbOqqrasrLet
rbeurrGxsbKysrmvr7Ozs7S0tLyysra2tr2zs76zs7+1tbq6usK4uMO4uLy8
vMO5ucS5ub68vL29vcS6usW6usW7u8a7u8e8vMDAwMe9vci9vcfExMfHx8nJ
yczMzM7OztLNzc/Pz9LS0tTU1NbW1tra2t3d3eLi4uTk5Ojo6Orq6uzs7P//
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXMiwocOHECMm3ESxosWKEgm92cixI0dFER1VGimnZKGRikrSiRQxkquX
P2Juekkq5g85ERW12qmjZ6WdoXrqIPOlqNGjR+8IRMSqKY6njpqCeoojC5ur
WLNmVfpvipCvp8Ky+Qom7KkfNNKqXbt2icAjLeKumksm7pS5q3jE3cu3rw6B
P1IIVkUYjOAnhFXlEMy4sWMcArN4nLyRhYnLmDNnpiFQTqrPHkL7+ZwIkyRA
W0yE7sSaSmgPK1h3aiGQzedUG3Lr0dQJj5g4mToNGrFB9pzcG5DITiEQzKfn
KKJz6uQDg/UawblgYL1IUgbrZxr+sTYhMAWF82Y7wTnPfsiNCxRYt+k04zwj
OKw9CBQRoX9YQZ0E0d+ABLKWRCdVREBCJ0ywtoFAHDggoSmmTNJJDBJmqCFr
LiTChwNEdAICaxm85ceJgkHSiQsJtCgbawmwpoIXnUywBiMKsEaBQFOQ4uMB
B/zRyQ5AHhBFFGawdgBrJ8RwISRhLNmJBAI9IcqVBRRgRSduZOllCawVwFoJ
DGhSRycyiNmJAwLB0MWbAwwgwSWd2BDnAAQc2MkArH0wgB2sLcBnJwwI5IAA
iCb6Am9wOKGFIax5IQBrHQgARCd5IKqkQAgE4OmnAUCARSCWPLIHFBV4ypoG
AVjQiREiqnZigEAMAGDrrbjmquuuswqUAXLABivssLlJZOyxyB4bEAA7
}

{IM games}
{
R0lGODlhIAAgAOeNACAgICUlJSoqKi4uLjMzMzQ0NDY2Njg4ODo6Ojw8PD09
PT49PT8+Pj8/P0BAQEJCQkREREVFRUZGRklISEpKSk1LS05OTk9PT1FRUVVS
UlNTU1RUVFZWVllVVVhYWFtYWFxaWltbW1xcXF5cXF9cXF1dXWJfX2BgYGFh
YWViYmVjY2RkZGhlZWZmZmllZWhoaGtnZ2xoaGxpaWpqam9sbG9vb3Jvb3Fx
cXVycnR0dHZ2dnl2dnd3d3h4eH13d3p6en55eXt7e4B6enx8fIB8fIN9fX9/
f4CAgIR/f4GBgYKCgoWFhYaGhoqFhYyGhoqKiouLi5CQkJaOjpGRkZKSkpeQ
kJSUlJWVlZ6Xl5qampycnKKamp2dnaKbm56enqScnKCgoKefn6KioqmgoKqh
oaWlpa2kpKioqKmpqbCmpqurq6ysrLGxsbKysrOzs7S0tLyysra2tr2zs76z
s7i4uL+1tbq6usO4uLy8vMO5ub29vce8vMDAwMi9vcfHx8nJyczMzM7Ozs/P
z9LS0tTU1NbW1tra2t3d3eLi4uTk5Ojo6Orq6uzs7P//////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXMiwocOHECMqtEOxokU7Ev+d4cKxo8eOayK60YMHD5iTbEq+OSlGoh1G
MHvI5ANTkMweSiLGWcQzh089PAH5zGElitGjSJFmEdhGkdMaUO04/QO1xhMt
WLNq1VpGIJMfYAuJ1QJ2ithCPWaoXcuW7RGBQ1rITUT3itwldBPpkMu3r98c
AnugGIyo8JTBSQojujG4sePHNQRC8UK5suXKK0Ro3syZ8wyBYA6J9kBajWg8
Hvr02ZFadRPSHlSoXu2hhUAthnJr2H0mNx0NqnEAVx1mtwYis4WjEEjFj/MT
0ME4R2NBtY3qfeTkwWDBApY61i3+lBB4goL5s0bMm1dNg4LqLn1kmJ/zhT0F
DwJDRNhPqH+Q/fupFkMEqhXRhxMRjNAHEgJGsIFAHDgg4SAU8iChhKqx4IBq
LsCRhgNA9AFChg5cIFAQa6QIXXkJtJiAaim82EcKUvQxwRZzKABjAhR4FciP
BwQpZJCqmXBAkTD0AcMdVRzZh5ESCKQEIFQSYOWVVqpGAgFaMrDHGH3EwGUf
Wz4g0AtHDaDmmmqq9sEAbg5AhmoLwNnHmwoI1IAAfPbppwCqdQBoH4L60IcZ
fAYqwAECIRDAo5BGGoBqGUzaR6UV9CHEo5QGUIBAFAAg6qiklmrqqQYMBAGA
rLbq6qsJ+2Uk66y0QhQQADs=
}

{Blitz games}
{
R0lGODlhIAAgAOf/AAABAA8RDRMSCRIUERoXChocGh4fHSYiEycoJismLzMw
HzYtPDoxQTU3NEY9GEA6T0M9UUdAVURGQ0lDWEtEWVVLK05LZVNJZVVPZFlP
a15UcGFWc11ZdHZjAGJYdF9bdmNZdmVad2JeempcdGhdemlee2RhfGZjfmxh
fmpjemdkf2llgG9qWGxohHBpgG1qhW5rhnBsiHRthHNvi3lyiXdzj3l1kXx4
lIB6hX16lnx8kX97mImCWIiAaIN9iISBc4B8mXt/moJ/m4SAnX+DnYaCk4aC
noKGoY2DlYmFlouEm4qGl4qGo6KQLIWJpIaKpYiLp42JppCNnYqOqZCMqYyP
qo2QrJOQoJCTr5SUqpKWpZKVsZuYipiVpZeatpqasJycppmdrLWiRp6bq5mc
uLCoQaGeosamFpueup+ftaGiq6SipqCkwMysH7WvVamnq66riqamvLCvgaio
vqyqrq2so6utqtGxL66ssMK3QKurwcSyYrCusry3Y7aykayxs6+uxbCyrtC4
Rc6/L7OzytS7SczEMsPBXtW+Ur28oLe3zbi5w7y6vsC5xbq60b/AqtnCXb+9
wdLCfb291L/BvrvAz8LCudvFZ9nQQMLEwcXCx8XFvMTGw93TQ9/Lc97LecfJ
xufZHuHNfN3NiMrMyeHPg87L0OffJNzQluHQi8/RzuPTjeTcXOrjKc3S1dTR
1uTWluPWnO7mLtPW0uXYntXX1NjW2tbY1dja1/PrM+Dho/btKuTbwPHnX9rc
2dvd2vHsUv7zDNze29/c4frwLt3f3P/0Eefmot7g3fPuXPvyMd/h3vDua/fw
TuDi3/ryR/HsgPTtc/juZffubeHk4OfovuXi5uPl4fXvfOnl1u/sof/2Qezl
0Pr0WvjwduTm4+Xn5Pn1a+bo5ezqzfDvqufp5urp4O/tvern7O3p2vr0gOjq
5+vp7enr6Pb1lers6eft7+3r7/n0ouvu6u3v6/Dt8u7w7e/x7vDy7/z2ufL0
8fP18vT38/b49f/97v///yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEhQYAgQ
IDx4QOihoMOHBEHQyKJHDyFCcdIwedEQoscQShQpmvMFCpGTSrKk8YKDx6B/
wTwKBAGDkCMyVbSoWfOGDp0/V24UkXPI0CljSCGG2FFpThY1dEDxilWKW7xr
qhj5cYMpV7Jk25I6DNIIzZc3s2LdOQPpUaZ79ea1o8WqlTR38qBtU+bQhaMv
Yf5kE3TnUyxYjzbhu2ePHjlpubzl86etm7GYA0HoQZPlT7o2iA6nGgVrnz7G
8chNUyZNXj53zfgSBLLIyRtzHRyggrWq1KdS+k7fe3cO2rNn4aZJ2xWKoAc9
VMDMwjeqggJJnzxdglRv32J86bT+eYud6xSmMgRn6DmCBy4+fSwO7NmOqJ+/
eovtjdMGbRqrPH30MBAJSpBxBSj26LPPPv38QIAYhRTSD37DrdOOOdWQcwwc
RdjQUQhxRGGGNfbUo2A//XAxQBN39HNaPe+00w461lizjCsrELGBQBykocQb
7dizTz31TNhPHQIQYAAf+pgTzzriiEPNMsNYY0IUHAj0ARs30LHOJpsoOCSK
CahiiwFwvVOOONZYYokv4oCQxY7/eBDHDXiUkwknJeLjnTUBzHKmPeawI445
17hpDTojUNERB17QwEc5Mtpjzz332IIAAAEYQIc9hlojjjPF/PILPCY40ZGc
QeCxjDj+6zhpjqYAIGBLoeWsyaY1yAizzCspKKGBQBsAwYQUqojDzjrv2NNA
rbbY00451phTLTLW/CLqGDXM0NE/KGRBQySiikOtBA3YcmG11lprDTWCipOC
Eyc4BwUNa9xara7moLNmje/OQs0v1jYiwhDfCuQCFDKQ6261NbprDjW3CmqL
OCMckYJDHhhBAxKmsKuttcWY88uttlgzS79FzHDDsA6JUIUMV5BiS8rZ+mIJ
Je/aQvEv7IBxQhQiQGTBClXMgITPs2hri5tMzyJOPUiEOwIFHmGQQhU3uMBI
jbMIM4svs8zCjj2ajFADFCJYINM/FBwchQspgPEKOvHcE89KMGOksPANIEDw
tkAMYHDCEVQAIUMKJKAwggs0UDFEChgwMDhBEGBAQgw36OCEE0bsEAMHGjxw
OUQUaLCB6h5YEEECp8cu++yXBwQAOw==
}

Tactics
{
R0lGODlhIAAgAOeKACAgICUlJSoqKi4uLjMzMzQ0NDY2Njg4ODo6Ojw8PD09
PT8/P0A/P0BAQEJCQkREREZEREVFRUZGRkpKSkxLS05OTk9PT1VSUlNTU1RU
VFZWVllVVVhYWF1aWltbW1xcXF1dXV9eXmBfX2JfX2BgYGFhYWNhYWRiYmVi
YmVjY2RkZGhlZWZmZmllZWhnZ2hoaGtnZ2toaGxoaGpqam1qam9ra29sbHJt
bW9vb3Jvb3Rvb3FxcXZxcXVycnR0dHdzc3Z2dnl2dnd3d3h4eH14eHp6ent7
e3x8fH9/f4CAgIGBgYKCgoWFhYaGhoqKiouLi5KMjJCQkJGRkZKSkpiSkpSU
lJmTk5WVlZqampycnJ2dnaObm56enqCgoKKioqWlpayjo6ykpKioqK+mpqmp
qaurq7KpqaysrLGxsbKysrOzs7S0tLuxsbyzs7a2tri4uL+1tcG2trq6ury8
vMO5ub29vcS6usa7u8e8vMDAwMi9vcfHx8nJyczMzM7Ozs/Pz9LS0tTU1NbW
1tra2t3d3eLi4uTk5Ojo6Orq6uzs7P//////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CBMqXMiwocOHECMqlEOxokU5Ev+J0cKxo8eOZyKqqTNnTpeTaEquOelFopxE
MIfIzAPzj8whSyK6QcTTh886PPv49FElitGjSJFiEZjmkFMcUOU45QMVh5Ms
WLNq1fpFYJMiYAWJzQJWilhBQ2aoXcuWbRKBR1jINUT3ilwmdA0Bkcu3r18f
AoeUGFyosJTBSgoX2jG4sePHOAQ+4UK5suXKKj5o3syZ8wyBXQiJ5kC6jOg5
pFPr0ROEg4stcO6woRKCNAuBWQbpxsBbjO43vIOv7iECjp4xVtroCcO7hMAp
e6KTmN4lOpkK2LGvzgFFDxjsJ1bYp6gAQiCJCejPIkHPnv1qGzWImEBfYXWM
CRwEeojAP5B/I/wFGOBqMggYwQ96xEFBBBkIpEEDEAIioRAQVljhaitYSAMd
dsAAoQUCGXHGiNOdl8CJKJ64GgootoBHHB2gOIFXftR4wI045njjaiPgaIYe
POQogUBL9GEkAUgmqSSSOugAQZI36MCAkg4I9MJRA2Sp5ZZcdrmlAgItIMCY
ZJZp5mobkIlmmQcIhEAAcMYp55yrXRBnnXIWINAEAPTp55+ABiqoAQM9YOCh
iCYaQUaMNuooRAEBADs=
}

{End games}
{ R0lGODlhIAAgAKUJAAoKChERESgoKCkpKS4uLjAwMDExMTc3Nzg4ODw8PD8/
P0REREdHR05OTlFRUVJSUlZWVlxcXF1dXV5eXmBgYGFhYWJiYmRkZGVlZWZm
ZmhoaGtra2xsbG5ubm9vb3BwcHFxcXJycnNzc3R0dHV1dXd3d3h4eHp6enx8
fH5+fn9/f4CAgIKCgoODg4SEhIWFhYiIiIuLi42NjY+Pj5SUlJaWlpeXl5ub
m52dnaCgoKSkpKenp6mpqaurq66urjw8PCH5BAEKAD8ALAAAAAAgACAAAAbq
QJ9wKEwQj8ik0mdcOpeJaPRJRTar2GKWKot5v7HtkUQum80qsWTNbrdLYgtk
Tq/TxcKGfs/XU/A+FQyDhIUMgEIKiouMF4g+GgeSk5IIj0IFmZqZEUctQzct
N0MtO0ghqKmoo0M9KCkqKiizsSkoNEgduru6YUQjwMHCI0geBMfIyI8mfX0O
iAEA0tPUAHBDGxg8GNzbGJc+IBw+HOXk45ckH+s66+vgDYQzheAsKTgpL/cp
KeAKBycmBTwADoYLGy5qHHThApwBARBXDIAoAJyIXTl4XXqQrOMCRBma9ZkA
qJpJaeBSAgoCADs=
}

{Openings for White}
{
R0lGODlhIAAgAOfuACs5X8sAAMwAAM0AAMwBAC8+Z84BAc8CAs4DA88DA8YN
AzZFdFQ8YTZIeDdIeDdJdTZJeDhIeTdJeDdJeTdKeTlJejhKeThKejlKeThL
ejlLeTlLejlLeztNez5Ofj5Rfj9RfT9Rfoc7VURXg0dYhZ03TElaeEpcbExZ
g7A0RFVkPtonJsAxPtIuNVRmZFFhiFBijFlpklpqkltqlHRhgltrlF5sk/A0
NF5tll5ulXJ+Cl9ulnSAC3WBC2FylGNzmfFAQORGRnuHF2h4nWl5nmp5nWt5
nm17n3OBg/JLS25+onF+nnV/oHaCoelXV4eTKXmEo3mFoPJXV3mHqnyJqXmK
rHqKq3yLrIKNp4SOqfNjY4SPqe1nZ4ORsoeQrZWhPYiVroyVrIqYtvF1dcSi
AcaiAMekAJGfu5agvKqmcJekupqnwfSGhuuMj7mxYZWwz5ex0KKux6Kvx6Kv
yM22Mpmz0faRkcO3UZq00feRkZu00pu10qC41Kq3zqW81qa916e+16680a+8
0q+806m/2L3Kb6vA2azB2bK/1K3C2q7D2q7D26/D26/E27DE28POe7fE07jE
0b3C0rLG3LPG3cHDybjF2LPH3bTH3bnG1brG1LTI3bXI3brH2bvI1bbJ3rrI
27fJ3sfSiLfK37jK373J18bHyrnL38nTibrL37rL4LrM4MnJyrvN4MrKyrzN
4cDM3sDN2sDN3b3O4b/P4sLP3b/Q4sDR48PQ4c7OzsHR48TQ4c/Pz83P1sLS
5cPS5MXS4dDQ0MbS4cbS4sTT5MfS4sXT48PU5cXU5cbU5cfU48bV5cfV5MfV
5snV5MjW5snW5MnW5snX5cvY5srZ6MvZ5svZ6Mza58/a6c/b6dDb6dba4drb
3tLd6tPf7Nbh7tbi7tfi79fj7+Hh4djj7+Li4tnk8Nrl8OPj49rl8err7uvs
7/Hy8/b29v//////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CP9VmMCwYUMJDSJKnIghIYcqzozZ+pTokCJHkzB9IrXqFS1dv5A1gxUiIQVc
1yBd+lPnjc2bOHGmekEGIYRu1TLNrJmzqE1SPugglBBu2rGhRo1einLHzEEP
5qT52gRID5yoORmBcWPVIIlz0p7SxOnOXVRCatKUOQgjHbStXb++advWqB85
Knj0MCgjHTO1RPfyNconEBJROgz+MIzXq02+bovu6eQClRCDSihztXw5c1E4
u048emJwSjpliG9ijmrMRKEvBru8rvwVc9+iv1B4OSjmHGyoimcXpWVjuMEz
5oDx9r04pyomNgxGWEOuVmzqv3H+cvKSveAFOeRiTQdftBGa8gQz9CFXKjbY
nIbiaDCoAZE4T7zdh5Mfg+xX0AaWgKOJfQLaxAcoBhKEgSzfRBJgg2/gMUyE
A01QzDneUHPLKIsk4gglnIRySiuz2KILMck8s0w01mTDoUASYCOMFUUs0QQU
QAYppJBZbHHEDhYYBIE2RITBiitQRinllFBiUYMGDRjkgCU1mJLLl2DmwsuY
ZI4ZTDCV1FBDBwdBIEgNvYwj55zl1GlnnejkyQ0ONYBw0ANzDEHFNuoUus6h
iB7KTjuMMiqJESMAcNAHV+Sg5qU1zBDDppx2yikJBSC0gAMTRQRBqQ2QWqoD
CbXq6qsEsMIaEAA7
}

{Openings for Black}
{
R0lGODlhIAAgAOfvADU1NSs5X8sAAMwAAM0AAMwBAC8+Z84BAc8CAs4DA88D
A8YNAzZFdFQ8YTZIeDdIeDdJdTZJeDhIeTdJeDdJeTdKeTlJejhKeThKejlK
eThLejlLeTlLejlLeztNez5Ofj5Rfj9RfT9Rfoc7VURXg0dYhZ03TElaeEpc
bExZg7A0RFVkPtonJsAxPtIuNVRmZFFhiFBijFlpklpqkltqlHRhgltrlF5s
k/A0NF5tll5ulXJ+Cl9ulnSAC3WBC2FylGNzmfFAQORGRnuHF2h4nWl5nmp5
nWt5nm17n3OBg/JLS25+onF+nnV/oHaCoelXV4eTKXmEo3mFoPJXV3mHqnyJ
qXmKrHqKq3yLrIKNp4SOqfNjY4SPqe1nZ4ORsoeQrZWhPYiVroyVrIqYtvF1
dcSiAcaiAMekAJGfu5agvKqmcJekupqnwfSGhuuMj7mxYZWwz5ex0KKux6Kv
x6KvyM22Mpmz0faRkcO3UZq00feRkZu00pu10qC41Kq3zqW81qa916e+1668
0a+80q+806m/2L3Kb6vA2azB2bK/1K3C2q7D2q7D26/D26/E27DE28POe7fE
07jE0b3C0rLG3LPG3cHDybjF2LPH3bTH3bnG1brG1LTI3bXI3brH2bvI1bbJ
3rrI27fJ3sfSiLfK37jK373J18bHyrnL38nTibrL37rL4LrM4MnJyrvN4MrK
yrzN4cDM3sDN2sDN3b3O4b/P4sLP3b/Q4sDR48PQ4c7OzsHR48TQ4c/Pz83P
1sLS5cPS5MXS4dDQ0MbS4cbS4sTT5MfS4sXT48PU5cXU5cbU5cfU48bV5cfV
5MfV5snV5MjW5snW5MnW5snX5cvY5srZ6MvZ5svZ6Mza58/a6c/b6dDb6dba
4drb3tLd6tPf7Nbh7tbi7tfi79fj7+Hh4djj7+Li4tnk8Nrl8OPj49rl8err
7uvs7/Hy8/b29v//////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CP9ZoMCwYcMJDiJKnJghYQcrz47dAqUI0aJHlDKBKsUKVq1dwJI5iyUiYYVc
2CJhAmQHjs2bOHGqglEGYQRv1jTNrJmzqM1SP+ognCCOGrKhRo1ikoLnzMEP
56b94hRoT5yoORuFeWPVYAl0057SxAkAQNRCa9SYORhDXbStXb/CadvW6J85
K3r4MDhDXTO1RPfyNdpHUJJROwwCMYzXq02+bovy8fQi1RCDSyhztXw5c9E4
vFBAgmKQirpliG9ijnrshCEwBr28rvwVc9+iwFJ8OTgGHWyoimcXrXVjuEE0
54Lx9r0456omNwxKYFPOVmzqv3H+dvqSvSCGOeVkTQdf1FGa8gQ1+ClnKjbY
nIfkbDC4IdG4T7zdh9MfhOxXEAeXhLOJfQLa1EcoBhKUwSzgSBJgg3DkQUyE
A1FgDDrfVIMLKYwo8kglnYiCiiu03LJLMcpAw4w012jDoUATZDPMFUYw4UQU
QAYppJBacIEEDxcYFME2RYjRyitQRinllFBmYcMGDhj0wCU2nKLLl2Dq0suY
ZI4pjDCW2GCDBwdFMIgNvpAj55zm1Glnnenk2U0ONoRwEAR0EFEFN+sUys6h
iB7ajjuMMjrJESQEcBAIWOig5qU20CDDppx2ymkJBiDEwAMTRRRBqQ6QWuoD
CbXq6qsEsMIaEAA7
}

{Openings for either color}
{
R0lGODlhIAAgAOfRADU1NSs5Xy8+ZzZFdDZIeDdIeDdJdTZJeDhIeTdJeDdJ
eTdKeTlJejhKeThKejlKeThLejlLeTlLejlLeztNez5Ofj5Rfj9RfT9RfkRX
g0dYhUlaeEpcbExZg1VkPlRmZFFhiFBijFlpklpqkltqlFtrlF5sk15tll5u
lXJ+Cl9ulnSAC3WBC2FylGNzmXuHF2h4nWl5nmp5nWt5nm17n3OBg25+onF+
nnV/oHaCoYeTKXmEo3mFoHmHqnyJqXmKrHqKq3yLrIKNp4SOqYSPqYORsoeQ
rZWhPYiVroyVrIqYtsSiAcaiAMekAJGfu5agvKqmcJekupqnwbmxYZWwz5ex
0KKux6Kvx6KvyM22Mpmz0cO3UZq00Zu00pu10qC41Kq3zqW81qa916e+1668
0a+80q+806m/2L3Kb6vA2azB2bK/1K3C2q7D2q7D26/D26/E27DE28POe7fE
07jE0b3C0rLG3LPG3cHDybjF2LPH3bTH3bnG1brG1LTI3bXI3brH2bvI1bbJ
3rrI27fJ3sfSiLfK37jK373J18bHyrnL38nTibrL37rL4LrM4MnJyrvN4MrK
yrzN4cDM3sDN2sDN3b3O4b/P4sLP3b/Q4sDR48PQ4c7OzsHR48TQ4c/Pz83P
1sLS5cPS5MXS4dDQ0MbS4cbS4sTT5MfS4sXT48PU5cXU5cbU5cfU48bV5cfV
5MfV5snV5MjW5snW5MnW5snX5cvY5srZ6MvZ5svZ6Mza58/a6c/b6dDb6dba
4drb3tLd6tPf7Nbh7tbi7tfi79fj7+Hh4djj7+Li4tnk8Nrl8OPj49rl8err
7uvs7/Hy8/b29v//////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAgACAAAAj+AP8JHEiwoMGD
CP8xUMCwYcMEBCJKnPgg4YQfsVJlEsRGTZs4dvYIOuRI0qVOolbBmoQh4YJN
uuboEaOFis2bOHEyArEE4QFguPjM1AIAQM6jVA61yIIwATFbqmYWLYoUpx4e
W5ocrJCsVig/Y6YarWrzDZIpWg1qUFYrqhixZG2eiQKFycEQzGZ9HdOFalwq
Ya54WMHC4Ahmr9zCjfuFTI1CKQy6QPxVrN+b0aLd9ALow6IXBm1Q9mN5rM3M
mW1W8cRBjg6DPZi1UlX6MmrNNlNtQHPEYBHZoWqbvn1TVAcjB5Uomy0cZ+qb
l0wgN+gk2ai9XaogJW6zEQ4TBhH+SDmGyW3No7ef/zECvqCDK8coYdeeMz1u
OE/aE4QA5hgi8+jZp1kaVkRgUARrFBPIfPUJCJgZBhYkQR7D9AFgg/ZR8cUg
ERL0QCXC0MHgXzZxYUqHAymAijLB3KKJIW6wEccdfxCiCCSWZNLJKazI4got
ufCCokAJ7FIKEDLckMMOTDbppJNDEEGDCg0YdEAvMSTxSCRcdunll1wKUUIE
BBhUQB4lJMLJmmxy8smbcL5JCil4lFACBQcdUEYJoBjj55/IBCpooMsU+ssJ
JVxwkAFYwOCDL81E6syklE76DDSYYlrHDBkEcJAFQaBg56glkCDCqaimiqoG
AiA0QAETE0V0QKwEwBprAQnlquuuvPIaEAA7
}

{Theory: 1.c4}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACfYRvoauIzNyBSyYaLMDZcv15
  GDiKFHmaELqqkVvBXCN3UniXebq3/fuLBWlDmwN31CV5S18T+BRqokSqTSCYKB8lwWCQ3Wy1
  PCzZyU15wRdmerX+ZpHvCPY+H7fRZ2h9VvUX2CclaGTI4kc4uKfYWLh4GJkI+cgo5jZZo1EA
  ADs=
}

{Theory: 1.d4}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACf4RvoauIzNyBSyYaLMDZcv15
  GDiKFHmaELqqkVvBXCN3UniXebq3/fuLBWlDmwN31CV5S18T+BRqokSq8aEQCKRYJlYwGGyv
  E2VXyy17y2Bxtet8tMNbFlSuzZMva35cPXMHKOhHuGE2mFaoeNjX+Lf4ligZufdoiASHiVip
  UQAAOw==
}

{Theory: 1.d4 d5}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACh4RvoauIzNyBSyYaLMDZcv15
  GDiKFHmaELqqkVvBXCN3UggIwlTepa67pHzDoLBFbAF3m57jswzinqPobvpwZocaKneL9Opi
  yZdPMBgIaGWyeM32hrNodRxsftbTa1b+YWUj98fzVThDeJTYZKjohvd4uIglGel4V4l5KQip
  yTiXyRnqZwlQAAA7
}

{Theory: QGD}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACmYRvoauIzNyB6wgxaZBJm3t1
  FAdo24eJEGmiYelxLQjCo+zRYYvfksn7xYS+l23VQ9JUkWQTYAw6eMvjc5rTWSvOig4jfQyx
  PhIZSURHFRduuikYDFJsuaDRxUNTtrb+DGfXETf3JzZCKBiQWMiStbSoc/LmBlh5CHSFqZlR
  tnnZiWZpGMrJBHpKmjo5yvqpugUbVooa63pQAAA7
}

{Theory: Slav}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACmIRvoauIzI4QBy5XbTBzJo19
  lkSJUAhoG9CVKvq23hvGcgrWOUbz6u7oBXceU0Q3YnWMF+SJU8IlfckWs+GMyCjCB2grfVLF
  wymqTPZOi9JJc3wUDAaugJyOhb/ZC3ceHTdXdyfwp3ZyJ5iSiAfzdWMns6JnmGF2+PMGqInJ
  aZn2eUQ5uVl5RdppGiZaihrqeep4+aradVAAADs=
}

{Theory: 1.d4 Nf6}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACioRvoauIKqJoLrFVrYwhg4tl
  wcZ5IFWNZCeeJiexqdtCZX29q0lXZNxznGTC4MN4GPJAyxyO0YQ+QzPmFFW0Vp1baZfqyXLF
  3iwHe9QWBYPBhJgep8/wJFLTfkfBD3bbXWeh1rdzFfhxhzg0aMcoKNcI+VgWRxlpOcl3qZmJ
  tunZeahkuAeqKAlQAAA7
}

{Theory: 1.e4}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACfYRvoauIzNyBSyYaLMDZcv15
  GDiKFHmaELqqkVvBXCN3UniXebq3/fuLBWlDmwN31CV5S18T+BRqokSq8aETCCZKbEowGGw3
  XS5Pa3Z6W2DxhbmOtMNbZLyizdfLb3V6JnVXJXj1F2g4iFjYB0XI0qj4eMg4SQYXWSOZaFAA
  ADs=
}

{Theory: Sicilian}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAAChYRvoauIzNyBSyYaLMDZcv15
  GDiKFHmaELqqkVvBXCN30iII8V3yeU7jpYTAoCPk+xkfveNPyXrdnsDo7thkDjXYrbYlBOcm
  WXJKMBgILl6zeM0Gd1todVw6j9TTa2S+QtVXdnf1NVPohmeISLiUyLgxGNnWaPPnWGmFOSm3
  uOnnaRmqUQAAOw==
}

{Theory: Sicilian 1.e4 c5 2.Nd3 d6 3.d4}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACo4RvoauIzNxZQiyZYMOq1i1p
  oENZ4yNiQOedU8p5rSoGtPzRcLiTdY/S6AIfV0bIIbZsSSRPeWlCdDLjCjjBWYbTGI757IYj
  UrJqHEVbS+nKy+kTDAYmg5x+FPugIHfeHDdXB3An8JdGcidoo4hXc/NFiHMFF6Rn+YOIGSVz
  uJbSaPhYRjFnKorlSURXSHn5BuFB6JjqatY6qsaoiFoJy6BVUQAAOw==
}

{Theory: Caro-Kann}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACh4RvoauIzI4QBy5XbTBzJo19
  lkSJUAhoG9CVKvq23hvGcgrWOUbz6u7oBYEPYmakQ/qUQ2bReTwlpUtq0/rERiNTLqrqvYaz
  Xo9pvL2wBgOX8axmlXBQeGPdtq/AFwGbTSFE1ncjmHbH97MnFseI6Lg4+CgZeVipB/NGp4XZ
  1UiZWbeJ1olRAAA7
}

{Theory: French}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACiIRvoauIzNyB6wgxaZBJm3t1
  FAdo24eJEGmiYelxLQjCo+zRYYvfksn7xYQ+R9A4RBYfSeYy81RFeivqlFjFXpVZ7pbk7Ia/
  0OzLJi5PBYNB6jiuoNRyrZztlta9FXwbA0fXoAPYJHhiB4TI12C1F9eYuAg5echiqBfJWJnJ
  iUbWeRn1+WjJUQAAOw==
}

{Theory: Open Games}
{ R0lGODdhIAAgAKEAAP/739jGpgAAAP///ywAAAAAIAAgAAACh4RvoauIzNyBSyYaLMDZcv15
  GDiKFHmaELqqkVvBXCN3UngrghDnab7b0Xwtn3DowCUDQZ5t+Us2hazXbcqr9qBFDdf63T5K
  gN2EHKYJBgPBJTr+md/deGvdpoPtETzbrcRXgbWBJoh0OKOFeAbXWPe4Fyk2yahHeWlZ6Jj5
  lLjoWRnaCapRAAA7
}


} ;# icons

variable ::windows::switcher::base_types {}

# Initialise icons nicely

set i 0
foreach {icon data} $icons {
  lappend ::windows::switcher::base_types $icon
  image create photo dbt$i -format gif -data $data
  incr i
}

set numBaseTypeIcons [llength $::windows::switcher::base_types]

set temp_dbtype 0

proc selectBaseType {type} {
  global temp_dbtype
  set w .btypeWin
  if {![winfo exists $w]} { return }
  $w.t configure -state normal
  set temp_dbtype $type
  set linenum [expr $type + 1]
  $w.t tag remove sel 1.0 end
  $w.t tag remove selected 1.0 end
  $w.t tag add selected "${linenum}.2 linestart" "$linenum.2 lineend"
  $w.t see $linenum.2
  $w.t configure -state disabled
}

proc clickBaseType {x y} {
  set type [.btypeWin.t index "@$x,$y linestart"]
  set type [expr int($type) - 1]
  selectBaseType $type
}

proc changeBaseType {baseNum {parent .}} {
  global temp_dbtype ::windows::switcher::base_types numBaseTypeIcons
  if {$baseNum > [sc_base count total]} { return }
  set temp_dbtype [sc_base type $baseNum]
  if {$temp_dbtype >= $numBaseTypeIcons} { set temp_dbtype 0 }
  set w .btypeWin
  toplevel $w
  wm withdraw $w
  wm title $w "Choose database type"

  text $w.t -yscrollcommand "$w.yscroll set" -font font_Regular \
    -height 25 -width 40  -wrap none -cursor top_left_arrow
  $w.t tag configure selected -background lightblue

  scrollbar $w.yscroll -command "$w.t yview" -takefocus 0
  pack [frame $w.b] -side bottom -pady 5
  pack $w.yscroll -side right -fill y
  pack $w.t -side left -fill both -expand yes

  dialogbutton $w.b.set -text "OK" -command \
    "catch {sc_base type $baseNum \$temp_dbtype}; ::windows::switcher::Refresh; ::maint::Refresh;
     focus .main ; destroy $w"

  dialogbutton $w.b.cancel -text $::tr(Cancel) -command "focus .main ; destroy $w"
  pack $w.b.set $w.b.cancel -side left -padx 5

  set numtypes [llength $base_types]
  for {set i  0} {$i < $numtypes} {incr i} {
    if {$i > 0} { $w.t insert end "\n" }
    $w.t image create end -image dbt$i -pady 3 -padx 3
    $w.t insert end "   [lindex $base_types $i]  "
  } 

  bind $w.t <Double-ButtonRelease-1> "clickBaseType %x %y; $w.b.set invoke"
  bind $w.t <ButtonRelease-1> "clickBaseType %x %y"
  bind $w.t <Button1-Motion> "clickBaseType %x %y; break"

  bind $w <Up> {
    if {$temp_dbtype != 0} { selectBaseType [expr $temp_dbtype - 1] }
    break
  }

  bind $w <Down> {
    if {$temp_dbtype < [expr [llength $base_types] - 1]} {
      selectBaseType [expr $temp_dbtype + 1]
    }
    break
  }

  bind $w <Home> { selectBaseType 0 }
  bind $w <End> { selectBaseType [expr [llength $base_types] - 1] }
  bind $w <Escape> "$w.b.cancel invoke"
  bind $w <Return> "$w.b.set invoke"

  placeWinOverParent $w $parent
  wm state $w normal

  focus $w.t
  grab $w
  update
  selectBaseType $temp_dbtype
}

proc ::windows::switcher::pressMouseEvent {i} {
  if {! [winfo exists .glistWin]} {return}
  foreach win {"" .img .name } {
    .glistWin.baseWin.c.f$i$win configure -cursor exchange ;# fleur , pencil
  }
}

proc ::windows::switcher::releaseMouseEvent {fromBase x y dest r s} {

  if {! [winfo exists .glistWin.baseWin]} {return}
  foreach win {"" .img .name } {
    .glistWin.baseWin.c.f$fromBase$win configure -cursor {}
  }
  set dropPoint [winfo containing $x $y]

  if {$dropPoint == ".fdockglistWin"} {
    ### Hack to enable base selection when undocked
    # We need to find a way to lower .fdockglistWin in the stackorder for the purposes of winfo
    # alternatively , destroy the window and recreate without the embeded frame
    set dropPoint $dest
  }

  if {! [string match ".glistWin.baseWin.c.f*" $dropPoint]} {
    return
  }

  # .glistWin.baseWin.c.f.*.name
  set toBase [string range $dropPoint 21 21]

  if {$toBase == $fromBase} {
    ::file::SwitchToBase $toBase
  } else {
    copyFilter $fromBase $toBase
    ::windows::switcher::Refresh
  }
}

set baseWin 0

proc ::windows::switcher::Open {} {
  global baseWin

  if {![winfo exists .glistWin] || [winfo exists .glistWin.baseWin]} {
    return
  }

  set baseWin 1
  set w .glistWin.baseWin

  # Database Switcher is not a toplevel anymore.
  # It packs into the bottom of game list widget

  frame $w

  if {[catch {pack $w -side bottom -before .glistWin.b -fill x}]} {
    # Row of buttons is not packed
    pack $w -side bottom -before .glistWin.f -fill x
    pack [frame .glistWin.spacer -height 3] -before .glistWin.f -side bottom
  } else {
    # Spacer frame between buttons and switcher. Do we need it ??
    pack [frame .glistWin.spacer -height 3] -before .glistWin.b -side bottom
  }


  bind $w <Escape> ::windows::switcher::Open
  bind $w <Destroy> { set baseWin 0 }
  bind $w <F1> { helpWindow Switcher }
  standardShortcuts $w

  canvas $w.c -borderwidth 0 -highlightthickness 0 

  grid $w.c -row 0 -column 1 -sticky ew
  grid columnconfigure $w 1 -weight 1

  foreach i {9 1 2 3 4 5 6 7 8} {
    set f [frame $w.c.f$i  -relief raised -borderwidth 0] ; # -borderwidth 1 gives nicer display when cramped
    $w.c create window 0 0 -window $w.c.f$i -anchor nw -tag tag$i

    set f $w.c.f$i
    label $f.img -image dbt0 ;# -relief solid  -borderwidth 0
    label $f.name -width 20 -anchor w -font font_Small
    grid $f.img -row 0 -column 0 ; # grid item refreshed below
    grid $f.name -row 0 -column 1 -sticky we

    foreach win {"" .img .name} {
      bind $f$win <ButtonPress-1> [list ::windows::switcher::pressMouseEvent $i]
      bind $f$win <ButtonRelease-1> [list ::windows::switcher::releaseMouseEvent $i %X %Y %W %R %S]
      bind $f$win <ButtonPress-2> ::windows::switcher::toggleicons
    }

    menu $f.menu -tearoff 0
    $f.menu add command -label [tr SearchReset] -command "::search::filter::reset $i"

    $f.menu add command -label [tr SearchNegate] -command "::search::filter::negate $i"
    # needs some work in search.tcl and tkscid.cpp 

    $f.menu add command -label [tr FileReadOnly] -command "makeBaseReadOnly .glistWin.baseWin $i"

    if {$i == [sc_info clipbase]} {
      set closeLabel [tr EditReset]
    } else {
      set closeLabel [tr FileClose]
    }

    $f.menu add command -label $closeLabel -command [list ::file::Close $i]

    $f.menu add separator

    $f.menu add cascade -label [tr More] -menu $f.menu.show

      menu $f.menu.show
      $f.menu.show add command -label WindowsTree  -command "::tree::Open $i"
      $f.menu.show add command -label TreeFileBest -command "::tree::OpenBest $i"
      $f.menu.show add separator
      $f.menu.show add command -label [tr ChangeIcon] -command "changeBaseType $i $w"
      $f.menu.show add checkbutton -label [tr ShowIcons] -variable ::windows::switcher::icons -command ::windows::switcher::Refresh
      $f.menu.show add checkbutton -label [tr ConfirmCopy] -variable ::windows::switcher::confirmCopy 

      configMenuText $f.menu.show 0 WindowsTree  $::language
      configMenuText $f.menu.show 1 TreeFileBest $::language

    foreach win {"" .img .name} {
      bind $f$win <ButtonPress-3> "tk_popup $f.menu %X %Y"
    }
  }

  ::windows::switcher::Refresh

  after idle [list RegisterDropEvents $w.c]
}

proc ::windows::switcher::Refresh {} {
  global numBaseTypeIcons
  variable icons
  set w .glistWin.baseWin
  if {! [winfo exists $w]} { return }

  set numBases [sc_base count total]
  set current  [sc_base current]
  set clipbase [sc_info clipbase]

  # Get the canvas width and icon dimensions, to compute the correct
  # scroll region.

  # todo: Should only do this when toggling "Show Icons"
  set fontsize [font configure font_Small -size]
  if {$icons} {
    if {$::windowsOS} {
      set fontsize [expr {$fontsize * 4 + 4}]
    } else {
      set fontsize [expr {$fontsize * 3 + 7}]
    }
  } else {
    if {$::windowsOS} {
      set fontsize [expr {$fontsize * 3 + 4}]
    } else {
      set fontsize [expr {$fontsize * 2 + 7}]
    }
  }
  foreach i {9 1 2 3 4 5 6 7 8} {
    if {$icons} {
      grid $w.c.f$i.img -row 0 -column 0 -rowspan 2
      if {$fontsize < 36} {
	$w.c configure -height 36
      } else {
	$w.c configure -height $fontsize
      }
    } else {
      grid forget $w.c.f$i.img
      if {$fontsize < 24} {
	$w.c configure -height 24
      } else {
	$w.c configure -height $fontsize
      }
    }
  }

  ### When update is issued, this update steals focus from the main window ! &&&
  ### So we'll remove it, and use "reqwidth","reqheight" just below
  # update

  set frameWidth [winfo reqwidth $w.c.f$clipbase]
  incr frameWidth 1

  # unused
  # set iconHeight [winfo reqheight $w.c.f$clipbase]
  # incr iconHeight 5

  set column 0
  set x 0
  if {$icons} {set sep "\n"} else {set sep " "}

  # Check which bases are in use
  set show_num 0
  array set show {}
  foreach i {9 1 2 3 4 5 6 7 8} {
    set show($i) [sc_base inUse $i]
    if {$show($i)} {
      incr show_num
    }
  }

  # Check that there is enough space to show all bases, otherwise make the frameWidth smaller
  # '- 50' is a hack to make some room and stop the last base from being disadvantaged/squished

  if {[catch {
     # catch divide by zero. Possible on broken bases
     set f [expr {([winfo width .glistWin] - 50)/ $show_num}]
     }] || $f < 0} {
    # Catch when glist is (not) init
    return
  }
  if {$f < $frameWidth} {
    set frameWidth $f
  }

  ### Pack the clipbase (slot 9) on the left most
  # set numBases [sc_base count total]
  # for {set i 1} {$i <= $numBases} {incr i} {}

  foreach i {9 1 2 3 4 5 6 7 8} {
    if {$show($i)} {
      set filename [file nativename [sc_base filename $i]]

      # Highlight current database
      if {$i == $current} {
        set color $::switchercolor ; # khaki , lightgoldenrodyellow
      } else {
	set color gainsboro
      }

      $w.c.f$i configure -background $color

      # this should only be done once in DB open, not here &&&
      set dbtype [sc_base type $i]
      if {$dbtype >= $numBaseTypeIcons} { set dbtype 0 }
      if {$icons} {
        $w.c.f$i.img configure -image dbt$dbtype -background $color
      } else {
        $w.c.f$i.img configure -image ""
      }

      if {$i == $clipbase} {
        $w.c.f$i.name configure -background $color 
        set name $::tr(clipbase)
      } else {
        set name "[file tail [sc_base filename $i]]"
      }

      if {[sc_base isReadOnly $i] && ![string match -nocase *pgn $name]} {
        $w.c.f$i.menu entryconfigure 2 -state disabled
        set name "$name ($::tr(readonly))"
      } else {
        $w.c.f$i.menu entryconfigure 2 -state normal
      }

      $w.c.f$i.name configure -background $color -text "$name${sep}([filterText $i 100000])"

      $w.c itemconfigure tag$i -state normal
      $w.c coords tag$i [expr $x + 2] 2
      incr column
      incr x $frameWidth
    } else {
      $w.c itemconfigure tag$i -state hidden
    }
  }

}

proc ::windows::switcher::toggleicons {} {
  set ::windows::switcher::icons [expr !$::windows::switcher::icons]
  ::windows::switcher::Refresh
}

proc copyFilter {frombaseNum tobaseNum} {

  # Check status of source and target bases
  set currentBaseNum [sc_base current]
  sc_base switch $frombaseNum
  set nGamesToCopy [sc_filter count]
  set fromInUse [sc_base inUse]
  set fromName [file tail [sc_base filename]]
  sc_base switch $tobaseNum
  set targetInUse [sc_base inUse]
  set targetName [file tail [sc_base filename]]
  set targetReadOnly [sc_base isReadOnly]
  sc_base switch $currentBaseNum
  set err ""
  if {$nGamesToCopy == 0} {
    set err "$::tr(CopyErrSource) $::tr(CopyErrNoGames)."
  }
  if {$targetReadOnly} {
    set err "$::tr(CopyErrTarget) $::tr(CopyErrReadOnly)."
  }
  if {! $targetInUse} {set err "$::tr(CopyErrTarget) $::tr(CopyErrNotOpen)."}
  if {! $fromInUse} {set err "$::tr(CopyErrSource) $::tr(CopyErrNotOpen)."}
  if {$frombaseNum == $tobaseNum} {
    set err "$::tr(CopyErrSource) == $::tr(CopyErrTarget)."
  }

  set parent .glistWin

  if {$err != ""} {
    tk_messageBox -type ok -icon info -title "Scid" \
        -message "$::tr(CopyErr) \nfrom \"$fromName\" to \"$targetName\".\n$err" -parent $parent
    return
  }

  # If copying to the clipbase, do not bother asking for confirmation:
  if {!$::windows::switcher::confirmCopy || $tobaseNum == [sc_info clipbase]} {
    progressWindow "Scid" "$::tr(CopyGames)..." $::tr(Cancel) "sc_progressBar"
    busyCursor .
    set copyErr [catch {sc_filter copy $frombaseNum $tobaseNum} result]
    unbusyCursor .
    closeProgressWindow
    ::windows::gamelist::Refresh
    # hmmmm... how to stop . getting raised over .glistWin ?
    if {$copyErr} {
      tk_messageBox -type ok -icon info -title "Scid" -message $result -parent $parent
    }
    return
  }

  set w [toplevel .fcopyWin]
  wm withdraw $w
  wm title $w "Scid: $::tr(CopyGames)"
  label $w.text -text [subst $::tr(CopyConfirm)] -justify left
  frame $w.b
  dialogbutton $w.b.go -text $::tr(CopyGames) -command "
    busyCursor .
    $w.b.cancel configure -command \"sc_progressBar\"
    $w.b.cancel configure -text $::tr(Stop)
    sc_progressBar $w.bar bar 301 21 time
    grab $w.b.cancel
    if {\[catch {sc_filter copy $frombaseNum $tobaseNum} result\]} {
      tk_messageBox -type ok -icon info \
	  -title \"Scid\" -message \$result -parent $parent
    }
    unbusyCursor .
    destroy $w
    updateStatusBar
    ::windows::gamelist::Refresh"
  dialogbutton $w.b.cancel -text $::tr(Cancel) -command "destroy $w"
  canvas $w.bar -width 300 -height 20 -bg white -relief solid -border 1
  $w.bar create rectangle 0 0 0 0 -fill $::progcolor -outline $::progcolor -tags bar
  $w.bar create text 295 10 -anchor e -font font_Regular -tags time \
      -fill black -text "0:00 / 0:00"

  pack $w.text $w.b -side top -pady 2
  pack $w.bar -side bottom
  pack $w.b.go $w.b.cancel -side left -padx 10 -pady 10
  placeWinOverParent $w $parent
  wm state $w normal
  grab $w
  bind $w <Return> "$w.b.go invoke"
  bind $w <Escape> "$w.b.cancel invoke"
  focus $w.b.go
}
