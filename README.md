NYCattends: NYCDOE attendance archive
-------------------------------------

The NYCDOE [publishes](http://bit.ly/NYCattendsNow) a daily attendance report, but it doesn't seem possible to access historical reports, so I'm downloading them every day and putting them up here.

These are exactly the DOE's XML documents, renamed to include the date. They're exactly what you'd get if you downloaded from this address after four o'clock on the day of interest:

    http://schools.nyc.gov/AboutUs/schools/data/attendancexml/

(Previously the URL was `http://schools.nyc.gov/aboutus/data/attendancexml/` and as of 2014-10-21 the link from the DOE page was incorrect.)

The DOE's [site](http://bit.ly/NYCattendsNow) gives the following disclaimer:

> Attendance figures for [today's date] are accurate as of 4:00pm, but are not final as schools continue to submit data after we generate this preliminary report.

> NOTE: Schools that have not yet submitted attendance information are listed as "NS" in the below table and XML download. The same field is listed as "-1" in the Excel download.

---

This twitter account is not affiliated with DOE either: [@NYCattends](https://twitter.com/NYCattends)

---

The XML from NYCDOE contains ASCII decimal 26 characters, the "[synchronous idle](http://en.wikipedia.org/wiki/Synchronous_idle)" character. You probably want to go ahead and take those out before parsing.
