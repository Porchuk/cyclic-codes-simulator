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
//Кодування методом Шенона-Фано
procedure BuildCode(n1,n2:integer);
{Процедура, яка ділить задану гілку на дві півгілки, при чому кожному елементу лівої гілки до коду додається 0, а кожному елементу правої гілки додається одиниця. На вхід подаються 2 параметри: n1 показує початок гілки, n2 - кінець гілки.
Алгоритм такий: спочатку сортуємо всі елементи всередині гілки за спаданням. Потім беремо перший елемент. Якщо кількість його входжень більша, ніж половина від загальної кількості символів, то цей елемент потрапляє до лівої гілки,усі інші - до правої. Якщо ж ні, то беремо перші 2 елементи, потім перші 3 і т.д., доки не перевищимо половину від заг. кількості символів. Далі рекурсія - викликаємо цю саму процедуру по черзі для правої і лівої півгілки. Алгоритм закінчується, якщо у обох гілках залишиться по одному елементу.
}
var i,j,cursum:integer;
halfsum:real;
k:charcount;
s1,s2:string;
begin
if n1=n2 then exit; //виходимо, якщо у гілці лише 1 символ
for i:=n1 to n2-1 do //сортуємо гілку за спаданням
  for j:=i to n2 do
    if num[i].count<num[j].count then begin
      k:=num[i];
      num[i]:=num[j];
      num[j]:=k;
    end;
halfsum:=0;
for i:=n1 to n2 do
  halfsum:=halfsum+num[i].count;

halfsum:=halfsum/2; //половина кількості символів у гілці

i:=n1; cursum:=0; //беремо спочатку один елемент
repeat //якщо його кількість входжень менша за половину
//всієї кількості символів у гілці,
cursum:=cursum+num[i].count; //то беремо ще один
inc (i);
until cursum>halfsum; //якщо сумарна кількість вибраних
//символів більша за вказане число, то виходимо з циклу.
//Вибрані символи утворили ліву півгілку, а всі решта - праву.

s1:=''; s2:='';
//далі дописуємо 0 до коду кожного символа лівої півгілки
//і 1 для правої.
if n2-n1=1 then begin //якщо у гілці лише 2 символи
  s1:=num[n1].ch; s2:=num[n2].ch;
  num[n1].code:=num[n1].code+'0'; //то розподіляємо по 1 символу
  num[n2].code:=num[n2].code+'1'; //у ліву і праву півгілки
  i:=n2; end
else //якщо у гілці більше, ніж 2 символи
for j:=n1 to n2 do //тоді відраховуємо половину
  if j<i then begin num[j].code:=num[j].code+'0'; s1:=s1+num[j].ch; end
    else begin num[j].code:=num[j].code+'1'; s2:=s2+num[j].ch; end;

//тепер повторюємо цю саму процедуру по черзі
//для лівої та правої півгілки
BuildCode(n1,i-1);
BuildCode(i,n2);

end;

//Кодування методом Хафмена
{Алгоритм такий: процедура на вході отримує кодову стрічку, яка має вигляд:
s1#&$^n1;%~s2#&$^n2;%~...;%~sk#&$^nk;%~
де s1..sk - символ або група символів, n1..nk – сумарна частота відповідної групи символів. Процедура записує ці дані у масив, сортує його за зростанням відносно частоти кожної групи символів, а потім об'єднує два символи з найменшими значеннями частоти у єдину групу, а їх частоти додаються. Виходить нова кодова стрічка, для якої знову виконуються усі вищевказані дії. Процес триває доти, доки не об'єднаються в єдину групу усі символи, які були у початковій кодовій стрічці.
}
procedure Hafmen(st:string; var codes: array of string);
type xafmentree=record
  c: string;
  sum:integer;
  end;
var mas: array [0..255] of xafmentree;
i,j,n,k: integer; x:string;
begin
n:=0; i:=1;
//Спершу розбиваємо вхідну стрічку на пари вигляду
//s1#&$^n1 і т.д. Застосовуємо алгоритм виділення слів.
while i<=length(st) do begin
  if i>length(st) then break;
  j:=i+1;
  while (j<=length(st)) and not(copy(st,j,3)=';%~') do j:=j+1;
  n:=n+1;
  mas[n-1].c:=copy(st,i,j-i);
  i:=j+3;
end;
//Потім кожну таку пару розбиваємо на 2 частини: с - послідовність
//символів, а sum - сумарна частота усіх символів у даній
//послідовності. Розділювачем служить набір з 4 символів #&$^
for i:=0 to n-1 do
  for j:=1 to length(mas[i].c)-3 do
    if copy(mas[i].c,j,4)='#&$^' then begin
      mas[i].sum:=strtoint(copy(mas[i].c,j+4,length(mas[i].c)-j-3));
      mas[i].c:=copy(mas[i].c,1,j-1);
      break;
    end;

