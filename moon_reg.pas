(*$ifndef clx *)
unit moon_reg;
(*$endif *)
  (*$i ah_def.inc *)
(*@/// interface *)
interface

uses
  classes,
  (*$ifdef dsgnintf *)
  dsgnintf,
  (*$else *)
  designintf,
  (*$endif *)
  moonres,
  (*$ifdef clx *)
  qmooncom,
  qah_ide;
  (*$else *)
  mooncomp,
  ah_ide;
  (*$endif *)

procedure Register;
(*@\\\000C000801000901000501*)
(*@/// implementation *)
implementation

procedure Register;
(*$ifndef delphi_5 *)  { were predefined in Delphi 5 only }
const
  TInputCategory = 'Input';
  TVisualCategory = 'Visual';
  TMiscellaneousCategory = 'Miscellaneous';
(*$endif *)
begin
  RegisterPropertyEditor(TypeInfo(TDateTime),NIL,'',t_ah_datetimeproperty);
  RegisterComponents('Custom', [TMoon]);
(*$ifdef propertycategory *)
  RegisterPropertiesInCategory(TInputCategory, TMoon,
    ['Date']);
  RegisterPropertiesInCategory(TVisualCategory, TMoon,
    ['MoonStyle','MoonSize','Rotation']);
  RegisterPropertiesInCategory(TMiscellaneousCategory, TMoon,
    ['ShowApollo11']);
(*$endif *)
  end;
(*@\\\0000000D1D*)
(*$ifdef support_warnings *) (*$warnings off *) (*$endif *)
end.
(*@\\\003100071A00071A000011*)
