
vrn-fileload-clean
==================

Consume less paper when printing maps for your travel with the
[Verkehrsverbund Rhein-Neckar][trip-rq].

  [trip-rq]: http://fahrplanauskunft.vrn.de/vrn/XSLT_TRIP_REQUEST2


Motivation
----------

Verkehrsverbund Rhein-Neckar is my local public transport provider.
Their route planner has a neat function "Umgebungskarte" (site plan)
which shows me the footpaths to and from stops, and I often take
their maps with me as either digital image or printed on paper.
The original map service has some drawbacks, though:

  * VRN delivers the maps as PDF, and my favorite PDF viewer program
    doesn't integrate conveniently with my favorite web browser.
  * Their map PDF wastes paper and toner for stuff that I'm usually not
    interested in:
    * server status info and page number at bottom of page,
    * the VRN logo,
    * a headline stating start and end of the footpath shown,
    * map scale info, description of map symbols,
    * step-by-step directions as text: useful in planning because it shows
      the distances, but once I've decided a route I don't need them.
  * For non-trivial routes, I like to arrange multiple parts of the route
    onto one image or page, cropping the maps to just the tricky parts.
    * Easy in LibreOffice Draw once I converted each PDF to PNG,
      a step no longer required now.
    * In theory, printing directly from my web browser should now only
      cover half a page, so I can just feed it into my printer again and
      have a second map printed on the other half.



Install
-------

  * Prepare some PHP-capable webspace.
  * Clone the repo into that webspace.
  * In that cloned repo dir, make a folder `tmp` and adjust its access
    permissions so that `dl.php` invoked by the webserver, and programs
    it calls, can write there.
  * Configure your browser, proxy or network to redirect some URLs:
    If they start with http://fahrplanauskunft.vrn.de/vrn/FILELOAD?Filename= ,
    replace that part with http://your-server.local/web/space/dl.php?bfn= .
  * [Plan a route][trip-rq], click "Route anzeigen".
  * If you're lucky, you're being redirected to an image file already.
  * If you see an error message instead, you probably need to install some
    programs, probably for PDF-to-image conversion.
    Use your usual admin skills to fix it.




License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