if n=1 then exit; //виходимо, якщо в масиві лише один елемент, бо
//в такому разі більше нема елементів, які треба об'єднувати.

//Сортуємо масив mas за зростанням
for i:=0 to n-2 do
  for j:=i to n-1 do
    if mas[i].sum>mas[j].sum then begin
      k:=mas[i].sum; mas[i].sum:=mas[j].sum; mas[j].sum:=k;
      x:=mas[i].c; mas[i].c:=mas[j].c; mas[j].c:=x;
    end;

//Усім символам в першому елементі присвоюємо код 0,
//а в другому - код 1.
for i:=1 to length(mas[0].c) do
  codes[ord(mas[0].c[i])]:=codes[ord(mas[0].c[i])]+'0';
for i:=1 to length(mas[1].c) do
  codes[ord(mas[1].c[i])]:=codes[ord(mas[1].c[i])]+'1';
//Об'єднуємо два елементи з найменшими частотами в один
//(елементи з номерами 0 та 1).
mas[0].c:=mas[0].c+mas[1].c;
mas[0].sum:=mas[0].sum+mas[1].sum;
//Видаляємо другий елемент, залишаючи тільки перший.
for i:=1 to n-2 do begin
  mas[i].c:=mas[i+1].c;
  mas[i].sum:=mas[i+1].sum;
end;
n:=n-1; //зменшуємо кількість елементів масиву на 1

//З нового масиву утворюємо нову кодову стрічку
x:='';
for i:=0 to n-1 do
  x:=x+mas[i].c+'#&$^'+inttostr(mas[i].sum)+';%~';

//Повторюємо цю саму процедуру для кодової стрічки доти,
//доки усі її елементи не об'єднаються в один.
Hafmen(x,codes);
end;

//ОСНОВНА ПРОЦЕДУРА КОДУВАННЯ
procedure EncodeText();
var
i,j,n,allsymbols:integer; s,st:string;
symb:array [0..255] of integer;
codes: array [0..255] of string;
k:charcount;
abetka: set of char;
ser,entrop,nadl:real;
begin
if form1.memo1.text='' then begin //якщо текст для кодування не введено
  MessageDlg('Спочатку введіть текст для кодування!',mtWarning,[mbOk],0);
  exit;//то виходимо з процедури
end;
//у масиві symb буде вказано, скільки разів у тексті
//зустрічається кожен символ
for i:=0 to 255 do begin symb[i]:=0; num[i].count:=0; num[i].code:=''; codes[i]:=''; end;
//зануляємо масиви symb i num
form1.memo2.lines.clear;
for i:=1 to length(form1.memo1.text) do begin
  if not(form1.memo1.text[i] in abetka) then include(abetka,form1.memo1.text[i]);
  //якщо даний символ зустрівся уперше, то заносимо його до
  //множини вхідного алфавіту
  symb[ord(form1.memo1.text[i])]:=symb[ord(form1.memo1.text[i])]+1;
  //збільшуємо лічильник даного символа на 1.
  end;
n:=0;
for i:=0 to 255 do
  if symb[i]<>0 then begin
    n:=n+1;
    num[n-1].ch:=chr(i);
    num[n-1].count:=symb[i];
  end;
//тепер у масиві num вказано, скільки разів зустрічається
//кожен символ.
//n - кількість різних символів у тексті.

for i:=0 to n-2 do //сортуємо масив num за спаданням
  for j:=i to n-1 do
    if num[i].count<num[j].count then begin
      k:=num[i];
      num[i]:=num[j];
      num[j]:=k;
    end;
allsymbols:=0;
for i:=0 to n-1 do //рахуємо, скільки всього символів
  allsymbols:=allsymbols+num[i].count; //у нашому тексті
form1.stringgrid2.Cells[1,0]:='Cимволів у вхідному тексті: '+inttostr(allsymbols);

if n=1 then num[0].code:='0';//якщо у стрічці лише 1 символ,то його код 0

//Якщо метод Шенона-Фано, то будуємо код для кожного символа
if form1.radiogroup1.ItemIndex=0 then BuildCode(0,n-1)
else begin //Якщо ж метод Хафмена,
  st:=''; //то будуємо кодувальну стрічку
  for i:=0 to n-1 do
    st:=st+num[i].ch+'#&$^'+inttostr(num[i].count)+';%~';
  Hafmen(st,codes); //код кожного символа - у масиві codes
  //Тепер код кожного символа треба записати у зворотньому порядку,
  //бо код рахується від основи дерева, а не від листків.
  for i:=0 to 255 do begin
    st:='';
    for j:=length(codes[i]) downto 1 do
      st:=st+codes[i][j];
    codes[i]:=st;
  end;
