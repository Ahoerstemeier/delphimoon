TMoon  (Version 1.2 of 1997-12-07)

This is a collection of some functions to calculate the phases of the moon and
some connected data. To make this a nice Delphi component there's also a
TImage descendent which shows the phase of the moon at a given date.

There are three properties for this component:

MoonSize    the size of the bitmap, either 16x16 (ms16), 32x32 (ms32) or
            64x64 (ms64)
Date        the date which should be used for calculation. It is set to now on
            the creation of the component.
Icon        read only: generates a Icon with the current phase in the systems
            standard size (if this is not in the size also supported by
            MoonSize a NIL pointer will be returned!)

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
nextperigee(date)       The next perigee of the moon after the date given
nextapogee(date)        The next apogee of the moon after the date given

nexteclipse(date,sun)   The type of the eclipse next to the date given - either
                        none or total. If sun=false (means moon) there's
                        halfshadow, too, for sun=true there's also partial,
                        circular, noncentral, circulartotal. If there's a
                        eclipse the datetime of the maximum of the eclipse is
                        returned.

startseason(year,season)  The date of the start of the season, maximum error
                          51 seconds, only valid for years -1000...+3000.
Sun_Rise(date,latitude,longitude)
Sun_Transit, Sun_Set, Moon_Rise, Moon_Transit, Moon_Set
                        The time the sun/moon rises/gets highest elevation/sets
                        on the date given. Error is within a few minutes. If
                        the object is circumpolar (no rise/set during the day
                        requested) an exception E_NoRiseSet is raised.


All algorithms are taken from the book "Astronomical Algorithms" by Jean Meeus
(or to be correct "Astronomische Algorithmen", the German edition). I've noted
the chapters which were used for the specific functions, so you can check for
further information on the algorthms used easily. I still have some
problems to reproduce the distance given as an example in Meeus in Chapter 45
(The position of the moon), so if you have the English edition it'd be nice if
you could check wether all formulas are correct - I already found one error in
the German edition in this chapter.

If you don't need the component and just want to use the functions (e.g. for a
command line version or if you want to use it in a pre-Delphi Borland Pascal)
you can remove the (*$define component*) in the header.

The component can be used with all versions of Delphi and probably the C++
Builder, too, but as the Resource files are different you have to
use the moon.res and moon.dcr in the 16 (for D1) or 32 (for D2 and D3)
subdirectory. If you have the D2 or D3 standard version you don't have the
math unit - in this case set the nomath compiler directive.

As a demo application there's a moontool clone in the demo subdirectory;
both compilable as a 16 or 32 bit application - just move the moontool.res out
of 16/32 subdirectory in the demo directory. As for the conversion from system
date to GMT there's a windows 32bit API routine, in case of the 16 bit program
(but only in Win3.11 or earlier) you have to set the environment variable TZ.

The original Moontool program by John Walker can be found e.g. at
"http://www.fourmilab.ch/moontoolw". Some values displayed are different due
to the different set of algorithms used, and some few features are not yet
implemented, and there are some features I added which the original doesn't
have.


If you spot any bug (which isn't mentioned on my bug list at
http://www.westend.de/~hoerstemeier/bug.htm) , have any idea how to improve
this component, want to let me know what a great job I did :-), want to
notify me of the use of any part of this component for your own one, or for
any other reason, you can mail me:


ah@scp.de
andy@farpoint.westend.de
http://www.westend.de/~hoerstemeier
snail mail: Andreas H"orstemeier
            Mefferdatisstrasse 16-18
            52062 Aachen
            Germany

["o means the umlaut o, that is an o with two dots above]


If you want to complain about anything regarding my components please keep in
mind: I did them in my spare time for fun only, and putting them out for free
is just because of my good will, so keep friendly.

If you want to ask Delphi questions not directly related to my components
please consider asking them in one of the several Newsgroups - answering
email eats quite a lot of my time, and maybe others do know more about your
problem. As I read many of the newsgroups myself you may even get an answer
by me...

If you want to get a notification once I release a new component or a new
version of an existing one you can subscribe to my announce mailing list,
just send an email with subject "subscribe" to "ah-delphi-request@scp.de".
Note this is not for discussion.

This component is Public Domain. If you like it you can send me a thank you
on a nice postcard from your hometown, but if you really want to send me
money I won't complain :-) , but count it as a gift not a payment.
You are free to put this component on a CD-ROM, but if you do so please send
me a copy. And of course only spread this component complete with all the
readme's and sources.


Have fun,
   Andreas H"orstemeier
