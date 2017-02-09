unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, StdCtrls, Hurricane;

type
  TForm1 = class(TForm)
    Edit3: TEdit;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Button5: TButton;
    Button6: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  H: THBox;

implementation

{$R *.dfm}

procedure TForm1.Button6Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
  Edit1.Text:=OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Edit2.Text:=SaveDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  H:=THBox.Create(Self);
end;

procedure TForm1.Button3Click(Sender: TObject);
var K:TIdBytes;
    i: Integer;
    S,D:TFileStream;
begin
  SetLength(K,Length(Edit3.Text));
  for i:=1 to Length(Edit3.Text) do
    K[i-1]:=ord(Edit3.Text[i]);
  H.Init(False,False,K,32);
  S:=TFileStream.Create(Edit1.Text,fmOpenRead);
  D:=TFileStream.Create(Edit2.Text,fmCreate);
  H.EncryptStream(S,D,S.Size);
  S.Free;
  D.Free;
  ShowMessage('Encryption completed');
end;

procedure TForm1.Button4Click(Sender: TObject);
var K:TIdBytes;
    i: Integer;
    S,D:TFileStream;
begin
  SetLength(K,Length(Edit3.Text));
  for i:=1 to Length(Edit3.Text) do
    K[i-1]:=ord(Edit3.Text[i]);
  H.Init(False,False,K,32);
  S:=TFileStream.Create(Edit1.Text,fmOpenRead);
  D:=TFileStream.Create(Edit2.Text,fmCreate);
  H.DecryptStream(S,D,S.Size);
  S.Free;
  D.Free;
  ShowMessage('Decryption completed');
end;

end.
