{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ah_comp;

{$warn 5023 off : no warning about unused units}
interface

uses
  moon_aux, ah_math, moon_elp, vsop, moon, mooncomp, ah_ide, moon_reg, 
  ah_tool, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('moon_reg', @moon_reg.Register);
end;

initialization
  RegisterPackage('ah_comp', @Register);
end.