end;

//Якщо це був метод Хафмена, то треба усі значення кодів з масиву
//codes скопіювати у масив num, щоб вивести їх у таблицю.
//Якщо у тексті лише 1 символ, то він уже раніше отримав
//код 0 і нема змісту знову псувати його код.
if (form1.radiogroup1.ItemIndex=1) and (n>1) then begin
  for i:=0 to n-1 do
    num[i].code:=codes[ord(num[i].ch)];
end;

form1.stringgrid1.RowCount:=n+1;
for i:=0 to n-1 do begin//Виводимо код кожного символа
  //у таблиці
  form1.stringgrid1.cells[0,i+1]:=inttostr(i+1);//порядковий номер
  form1.stringgrid1.cells[1,i+1]:=num[i].ch;//сам символ
  form1.stringgrid1.cells[2,i+1]:=inttostr(num[i].count);//його частота
  form1.stringgrid1.cells[3,i+1]:=num[i].code;//його код
end;

//Рахуємо середню довжину кодового слова
ser:=0;
for i:=0 to n-1 do
  ser:=ser+(num[i].count/allsymbols)*length(num[i].code);
form1.stringgrid2.RowCount:=2;
form1.stringgrid2.cells[0,1]:='Сер.довж.слова';
form1.stringgrid2.cells[1,1]:=floattostr(ser);
//Рахуємо ентропію джерела
entrop:=0;
for i:=0 to n-1 do
  entrop:=entrop-(num[i].count/allsymbols)*Log2(num[i].count/allsymbols);
form1.stringgrid2.RowCount:=3;
form1.stringgrid2.cells[0,2]:='Ентропія';
form1.stringgrid2.cells[1,2]:=floattostr(entrop);
//Рахуємо надлишковість коду
nadl:=1-(entrop/ser);
form1.stringgrid2.RowCount:=4;
form1.stringgrid2.cells[0,3]:='Надлишковість коду';
form1.stringgrid2.cells[1,3]:=floattostr(nadl);

//Копіюємо код кожного символа до масиву codes, де кожному
//номеру символа з таблиці ASCII відповідає двійковий код
//у символьній формі.
//Якщо ж символ у тексті не зустрічається, то кодувати його
//нема змісту і відповідно його код - порожній рядок.
//Цей масив кращий, ніж масив num, бо тут швидше можна знайти
//код потрібного символа - за його ASCII-кодом. Таким чином,
//не потрібно щоразу проходити весь масив у пошуках елемента.
for i:=0 to n-1 do
  codes[ord(num[i].ch)]:=num[i].code;

st:='';//стрічка, куди будемо записувати закодоване повідомлення
for i:=1 to length(form1.memo1.text) do
  st:=st+codes[ord(form1.memo1.text[i])];

form1.memo2.text:='';
form1.memo2.text:=st; //виводимо закодоване повідомлення
form1.RadioGroup2.enabled:=true; //кнопка "Декодер" стає доступною
end;


//ОСНОВНА ПРОЦЕДУРА ДЕКОДУВАННЯ
{Алгоритм: проходимо посимвольно введений текст для декодування, який складається лише з нулів та одиниць. Спочатку j=1. Починаючи від j-го символа беремо 1,2,3 або більше символів і перевіряємо, чи складають вони якесь кодове слово. Якщо так, то дане слово замінюємо на символ, який ним закодований. j ставимо на символ, наступний після кінця даного кодового слова, і рухаємося далі, шукаючи наступне кодове слово. Якщо досягнули кінця стрічки і не утворилося жодне кодове слово, то друкуємо тире - це означає,що даний текст неможливо розкодувати.
}
procedure DecodeText();
var i,j,m,n:integer;
wordfound:boolean;//змінна,яка вказує,чи знайшли ми кодове слово
begin
if form1.memo1.text='' then begin //якщо текст для декодування не введено
  MessageDlg('Спочатку введіть текст для декодування!',mtWarning,[mbOk],0);
  exit; //то виходимо з процедури
end;
//Як знати, скільки елементів у масиві num? Тобто скільки
//є різних кодових слів. Їх є стільки, скільки рядків є
//у таблиці кодувального алфавіту (крім першого допоміжного
//рядка).
n:=form1.StringGrid1.RowCount-1;
form1.memo2.text:='';

