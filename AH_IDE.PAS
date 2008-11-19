(*$ifndef clx *)
unit ah_ide;
(*$endif *)
{ Copyright 1997 Andreas Hörstemeier               Version 1.0 of 1998-05-13 }
{ this file is public domain - please check the file readme.txt for          }
{ more detailed info on usage and distributing                               }

 {$i ah_def.inc }
(*@/// interface *)
interface

(*@/// uses *)
uses
  classes,
(*$ifdef clx *)
  qgraphics,
  qcontrols,
  qextctrls,
(*$else *)
(*$ifndef delphi_1 *)
  windows,
(*$else *)
  winprocs,
  wintypes,
(*$endif *)
  messages,
  graphics,
  controls,
  extctrls,
(*$endif *)
(*$ifdef dsgnintf *)
  dsgnintf,
(*$else *)
  designintf,
  DesignEditors,
(*$endif *)
  sysutils;
(*@\\\*)

type
  (*@/// t_ah_datetimeproperty=class(TFloatProperty) *)
  t_ah_datetimeproperty=class(TFloatProperty)
  protected
    function parsespecialvalue(const s:string; var return:TDateTime):boolean;
  public
    procedure Edit; override;
    function GetAttributes:TPropertyAttributes; override;
    function GetValue:string; override;
    procedure GetValues(Proc:TGetStrProc); override;
    procedure SetValue(const value:string); override;
    procedure Initialize; override;
    function AllEqual:boolean; override;
    end;
  (*@\\\*)
(*@\\\0000000301*)
(*@/// implementation *)
implementation

type
  T_Specialdates=(sd_Now,sd_Midnight,sd_Midday,sd_Tomorrow,sd_Yesterday);
const
  specialvalues: array[sd_Now..sd_Yesterday] of string =
    ( 'Now', 'Midnight', 'Midday', 'Tomorrow', 'Yesterday');
(*@/// class t_ah_datetimeproperty(TFloatProperty) *)
(*@/// procedure t_ah_datetimeproperty.edit; *)
procedure t_ah_datetimeproperty.Edit;
begin
  end;
(*@\\\0000000301*)
(*@/// function t_ah_datetimeproperty.getattributes:TPropertyAttributes; *)
function t_ah_datetimeproperty.GetAttributes:TPropertyAttributes;
begin
  result:=[paMultiSelect,paValueList,paSortlist];
  end;
(*@\\\0000000301*)
(*@/// function t_ah_datetimeproperty.GetValue:string; *)
function t_ah_datetimeproperty.GetValue:string;
begin
  result:=DateTimeToStr(GetFloatValue);
  end;
(*@\\\0000000301*)
(*@/// procedure t_ah_datetimeproperty.GetValues(Proc:TGetStrProc); *)
procedure t_ah_datetimeproperty.GetValues(Proc:TGetStrProc);
var
  i: T_Specialdates;
begin
  for i:=low(specialvalues) to high(specialvalues) do
    proc(specialvalues[i]);
  end;
(*@\\\0000000501*)
(*@/// function t_ah_datetimeproperty.parsespecialvalue(const s:string;...):boolean; *)
function t_ah_datetimeproperty.parsespecialvalue(const s:string; var return:TDateTime):boolean;
var
  i: T_Specialdates;
begin
  result:=false;
  for i:=low(specialvalues) to high(specialvalues) do
    if lowercase(s)=lowercase(specialvalues[i]) then begin
      result:=true;
      case i of
        sd_Now:       return:=now;
        sd_Midnight:  return:=trunc(now);
        sd_Midday:    return:=trunc(now)+0.5;
        sd_Tomorrow:  return:=now+1.0;
        sd_Yesterday: return:=now-1.0;
        end;
      BREAK;
      end;
  end;
(*@\\\0000000730*)
(*@/// procedure t_ah_datetimeproperty.SetValue(const value:string); *)
procedure t_ah_datetimeproperty.SetValue(const value:string);
var
  dt: TdateTime;
begin
  if not parsespecialvalue(value,dt) then
    dt:=StrToDateTime(value);
  SetFloatValue(dt);
  end;
(*@\\\0000000505*)
(*@/// procedure t_ah_datetimeproperty.Initialize; *)
procedure t_ah_datetimeproperty.Initialize;
begin
  inherited Initialize;
(*$ifdef delphi_1 *)
  GetFormatSettings;   { The Delphi 1 VCL isn't prepared for changing locale }
                       { settings, so this makes an update everytime the     }
                       {  editor pops up                                     }
(*$endif *)
  end;
(*@\\\0000000703*)
(*@/// function t_ah_datetimeproperty.AllEqual:boolean; *)
function t_ah_datetimeproperty.AllEqual:boolean;
var
  i: integer;
  dt: TdateTime;
begin
  result:=true;
  dt:=getfloatvalue;
  for i:=0 to propcount-1 do
    if dt<>getfloatvalueat(i) then begin
      result:=false;
      BREAK;
      end;
  end;
(*@\\\0000000901*)
(*@\\\*)
(*@\\\*)
(*$ifdef support_warnings *) (*$warnings off *) (*$endif *)
end.
(*@\\\003F000C05000C05000B01000B3C000C05000011000C05*)
