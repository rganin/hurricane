(************************ Begin of copyright notice ****************************
*          _____________________________________________________               *
*         |  The Hurricane encryption algorithm implementation  |              *
*         |                        v1.0                         |              *
*         |                 (c) by Roman Ganin                  |              *
*         |                        2005                         |              *
*         |                 All rights reserved                 |              *
*         |_____________________________________________________|              *
*                                                                              *
*  The Hurricane implementation unit (further "Implementation") is             *
*  FREE for non-commercial use. Using this Implementation in commercial        *
*  projects is allowed only by the author`s permission. Tha author will not    *
*  take any responsibility for using this Implementation in illegal ways.      *
*  If You have some questions or offers to the author, please contact by email *
*                                gate@ua.fm                                    *
*  Modifying or selling this Implementation is strongly prohibited by the      *
*  author`s rights! You can publish, copy or merge this Implementation         *
*  without any restrictions due to the following conditions: the copyright     *
*  notice and this condition notices shall be included into all copies or      *
*  substantial portions of this Implementation. Distributing the software,     *
*  created using this Implementation is allowed only by including this source  *
*  code and this copyrigth notice into all packages or substantial portions of *
*  the distributed software.                                                   *
*  THIS Implementation IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.      *
*********************** End of copyright notice  ******************************)



unit Hurricane;

interface

uses Classes, SysUtils;

const N=256;
      MinKeyLength=16;
      FileBlockSize=1024;


