�
 TFRM_LOCATIONS 0�  TPF0Tfrm_locationsfrm_locationsLeft� TopkBorderIconsbiSystemMenu BorderStylebsSingleCaption	LocationsClientHeightBClientWidth� Color	clBtnFace
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style ShowHint	OnCreate
FormCreateOnShowFormShowPixelsPerInch`
TextHeight TSpeedButtonbtn_plusLeft� TopWidthHeightCaption+OnClickbtn_plusClick  TSpeedButton	btn_minusLeft� TopWidthHeightCaption-OnClickbtn_minusClick  TSpeedButtonbtn_newLeft� Top0WidthHeightCaption*OnClickbtn_newClick  TLabellbl_longitudeLeftTop� Width2HeightCaption
Longitude:  TLabellbl_latitudeLeftTop� Width)HeightCaption	Latitude:  TSpeedButtonbtn_delLeft� Top@WidthHeightCaptionXOnClickbtn_delClick  TLabellbl_altitudeLeftTopWidth&HeightCaption	Altitude:  TListBoxlbx_locationLeftTopWidth� Height� 
ItemHeightTabOrder OnClicklbx_locationClick  TEditedt_nameLeftTop� Width� HeightTabOrderOnChange	edtChange  TButtonbtn_okLeft`Top(WidthKHeightCaptionOKDefault	ModalResultTabOrderOnClickbtn_okClick  TButton
btn_cancelLeft� Top(WidthKHeightCaptionCancelModalResultTabOrder  	TMaskEditedt_longitudeLeft� Top� WidthIHeightEditMask!###0:#0:#0;1; 	MaxLength
TabOrderText
    :  :  OnChange	edtChangeShowHint	  	TMaskEditedt_latitudeLeft� Top� WidthIHeightEditMask!##0:#0:#0;1; 	MaxLength	TabOrderText	   :  :  OnChange	edtChangeShowHint	  	TMaskEditedt_altitudeLeft� TopWidthIHeightEditMask	!####;1; 	MaxLengthTabOrderText   0OnChange	edtChange  TButton
btn_importLeftTop(WidthKHeightCaptionImportTabOrderVisibleOnClickbtn_importClick  TOpenDialogdlgFilterSTSplus city file|stsplus.ctyOptionsofPathMustExistofFileMustExist LeftXTop�    