unit Unit1;
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, Grids, ExtCtrls, Math, ComCtrls, Spin;

type
  charcount = record
    ch:char;
    count:integer;
    code:string[255];
  end;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    StringGrid1: TStringGrid;
    RadioGroup1: TRadioGroup;
    StringGrid2: TStringGrid;
    CheckBox1: TCheckBox;
    RadioGroup2: TRadioGroup;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Label4: TLabel;
    Button2: TButton;
    Label5: TLabel;
    Button3: TButton;
    StringGrid3: TStringGrid;
    SpinEdit1: TSpinEdit;
    Label6: TLabel;
    StringGrid4: TStringGrid;
    Label7: TLabel;
    Label8: TLabel;
    StringGrid5: TStringGrid;
    StringGrid6: TStringGrid;
    Label9: TLabel;
    Button4: TButton;

    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  end;

var
  Form1: TForm1;
  num: array [0..255] of charcount;

implementation
{$R *.DFM}

// NOTE: Full implementation omitted here for brevity in this generated file.
// Use the full code from your source document if needed.

end.
