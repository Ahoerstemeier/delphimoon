unit mtStrings;

{$ifdef fpc}
 {$mode objfpc}{$H+}
{$endif}

interface

uses
  Classes, SysUtils;

{$ifndef fpc}
const
  LINEENDING = #13#10;
{$endif}

resourcestring
  SMoontool = 'Moontool';
  SJuliandate = 'Julian date:';
  SUTC = 'Universal time:';
  SLocalTime = 'Local time:';
  SAgeOfMoon = 'Age of the moon:';
  SMoonPhase = 'Moon phase:';
  SMoonSize = 'Moon subtends:';
  SMoonDistance = 'Moon''s distance:';
  SSunDistance = 'Sun''s distance:';
  SSunSize = 'Sun subtends:';
  SLastNewMoon = 'Last new moon:';
  SFirstQuarter = 'First quarter:';
  SFullMoon = 'Full moon:';
  SLastQuarter = 'Last quarter:';
  SNextNewMoon = 'Next new moon:';
  SLunation = 'Lunation:';
  SMenuFile = '&File';
  SMinimizeTray = 'Minimize to Tray';
  SMenuExit = 'E&xit';
  SMenuEdit = '&Edit';
  SMenuCopy = '&Copy';
  SMenuOptions = '&Options';
  SMenuLanguage = '&Language';
  SMenuSpeed = '&Speed';
  SMenuNormalSpeed = '&Normal';
  SMenuFast = '&Fast';
  SMenuVeryFast = '&Very fast';
  SMenuStop = '&Stop';
  SMenuRun = '&Run';
  SMenuJulian = '&Julian date...';
  SSetJulian = 'Set Julian date';
  SMenuUTC = '&Universal time...';
  SSetUtc = 'Set Universal time';
  SMenuJewish = 'Je&wish date...';
  SJewishDate = 'Jewish date';
  SMenuRotate = '&Rotate moon';
  SMenuRotateNorth = '&Northern hemisphere';
  SMenuRotateSouth = '&Southern hemisphere';
  SMenuColorMoon = '&Colorize moon';
  SMenuLocation = '&Locations...';
  SEditLocation = 'Edit locations';
  SMenuEclipses = 'E&clipses...';
  SMenuMore = '&More data...';
  SMenuHelp = '&Help';
  SMenuAbout = '&About...';
  SMenuHelpItem = 'Help';
  SMenuTimeZones = 'Time zones...';
  SMoreData = 'More data';
  SLocation = 'Location:';
  SLatitude = 'Latitude:';
  SLongitude = 'Longitude:';
  SAltitude = 'Altitude:';
  SSpring = 'March equinox:';
  SSummer = 'June solstice:';
  SAutumn = 'September equinox:';
  SWinter = 'December solstice:';
  SSpringHint = 'Begin of spring';
  SSommerHint = 'Begin of sommer';
  SAutumnHint = 'Begin of autumn';
  SWinterHint = 'Begin of winter';
  SSunRise = 'Sun rise:';
  SSunTransit = 'Sun transit:';
  SSunSet = 'Sun set:';
  SMoonRise = 'Moon rise:';
  SMoonTransit = 'Moon transit:';
  SMoonSet = 'Moon set:';
  SPerigee = 'Next perigee:';
  SApogee = 'Next apogee:';
  SPerihel = 'Next perihelion:';
  SAphel = 'Next aphelion:';
  SMoonEclipse = 'Next moon eclipse:';
  SSunEclipse = 'Next sun eclipse:';
  SNow = '&Now';
  SInvalid = 'Invalid';
  SOutOfRange = 'Out of algorithm range';
  SYear = 'Year';
  SMonth = 'Month';
  SDay = 'Day';
  SHour = 'Hour';
  SMinute = 'Minute';
  SSecond = 'Second';
  SNewLocation = 'New location';
  SMoveUp = 'Move up';
  SMoveDown = 'Move down';
  SDelete = 'Delete';
  SEasterDate = 'Easter date:';
  SPesachDate = 'Passover date:';
  SChristianDate = 'Christian date';
  SChineseNewYear = 'Chinese New Year:';
  SEast = 'East';
  SWest = 'West';
  SNorth = 'North';
  SSouth = 'South';
  SLongitudeHint = 'Positive numbers are western longitude';
  SLatitudeHint = 'Positive numbers are northern latitude';
  SAltitudeHint = 'Altitude in meters above sea level';
  SKilometers = 'km';
  SEarthRadii = 'earth radii';
  SAstronomicalUnits = 'astronomical units';
  SPhaseHint = '(0% = New, 100% = Full)';
  SAgeOfMoonValue = '%0:d days, %1:d hours, %2:d minutes';
  SAboutBox = 'About Moontool';
  SMoontoolAbout = 'Moontool for Windows';
  SBasedUpon = 'based upon the program' + LineEnding + 'by John Walker';
  SEclipseNone = 'None';
  SEclipseTotal = 'Total';
  SEclipsePartial = 'Partial';
  SEclipseHalfshadow = 'Penumbral';
  SEclipseCircular = 'Annular';
  SEclipseCircularTotal = 'Annular-total';
  SEclipseNonCentral = 'Not central';
  SZodiac = 'Zodiac';
  SChineseZodiacRat = 'Rat';
  SChineseZodiacOx = 'Ox';
  SChineseZodiacTiger = 'Tiger';
  SChineseZodiacRabbit = 'Rabbit';
  SChineseZodiacDragon = 'Dragon';
  SChineseZodiacSnake = 'Snake';
  SChineseZodiacHorse = 'Horse';
  SChineseZodiacGoat = 'Goat';
  SChineseZodiacMonkey = 'Monkey';
  SChineseZodiacChicken = 'Chicken';
  SChineseZodiacDog = 'Dog';
  SChineseZodiacPig = 'Pig';

  SMoonNameWolf = 'Wolf Moon';
  SMoonNameSnow = 'Snow Moon';
  SMoonNameWorm = 'Worm Moon';
  SMoonNamePink = 'Pink Moon';
  SMoonNameFlower = 'Flower Moon';
  SMoonNameStrawberry = 'Strawberry Moon';
  SMoonNameBuck = 'Buck Moon';
  SMoonNameSturgeon ='Sturgeon Moon';
  SMoonNameHarvest ='Harvest Moon';
  SMoonNameHunter = 'Hunter Moon';
  SMoonNameBeaver = 'Beaver Moon';
  SMoonNameCold = 'Cold Moon';
  SMoonNameBlue = 'Blue Moon';
  SEasterDateOrthodox = 'Orthodox Easter date:';
