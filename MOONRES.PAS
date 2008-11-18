unit moonres;
 {$i ah_def.inc }
 { This is only a auxilary unit to make Delphi load the dcr file
   only once - if this code is in the moon_reg unit it says the
   resource is included twice :-(                                }
interface

(*$ifdef delphi_1 *)
  {$r moon.d16 }            { The File containing the bitmap }
(*$else *)
  {$r moon.d32 }            { The File containing the bitmap }
(*$endif *)
implementation
end.
(*@\\\003F000E01000E01000E01000E01000501000011000501*)
