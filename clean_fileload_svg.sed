#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-

\!^\s*<defs>!{
  N
  s~^(\s*<defs>\n\s*<g)>~\1 id="defs-group">~
}
\!^\s*</defs>!{
  a <rect x="0" y="0" width="100%" height="100%" style="fill: wheat;" />
}

/^\s*<image /{
  \! width="422" height="263" xlink:href="data:image\/png;!d  # vrn logo
}

# make sure id attr is first attr:
/ id="/s~^(\s*<[a-z]+)( [^<>]+)( id="[^A-Za-z0-9-]+")~\1\3\2~

\!^\s*<g style="fill:rgb!{
  N
  s~^(<g)( [^<>]+>\n\s*<use [^<>]+ x="([0-9.]+)" y="([0-9.]+)"|$\
    )~\1 id="yx-y\4-x\3"\2~
}

/^\s*<path style=/{
  s~^(\s*<path)( style="[^<>"]*")( d="M (-?[0-9.]+) (-?[0-9.]+) |$\
    )~\1 id="yx-y\5-x\4"\2\n \3~
}

/^<[a-z]+ id="/{
  s!(<[a-z]+ id="[a-z0-9-]*)\.!\1-!g    # x
  s!(<[a-z]+ id="[a-z0-9-]*)\.!\1-!g    # y
  s~^(<g id=)"(yx-y60-[x0-9-]+)"~\1"page-title-\2" opacity="0"~
  s~^(<g id=)"yx-y472-0937-x568"~\1"map-data-source" opacity="0"~
  s~^(<g id=)"yx-y472-0937-x577"~\1"map-copyright" opacity="0"~
  s~^(<g id=)"yx-y812-x36"~\1"map-date-time" opacity="0"~
  s~^(<g id=)"(yx-y8[0-9]{2}-x[0-9-]+)"~\1"footer-\2" opacity="0"~
  s~^(<path id=)"(yx-y-395-[x0-9-]+)"~\1"map-scale-bar-\2" opacity="0"~
  s~^(<g id=)"(yx-y491-[x0-9-]+)"~\1"map-scale-text-\2" opacity="0"~
  s~^(<([a-z]+) id=)"(yx-y5[0-1][0-9]-[x0-9-]+)"~\1"map-lgnd-ln1-\2-\3"~
  s~^(<([a-z]+) id=)"(yx-y5[2][0-9]-[x0-9-]+)"~\1"map-lgnd-ln2-\2-\3"~
  s~^(<path id=)"(yx-y3[2-3][0-9]-[0-9-]*-x36)"~\1"map-lgnd-way-\2"~
  # s~^<[a-z]+ id="map-lgnd-[a-z0-9-]+"~& opacity="0"~
}




















# scroll