type
     TIdBytes = {$IFDEF DOTNET} TBytes; {$ELSE} array of Byte; {$ENDIF}
     {Taken from Indy 10 component pack http://www.indyproject.org/}

     TTempArray = class (TObject)
         A: Array[0..n-1,0..n-1] of Word;
         constructor Create;
       end;

     THBox = class(TComponent)
       private
         Key: TIdBytes;
         KeyCS: Byte;
         TMP: TTempArray;
         Matrix: Array[0..n-1,0..n-1] of Byte;
         Matrix_1: Array[0..n-1,0..n-1]of Byte;
         procedure InitMatrix(MakeRandom: Boolean);
         procedure FillRow(MakeRandom: Boolean);
         procedure FillMatrix(MakeRandom: Boolean);
         function FCheckSum(Src: TIdBytes):Byte;
         function ExpandKey(Key: TIdBytes; ByteKeySize: Word; var EKey: TIdBytes): Word;
       public
         Active: Boolean;
         constructor Create(AOwner: TComponent); override;
         Function Init(MakeRandom: Boolean; Check: Boolean; InitKey: TIdBytes; KeySize: Word): Boolean;
         Procedure Encrypt(const Src: TIdBytes; var Dst: TIdBytes);
         Procedure Decrypt(const Src: TIdBytes; var Dst: TIdBytes);
         Function EncryptStream(InStream: TStream; OutStream: TStream; Size: Integer): Integer;
         Function DecryptStream(InStream: TStream; OutStream: TStream; Size: Integer): Integer;
         Procedure SaveMatrix(const FileName: String);
         Procedure InitFromFile(const FileName: String; InitKey: TIdBytes);
       end;

implementation

constructor TTempArray.Create;
begin
  inherited Create;
end;

constructor THBox.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  Active:=False;
end;



function THBox.FCheckSum(Src: TIdBytes):Byte;
var i:Integer;
begin
Result:=0;
for i:=0 to Length(Src)-1 do
  begin
    Result:=(Result+Src[i])mod N;
  end;
end;


Function THBox.Init(MakeRandom: Boolean; Check: Boolean; InitKey:TIdBytes; KeySize: Word): Boolean;
var Size,CheckSum,Sum,i,j:Integer;
    TMP: TIdBytes;
begin

  Size:=ExpandKey(InitKey,KeySize,TMP);
  SetLength(Key,Size);
  Move(TMP[0],Key[0],KeySize);
  KeyCS:=FCheckSum(Key);
  InitMatrix(MakeRandom);
  Active:=True;
  Result:=True;
  if Check=False then Exit;
  CheckSum:=0;
  for i:=0 to n-1 do
    CheckSum:=CheckSum+i;

  for i:=0 to n-1 do
    begin
      sum:=0;
      for j:=0 to n-1 do
        Sum:=Sum+Matrix[i,j];
      if Sum<>CheckSum then
        begin
          Result:=False;
          Exit;
        end;
    end;

  for i:=0 to n-1 do
    begin
      sum:=0;
      for j:=0 to n-1 do
        Sum:=Sum+Matrix[j,i];
      if Sum<>CheckSum then
        begin
          Result:=False;
          Exit;
        end;
    end;
end;


procedure THBox.InitMatrix(MakeRandom: Boolean);
var i,j:Integer;

begin
  TMP:=TTempArray.Create;
  for i:=0 to n-1 do
    for j:=0 to n-1 do
      TMP.A[i,j]:=1024;
  FillRow(MakeRandom);
  FillMatrix(MakeRandom);
  for i:=0 to n-1 do
    for j:=0 to n-1 do
      begin
        Matrix[i,j]:=TMP.A[i,j];
        Matrix_1[Matrix[i,j],j]:=i;
      end;
  TMP.Free;
end;

procedure THBox.FillRow(MakeRandom: Boolean);
var z,x:Byte;
    i,j,ks,m:Integer;
    OK: Boolean;
    label LOOP, KeyLoop;
begin
  if Not MakeRandom then
    begin
      ks:=Length(Key);
      x:=11;
      z:=0;
      m:=0;
      for i:=0 to N-1 do
        begin
          KeyLoop:
          for j:=ks-1  downto m do
            z:=(z+key[j]+x) mod N;
          OK:=True;
          m:=(m+1) mod ks;
          for j:=0 to i do
            if (z=TMP.A[j,0]) then OK:=False;

          if OK then TMP.A[i,0]:=z else
            begin
              x:=x+1;
              GOTO KeyLoop;
            end;
        end;
      Exit;
    end;
  Randomize;
  for i:=0 to n-1 do
    begin
      LOOP:
      OK:=True;
      z:=random(n);
      for j:=0 to i do
        if z = TMP.A[j,0] then OK:=False;
      if OK then TMP.A[i,0]:=z else GOTO Loop;
    end;
end;

procedure THBox.FillMatrix(MakeRandom: Boolean);
var i,j,k,l:Integer;
    x:Integer;
    OK:Boolean;
    LK: Integer;
label LOOP, kloop;
begin
  k:=0;
  x:=0;
  LK:=Length(KEy);
  if MakeRandom then
  for i:=1 to n-1 do
    begin
      k:=k+1 mod n;
      LOOP:
      j:=Random(N-1)+1;
      if TMP.A[0,j]=1024 then OK:=True else Goto LOOP;
      if OK then
        for l:=0 to n-1 do
          TMP.A[l,j]:=TMP.A[(l+k) mod n ,0];
      OK:=False;
    end
  else
    begin
     for i:=1 to n-1 do
       begin
         k:=k+1 mod n;
         kLOOP:
         x:=x+1;
         j:=((Key[(i+37+x) mod LK]+x+KeyCS) mod 255)+1;
         if TMP.A[0,j]=1024 then OK:=True else Goto kLOOP;
         if OK then
           begin
             for l:=0 to n-1 do
               TMP.A[l,j]:=TMP.A[(l+k) mod n ,0];
             OK:=False;
           end;
       end
    end;

end;


function THBox.ExpandKey(Key: TIdBytes; ByteKeySize: Word; var EKey: TIdBytes): Word;
var S,i,x:Integer;
begin
  S:=ByteKeySize;
  If ByteKeySize <= MinKeyLength then S:=MinKeyLength;
  SetLength(EKey,S);
  x:=Length(Key);
  if x=S then
    begin
      Move(Key[0],EKey[0],X);
      Result:=X;
      Exit;
    end;

  for i:=0 to S-1 do
    begin
      EKey[i]:=(Matrix[i mod N, Key[i mod x]] xor  (Key[i mod x] * Key[((i+11) or 31) mod x]+i)) mod 256;
    end;
  Result:=S;

end;


procedure THBox.Encrypt(const Src: TIdBytes; var Dst: TIdBytes);
var i,LSrc:Integer;
begin
  LSrc:=Length(Src);
  if LSrc < 1 then Exit;
  SetLength(DST,LSrc);
  Src[0]:=Matrix[Src[0],KeyCS];
  if Lsrc=1 then
    begin
      Move(Src[0],Dst[0], Lsrc);
      Exit;
    end;
  for i:=1 to Lsrc-1 do
      Src[i]:=Matrix[Src[i],Src[i-1]];
  Src[Lsrc-1]:=Matrix[Src[Lsrc-1],KeyCS xor $55 ];
  for i:=Lsrc-2 downto 0 do
      Src[i]:=Matrix[Src[i],Src[i+1]];
  Move(Src[0],Dst[0], Lsrc);
end;

Procedure THBox.Decrypt(const Src: TIdBytes; var Dst: TIdBytes);
var i,LSrc:Integer;
begin
  LSrc:=Length(Src);
  if LSrc < 1 then Exit;
  SetLength(DST,LSrc);
  Move(Src[0],Dst[0],LSRC);
   if Lsrc=1 then
    begin
      Dst[0]:=Matrix_1[Dst[0],KeyCS];
      Exit;
    end;
   for i:=0 to Lsrc-2 do
       Dst[i]:=Matrix_1[Dst[i],Dst[i+1]];
   Dst[Lsrc-1]:=Matrix_1[Dst[Lsrc-1], KeyCS xor $55];
   for i:=Lsrc-1 downto 1 do
       Dst[i]:=Matrix_1[Dst[i],Dst[i-1]];
   Dst[0]:=Matrix_1[Dst[0],KeyCS];
end;


Procedure THBox.SaveMatrix(const FileName: String);
var F:File Of Byte;
    i,j:Integer;
begin
  AssignFile(F,FileName);
  Rewrite(F);
  for i:=0 to N-1 do
    for j:=0 to N-1 do
      Write(F,Matrix[i,j]);
  CloseFile(F);
end;

Procedure THBox.InitFromFile(const FileName: String; InitKey: TIdBytes);
var F:File Of Byte;
    i,j:Integer;
begin
  AssignFile(F,FileName);
  Reset(F);
  for i:=0 to N-1 do
    for j:=0 to N-1 do
     begin
      Read(F,Matrix[i,j]);
      Matrix_1[Matrix[i,j],j]:=i;
     end;
  CloseFile(F);
  SetLength(Key,Length(INITKey));
  Move(InitKey,Key,Length(InitKey));
  Active:=True;
end;

Function THBox.EncryptStream(InStream: TStream; OutStream: TStream; Size: Integer): Integer;
var
  S,D: TIdBytes;
  i, Read: longword;
begin
  Result:=0;
  for i:= 1 to (Size div FileBlockSize) do
  begin
    SetLength(S,FileBlockSize);
    Read:= InStream.Read(S[0],Length(S));
    SetLength(S,Read);
    Inc(Result,Read);
    Encrypt(S,D);
    OutStream.Write(D[0],Read);
  end;
  if (Size mod FileBlockSize)<> 0 then
  begin
    SetLength(S,FileBlockSize);
    Read:= InStream.Read(S[0],Size mod FileBlockSize);
    Inc(Result,Read);
    SetLength(S,Read);
    Encrypt(S,D);
    OutStream.Write(D[0],Read);
  end;
end;

Function THBox.DecryptStream(InStream: TStream; OutStream: TStream; Size: Integer): Integer;
var
  S,D: TIdBytes;
  i, Read: longword;
begin
  Result:=0;
  for i:= 1 to (Size div FileBlockSize) do
  begin
    SetLength(S,FileBlockSize);
    Read:= InStream.Read(S[0],Length(S));
    SetLength(S,Read);
    Inc(Result,Read);
    Decrypt(S,D);
    OutStream.Write(D[0],Read);
  end;
  if (Size mod FileBlockSize)<> 0 then
  begin
    SetLength(S,FileBlockSize);
    Read:= InStream.Read(S[0],Size mod FileBlockSize);
    Inc(Result,Read);
    SetLength(S,Read);
    Decrypt(S,D);
    OutStream.Write(D[0],Read);
  end;
end;


end.
