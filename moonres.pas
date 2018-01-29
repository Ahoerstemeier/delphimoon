unit moonres;
 {$i ah_def.inc }
 { This is only a auxilary unit to make Delphi load the dcr file
   only once - if this code is in the moon_reg unit it says the
   resource is included twice :-(                                }
interface

{$ifdef fpc}
  {$r moonpng.res}
{$else}
{$ifdef delphi_1}
  {$r moon.d16 }            { The File containing the bitmap }
{$else}
  {$r moon.d32 }            { The File containing the bitmap }
{$endif}
{$endif}
implementation
(*$ifdef support_warnings *) (*$warnings off *) (*$endif *)
end.
(*@\\\003F000E01000E01000E01000E01000501000011000501*)