j:=1; //j вказує на перший символ даного слова
for i:=1 to length(form1.memo1.text) do begin
  //Якщо якийсь із символів тексту для декодування
  //не є нулем чи одиницею
  if (form1.memo1.text[i]<>'0') and (form1.memo1.text[i]<>'1') then begin
    MessageDlg('Текст для декодування може містити лише символи 0 і 1!',mtWarning,[mbOk],0);
    exit; //то виходимо з процедури
  end;
  wordfound:=false;//ознака того, що кодове слово розпізнано
  for m:=0 to n do
    if copy(form1.memo1.text,j,i-j+1)=num[m].code then begin
      wordfound:=true;//кодове слово розпізнане
      form1.memo2.text:=form1.memo2.text+num[m].ch;
      j:=i+1;
      break;
    end;
end;
//якщо якесь кодове слово не знайшли, то на його місці
//ставимо тире
if not wordfound then form1.memo2.text:=form1.memo2.text+'-';

end;


//Кнопка "Закодувати"
procedure TForm1.Button1Click(Sender: TObject);
begin
if radiogroup2.ItemIndex=0 then EncodeText()
  else DecodeText();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
stringgrid1.Cells[0,0]:='№';
stringgrid1.Cells[1,0]:='Символ';
stringgrid1.Cells[2,0]:='Частота';
stringgrid1.Cells[3,0]:='Код';
stringgrid3.Cells[0,0]:='1';
end;

//Меню "Вихід"
procedure TForm1.N4Click(Sender: TObject);
begin
form1.Close;
end;

//Меню "Відкрити", яке дозволяє відкрити текстовий файл для кодування
procedure TForm1.N2Click(Sender: TObject);
begin
opendialog1.Execute; //вікно вибору файла
if opendialog1.FileName='' then exit;
memo1.lines.clear();
memo1.lines.LoadFromFile(opendialog1.FileName);
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
//Якщо увімкнене посимвольне кодування, то при натисканні
//клавіші на текстовому полі щоразу відбувається
//повторне кодування чи декодування.
if checkbox1.Checked then
  if radiogroup2.ItemIndex=0 then EncodeText()
  else DecodeText();
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
//Якщо увімкнене посимвольне кодування, то при зміні
//зміні методу кодування вхідний текст автоматично заново
//кодується новим методом.
if checkbox1.Checked then EncodeText();
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if checkbox1.Checked then
  if radiogroup2.ItemIndex=0 then EncodeText()
  else DecodeText();
end;

//Обираємо режим: кодування чи декодування
procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
if radiogroup2.ItemIndex=0 then begin
  button1.Caption:='Закодувати';
  checkbox1.Caption:='Посимвольне кодування';
  label1.Caption:='Вхідний текст:';
  label2.Caption:='Закодований текст:';
  radiogroup1.Enabled:=true;
  memo1.lines.clear;
  memo2.lines.clear;
end else begin
  button1.Caption:='Декодувати';
  checkbox1.Caption:='Посимвольне декодування';
  label1.Caption:='Закодований текст (0 і 1):';
  label2.Caption:='Розкодований текст:';
  radiogroup1.Enabled:=false;
  memo1.lines.clear;
  memo2.lines.clear;
end;
end;

//процедура зсуву вліво на 1 біт
procedure left_bits(var bits:string);
var ch:char;
    i:integer;
begin
ch:=bits[1];
for i:=1 to length(bits)-1 do
    bits[i]:=bits[i+1];
bits[length(bits)]:=ch;
end;

//процедура зсуву вправо на 1 біт
procedure right_bits(var bits:string);
var ch:char;
    i:integer;
begin
ch:=bits[length(bits)];
for i:=length(bits) downto 2 do
    bits[i]:=bits[i-1];
bits[1]:=ch;
end;

//функція обчислення ваги
function weight(bits:string):integer;
var i:integer;
begin
result:=0;
for i:=1 to length(bits) do
    result:=result+strtoint(bits[i]);
end;

//функція додавання за модулем 2
function add_mod_2(bits,bits_ost:string):string;
var i,j:integer;
begin
result:='';
for i:=1 to length(bits) do
    result:=result+' ';
j:=length(bits);
i:=length(bits_ost);
while i>0 do
    begin
    if bits[j]<>bits_ost[i] then
        result[j]:='1'
    else
        result[j]:='0';
    i:=i-1;
    j:=j-1;
    end;
while j>0 do
    begin
    result[j]:=bits[j];
    j:=j-1;
    end;
end;

