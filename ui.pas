unit ui;

interface

uses raylib;

type

  TipoElementoVisual = (
    TBotao := 1);

  ElementoVisual = record
    Retangulo: Rectangle;
    Tipo: TipoElementoVisual;
    Texto: Pchar; 
    Valor: integer;
    EstaSelecionado: boolean; // se o mouse está em cima
    EstaAtivo: boolean; // se o botão do mouse foi pressionado em cima do elemento visual 
  end;

var // variáveis globais
  ElementoAntigo: ElementoVisual; // elemento selecionado no frame anterior
  ElementoAtual: ElementoVisual; // elemento selecionado no frame atual

(* Layout *)

function Coluna (Retangulo: PRectangle; Largura: single): Rectangle;
function Linha (Retangulo: PRectangle; Altura: single): Rectangle;

(* Fim Layout *)

(* Elementos Visuais *)
function Botao (Retangulo: Rectangle; Texto: Pchar): ElementoVisual;

(* Fim Elementos Visuais *)

(* Ui *)
procedure FinalizarFrameUi();
(* Fim Ui *)


implementation

function Coluna (Retangulo: PRectangle; Largura: single): Rectangle;
begin
  Coluna.X := Retangulo^.X;
  Coluna.Y := Retangulo^.X;
  Coluna.Height := Retangulo^.Height;
  if Largura <= Retangulo^.Width then
  begin
    Coluna.Width := Largura;
  end
  else 
  begin
    Coluna.Width := Retangulo^.Width;
  end; 
  Retangulo^.X := Retangulo^.X + Coluna.Width;
  Retangulo^.Width := Retangulo^.Width - Coluna.Width;
end;

function Linha (Retangulo: PRectangle; Altura: single): Rectangle;
begin
  Linha.X := Retangulo^.X;
  Linha.Y := Retangulo^.Y;
  Linha.Width := Retangulo^.Width;
  if Altura <= Retangulo^.Height then
  begin
    Linha.Height := Altura;
  end
  else
  begin
    Linha.Height := Retangulo^.Height;
  end;
  Retangulo^.Y := Retangulo^.Y + Linha.Height;
  Retangulo^.Height := Retangulo^.Y - Linha.Height;
end;

function Botao (Retangulo: Rectangle; Texto: Pchar): ElementoVisual;
var 
  PosicaoDoMouse: Vector2;
  CorDaBorda: Color = (R: 0; G: 0;  B: 0; A: 255);
  CorDoTexto: Color = (R: 0; G: 0; B: 0; A: 255);
  LarguraDaBorda: single = 1;
begin
  Botao.Retangulo := Retangulo;
  Botao.Texto := Texto;
  Botao.Tipo := TBotao;
  Botao.EstaSelecionado := false;
  Botao.EstaAtivo := false;
  
  PosicaoDoMouse := GetMousePosition ();

  if CheckCollisionPointRec (PosicaoDoMouse, Retangulo) then
  begin
    CorDaBorda.R := 255;
    Botao.EstaSelecionado := true;
  end;

  if Botao.EstaSelecionado and IsMouseButtonDown (MOUSE_BUTTON_LEFT) then
  begin
    LarguraDaBorda := 2;
    Botao.EstaAtivo := true;
  end;

  if Botao.EstaSelecionado then
      ElementoAtual := Botao;

  DrawRectangleLinesEx (Retangulo, LarguraDaBorda, CorDaBorda);
  DrawText (Texto, Trunc(Botao.Retangulo.X), Trunc(Botao.Retangulo.Y), 30, CorDoTexto);

end;

procedure FinalizarFrameUi();
begin
  ElementoAntigo := ElementoAtual;
end;

end.
