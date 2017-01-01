#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-

/<svg xmlns=/{
  s~ (width|height|x|y)="[0-9]+[a-z]*"~~g
  s~ ([A-Za-z-]+=)~\n  \1~g
  s~(\s+)(viewBox)~\1x="0px" y="0px"\1\
    width="1200px" height="1500px"\
    viewBox="0 0 525 656.25"\
    orig-\2~
  # orig-viewBox="0 0 595 842"
  # map scaled to full width on original page size: viewBox="0 0 523 740.111"
  # original page size aspect ratio: 842 / 595 ~= 1.41512605
  # for comparison:                    sqrt(2) ~= 1.414213562
  # custom image size: 523 is prime, so let's add a margin of 1.
  # --> viewBox="0 0 525 743" --> scale to: w=1200px: h=1698px
  # --> round to width="1200px" height="1500px" (H/W = 1.25):
  # --> viewBox="0 0 525 656.25"
}

\!^\s*<defs>!{
  N
  s~^(\s*<defs>\n\s*<g)>~\1 id="defs-group">~
}
\!^\s*</defs>!{
  s~$~\n<rect x="0" y="0" width="100%" height="100%"\
    style="fill: white;" />~
  N
  # map position in SVG coordinates: ca. [36, 80.2]
  # (ref: clipPath#clip3), cf. rect#map-area-border below
  # move map top left: translate(-36 -80.2)
  # add margin of 1: translate(-35 -79.2)
  s~(\n<g\b[^<>]*)>~\1 transform="translate(-35 -79.2)">~
}

/^\s*<image /{
  \! width="422" height="263" xlink:href="data:image\/png;!d  # vrn logo
}

# make sure id attr is first attr:
/ id="/s~^(\s*<[a-z]+)( [^<>]+)( id="[^A-Za-z0-9-]+")~\1\3\2~

/^\s*<g style="fill:rgb/{
  N
  s~^(<g)( [^<>]+>\n\s*<use [^<>]+ x="([0-9.]+)" y="([0-9.]+)"|$\
    )~\1 id="yx-y\4-x\3"\2~
}

/^\s*<g clip-path=/{
  s~^(<g)( clip-path="url\(#([A-Za-z0-9-]+)\)")~\1 id="clip-path-url-\3"\2~
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


/^<g id="map-date-time" /{
  s~^~\
    <rect id="map-area-border" stroke="magenta" stroke-width="0.5" \
      fill="none" opacity="0" >\
    <rect id="map-area-fade" fill="white" opacity="0"\
      >\n~
  s~  (<rect id="map-area-[^<>]*)>|$\
    ~\1x="36" y="80.2" width="523" height="391.9" />~g
}

















# scroll
