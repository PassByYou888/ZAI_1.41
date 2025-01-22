(*
https://zpascal.net
https://github.com/PassByYou888/ZNet
https://github.com/PassByYou888/zRasterization
https://github.com/PassByYou888/ZSnappy
https://github.com/PassByYou888/Z-AI1.4
https://github.com/PassByYou888/InfiniteIoT
https://github.com/PassByYou888/zMonitor_3rd_Core
https://github.com/PassByYou888/tcmalloc4p
https://github.com/PassByYou888/jemalloc4p
https://github.com/PassByYou888/zCloud
https://github.com/PassByYou888/ZServer4D
https://github.com/PassByYou888/zShell
https://github.com/PassByYou888/ZDB2.0
https://github.com/PassByYou888/zGameWare
https://github.com/PassByYou888/CoreCipher
https://github.com/PassByYou888/zChinese
https://github.com/PassByYou888/zSound
https://github.com/PassByYou888/zExpression
https://github.com/PassByYou888/ZInstaller2.0
https://github.com/PassByYou888/zAI
https://github.com/PassByYou888/NetFileService
https://github.com/PassByYou888/zAnalysis
https://github.com/PassByYou888/PascalString
https://github.com/PassByYou888/zInstaller
https://github.com/PassByYou888/zTranslate
https://github.com/PassByYou888/zVision
https://github.com/PassByYou888/FFMPEG-Header
*)
{ ****************************************************************************** }
{ * FMX canvas Character to Ratermization                                      * }
{ ****************************************************************************** }
unit PasAI.DrawEngine.FMXCharacterMapBuilder;

{$I ..\PasAI.Define.inc}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics,

  PasAI.Core, PasAI.ListEngine,
  PasAI.ZDB.ObjectData_LIB, PasAI.ZDB, PasAI.ZDB.ItemStream_LIB, PasAI.Expression,
  PasAI.MemoryStream, PasAI.MemoryRaster, PasAI.Geometry2D, PasAI.PascalStrings, PasAI.UPascalStrings,
  PasAI.UnicodeMixedLib, PasAI.DrawEngine, PasAI.DrawEngine.SlowFMX;

function BuildFMXCharacterAsFontRaster(AA_: Boolean; fontName_: TUPascalString; fontSize_: Single; Bold_, Italic_: Boolean; InputBuff: TUArrayChar): TFontPasAI_Raster;

implementation

type
  TFMXFontToRasterFactory = class(TCore_Object_Intermediate)
  protected
    bmp: FMX.Graphics.TBitmap;
    dIntf: TDrawEngineInterface_FMX;
    d: TDrawEngine;
    fontSize: Integer;
  public
    constructor Create(fontName_: string; fontSize_: Integer; Bold_, Italic_: Boolean);
    destructor Destroy; override;
    function MakeCharRaster(C: string; var MinRect_: TRect): TMPasAI_Raster;
  end;

constructor TFMXFontToRasterFactory.Create(fontName_: string; fontSize_: Integer; Bold_, Italic_: Boolean);
begin
  inherited Create;
  fontSize := fontSize_;

  bmp := FMX.Graphics.TBitmap.Create;
  bmp.SetSize(fontSize_ * 2, fontSize_ * 2);

  bmp.Canvas.Font.Family := fontName_;
  bmp.Canvas.Font.Size := fontSize_;
  if Bold_ then
      bmp.Canvas.Font.Style := bmp.Canvas.Font.Style + [TFontStyle.fsBold]
  else
      bmp.Canvas.Font.Style := bmp.Canvas.Font.Style - [TFontStyle.fsBold];

  if Italic_ then
      bmp.Canvas.Font.Style := bmp.Canvas.Font.Style + [TFontStyle.fsItalic]
  else
      bmp.Canvas.Font.Style := bmp.Canvas.Font.Style - [TFontStyle.fsItalic];

  dIntf := TDrawEngineInterface_FMX.Create;
  dIntf.SetSurface(bmp.Canvas, bmp);
  d := TDrawEngine.Create;
  d.DrawInterface := dIntf;
  d.ViewOptions := [];
  d.SetSize;
end;

destructor TFMXFontToRasterFactory.Destroy;
begin
  disposeObject(d);
  disposeObject(dIntf);
  disposeObject(bmp);
  inherited Destroy;
end;

function TFMXFontToRasterFactory.MakeCharRaster(C: string; var MinRect_: TRect): TMPasAI_Raster;
var
  r4: TV2Rect4;
  raster: TMPasAI_Raster;
begin
  d.FillBox(d.ScreenRect, DEColor(0, 0, 0));
  d.Flush;
  r4 := d.DrawText(C, fontSize, d.ScreenRect, DEColor(1, 1, 1), True);
  d.Flush;
  raster := TMPasAI_Raster.Create;
  BitmapToMemoryBitmap(bmp, raster);
  MinRect_ := Rect2Rect(r4.BoundRect);
  Result := raster;
end;

function BuildFMXCharacterAsFontRaster(AA_: Boolean; fontName_: TUPascalString; fontSize_: Single; Bold_, Italic_: Boolean; InputBuff: TUArrayChar): TFontPasAI_Raster;
var
  BmpFactory: TFMXFontToRasterFactory;
  fr: TFontPasAI_Raster;
  i: Integer;
  C: USystemChar;
  tmp, raster: TMPasAI_Raster;
  R: TRect;
begin
  BmpFactory := TFMXFontToRasterFactory.Create(fontName_, round(if_(AA_, fontSize_ * 4, fontSize_)), Bold_, Italic_);
  fr := TFontPasAI_Raster.Create;

  for i := 0 to length(InputBuff) - 1 do
    begin
      C := InputBuff[i];
      tmp := BmpFactory.MakeCharRaster(InputBuff[i], R);
      if AA_ then
        begin
          Antialias32(tmp);
          tmp.Scale(1 / 4);
          R := Rect2Rect(RectMul(RectV2(R), 1 / 4));
          R := CalibrationRectInRect(R, tmp.BoundsRect0);
        end;
      raster := NewPasAI_Raster();
      raster.SetSize(R.Width, R.Height, RColorF(0, 0, 0));
      tmp.DrawTo(raster, 0, 0, R);

      fr.Add(C, raster);

      disposeObject(tmp);
    end;
  disposeObject(BmpFactory);
  Result := fr;
end;

end.