//функція знаходження остачі
function ostacha(bits1,bits2:string):string;
var i,j:integer;
    tmp:string;
begin
j:=1;
tmp:='';
repeat
i:=1;
while (i<=length(tmp))and((tmp[i]='0')) do
    delete(tmp,i,1);
while (length(tmp)<length(bits2))and(j<=length(bits1)) do
    begin
    tmp:=tmp+bits1[j];
    j:=j+1;
    end;
if length(tmp)=length(bits2) then
    tmp:=add_mod_2(tmp,bits2)
until j>length(bits1);
    result:=tmp;
end;

//функція отримання незвідного многочлена
function get_nezvid_mnog(n:integer):string;
begin
if n=2 then
    result:='111'
else if n=3 then
    result:='1011'
else if n=4 then
    result:='11001'
else if n=5 then
    result:='100101'
else if n=6 then
    result:='1000011'
else if n=7 then
    result:='10001001'
else if n=8 then
    result:='100011101'
else if n=9 then
    result:='1000010001';
end;

//функція отримання циклічного коду
function make_code(input_bits:string):string;
var ni,nk,i:integer;
    mn,ost,tmp:string;
begin
ni:=length(input_bits);
nk:=round(ln(ni+1)/ln(2));
nk:=round(ln(ni+1+nk)/ln(2));
tmp:=input_bits;
for i:=1 to nk do
    tmp:=tmp+'0';
mn:=get_nezvid_mnog(nk);
ost:=ostacha(tmp,mn);
delete(ost,1,length(ost)-nk);
result:=input_bits;
for i:=1 to nk-length(ost) do
     result:=result+'0';
result:=result+ost;
end;

//функція виявлення одиничної помилки
function find_error(var input_bits:string):integer;
var n,nk,w,n_s,i:integer;
    mn,ost:string;
begin
n:=length(input_bits);
nk:=round(ln(n+1)/ln(2));
mn:=get_nezvid_mnog(nk);
ost:=ostacha(input_bits,mn);
w:=weight(ost);
if w=0 then
    result:=-1
else
    begin
    n_s:=0;
    while w>1 do
    begin
        n_s:=n_s+1;
        left_bits(input_bits);
        ost:=ostacha(input_bits,mn);
        w:=weight(ost);
    end;
    i:=1;
    while (ost[i]='0')and (i<=length(ost)) do
        delete(ost,i,1);
    input_bits:=add_mod_2(input_bits,ost);
    for i:=1 to n_s do
        right_bits(input_bits);

    if n_s=0 then
        result:=n-length(ost)+1
    else
        result:=n_s;
    end;
end;


procedure TForm1.Button2Click(Sender: TObject);
var input_bits,code:string;
    n,i:integer;
begin
n:=SpinEdit1.value;
input_bits:='';
for i:=1 to n do
    input_bits:=input_bits+StringGrid3.cells[i-1,1];
code:=make_code(input_bits);
if code<>'' then
    begin
    StringGrid4.ColCount:=length(code);
    for i:=1 to length(code) do
        begin
        Stringgrid4.Cells[i-1,1]:=code[i];
        Stringgrid4.Cells[i-1,0]:=inttostr(i);
        end;
    end
else ShowMessage('Неможливо побудувати циклічний код')
end;

procedure TForm1.Button3Click(Sender: TObject);
var n_e,i:integer;
    i_b:string;
begin
i_b:='';
for i:=1 to Stringgrid5.colcount do
    i_b:=i_b+StringGrid5.Cells[i-1,1];
n_e:=find_error(i_b);
if n_e=-1 then
    label5.caption:='Помилок немає'
else
    label5.caption:='помилка в  '+inttostr(n_e)+' біті';
StringGrid6.ColCount:=length(i_b);
for i:=1 to length(i_b) do
    begin
    StringGrid6.Cells[i-1,0]:=inttostr(i);
    StringGrid6.Cells[i-1,1]:=i_b[i];
    end;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
var i:integer;
begin
if SpinEdit1.Value<1 then
    Spinedit1.Value:=1;
Stringgrid3.ColCount:=SpinEdit1.Value;
for i:=1 to SpinEdit1.Value do
    StringGrid3.Cells[i-1,0]:=Inttostr(i);
end;

procedure TForm1.Button4Click(Sender: TObject);
var i:integer;
begin
Stringgrid5.ColCount:=StringGrid4.ColCount;
for i:=1 to StringGrid4.ColCount do
    begin
    Stringgrid5.Cells[i-1,1]:=Stringgrid4.Cells[i-1,1];
    Stringgrid5.Cells[i-1,0]:=inttostr(i);
    end;
end;

end.

