TMoon  (Version 1.0 of 1997-04-03)

This is a collection of some functions to calculate the phases of the moon and
some connected data. To make this a nice Delphi component there's also a
TImage descendent which shows the phase of the moon at a given date.

There are two properties for this component:

MoonSize    the size of the bitmap, either 32x32 (ms32) or 64x64 (ms64)
Date        the date which should be used for calculation. It is set to now on
            the creation of the component.

There are also quite a lot of functions to give real numbers instead of just
an image:

julian_date(date)       Convert the Delphi-Date into the julian date used for
                        many astronomical algorithms

sun_distance(date)      The distance of the sun in Astronomical Units
moon_distance(date)     The distance of the moon to the center of the Earth in
                        kilometres.
age_of_moon(date)       The position of terminator on the moon measured in
                        parts of the synodical month instead of degrees

last_phase(date,phase)  Calculate the last phase of the given kind prior to
                        the date
next_phase(date,phase)  Guess what :-)

current_phase(date)     The illuminated part of the moon (1=Full Moon, 0=New
                        Moon, 0.5=First/Last Quarter)
lunation(date)          The number of the new moon since 1.1.1923

sun_diameter(date)      The diameter of the sun in arc seconds
moon_diameter(date)     The diameter of the moon (as seen from the center of
                        the earth) in arc seconds.

All algorithms are taken from the book "Astronomical Algorithms" by Jean Meeus
(or to be correct "Astronomische Algorithmen", the German edition). I've noted
the chapters which were used for the specific functions. I still have some
problems to reproduce the distance given as an example in Meeus in Chapter 45
(The position of the moon), so if you have the English edition it'd be nice if
you could check wether all formulas are correct - I already found one error in
the German edition in this chapter.

If you don't need the component and just want to use the functions (e.g. for a
command line version) you can remove the (*$define component*) in the header.

The component can be used with both Delphi 16 and 32, but as the Resource
files are different you have to use the moon.res and moon.dcr in the 16 or 32
subdirectory.

As a demo application there's a moontool clone in the demo subdirectory, but
this one is 32bits only. The original Moontool program by John Walker can be
found e.g. at "http://www.fourmilab.ch/moontoolw". Some values displayed are
different due to the different set of algorithms used, and some few features
are not yet implemented - especially the modifying of the applications icon
(which doesn't work in the original Moontool on NT4 anyway).


If you spot any bug, have any idea how to improve, want to let me know what a
great job I did :-), want to notify me of the use any part of this component
for your own one, want to hear from me when I throw something into the public,
or for any other reason, you can mail me:

ah@scp.de
andy@farpoint.westend.de
http://www.westend.de/~hoerstemeier
snail mail: Andreas H"orstemeier
            Mefferdatisstrasse 16-18
            52062 Aachen
            Germany

["o means the umlaut o, that is an o with two dots above]


This component is Public Domain, but if you want to send me money I won't
complain :-) You are free to put this component on a CD-ROM, but if you do
so please send me a copy. And of course only spread this component
complete with all the readme's and sources.


Andreas H"orstemeier