//  SSaros = '#%3% of Saros cycle %1%, Inex cycle %2%';
  SSaros = '#%2:d of Saros cycle %0:d, Inex cycle %1:d';
  SSun = 'Sun';
  SMoon = 'Moon';
  SCalendar = 'Calendar';
  SRektaszension = 'Rektaszension:';
  SDeclination = 'Declination:';
  SAries = 'Aries';
  STaurus = 'Taurus';
  SGemini = 'Gemini';
  SCancer = 'Cancer';
  SLeo = 'Leo';
  SVirgo = 'Virgo';
  SLibra = 'Libra';
  SScorpio = 'Scorpio';
  SSagittarius = 'Sagittarius';
  SCapricorn = 'Capricorn';
  SAquarius = 'Aquarius';
  SPisces = 'Pisces';

  SDegreeAbbrev = 'deg';
  SMinAbbrev = 'min';
  SSecAbbrev = 'sec';

  SOKButton = 'OK';
  SCancelButton = 'Cancel';

  SDateTime = 'Date/time';
  SEclipseType = 'Eclipse type';
  SSolarAndLunarEclipses = 'Solar and lunar eclipses';
  SSolarEclipses = 'Solar eclipses';
  SLunarEclipses = 'Lunar eclipses';
  SSearch = 'Search';
  SFrom = 'From:';
  STo = 'To:';

implementation

end.

