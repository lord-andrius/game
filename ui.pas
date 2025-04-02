unit ui;

interface

uses raylib;

type

  TipoElementoVisual = (
    TNenhum := 0,
    TBotao,
    TPainel
  );

  ElementoVisual = record
    Retangulo: Rectangle;
    Tipo: TipoElementoVisual;
    Texto: Pchar; 
    Valor: integer;
    EstaSelecionado: boolean; // se o mouse está em cima
    EstaAtivo: boolean; // se o botão do mouse foi pressionado em cima do elemento visual 
  end;

  Alinhamento = (
    Esquerda := 1,
    Centro   := 2,
    Direita  := 3
  );

var // variáveis globais
  ElementoAntigo: ElementoVisual; // elemento selecionado no frame anterior
  ElementoAtual: ElementoVisual; // elemento selecionado no frame atual

(* Layout *)

function Coluna (Retangulo: PRectangle; Largura: single): Rectangle;
function Linha (Retangulo: PRectangle; Altura: single): Rectangle;

(* Fim Layout *)

(* Elementos Visuais *)
function Botao (Retangulo: Rectangle; Texto: Pchar): ElementoVisual;

function Painel (PRetangulo: PRectangle; Titulo: Pchar): ElementoVisual;

(* Fim Elementos Visuais *)

(* Acoes *)
function Click (ElementoVisual: ElementoVisual): boolean;
function PainelDeveFechar (ElementoVisual: ElementoVisual): boolean;
(* Fim Acoes *)

(* Ui *)
procedure FinalizarFrameUi ();
(* Fim Ui *)

(* Utilidades *)
function CalcularLarguraAlturaDoTexto (Texto: Pchar; TamanhoFonte: longInt): Vector2; cdecl;
procedure DesenharTextoNoRetangulo (Retangulo: Rectangle; Texto: Pchar; TamanhoFonte: longInt; Alinhamento: Alinhamento; Cor: Color); 
(* Fim Utilidades *)


implementation

function Coluna (Retangulo: PRectangle; Largura: single): Rectangle;
begin
  Coluna.X := Retangulo^.X;
  Coluna.Y := Retangulo^.Y;
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
  Retangulo^.Height := Retangulo^.Height - Linha.Height;
end;

function Botao (Retangulo: Rectangle; Texto: Pchar): ElementoVisual;
var 
  PosicaoDoMouse: Vector2;
  CorDaBorda: Color = (R: 0; G: 0;  B: 0; A: 255);
  CorDoTexto: Color = (R: 0; G: 0; B: 0; A: 255);
  LarguraDaBorda: single = 1;
  TamanhoFonte: longint;
  RetanguloTexto: Rectangle;
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

  TamanhoFonte := trunc (Botao.Retangulo.Height / 3.0);

  DrawRectangleLinesEx (Retangulo, LarguraDaBorda, CorDaBorda);


  DesenharTextoNoRetangulo (Retangulo, Texto, TamanhoFonte, Centro, CorDoTexto);

end;

function Painel (PRetangulo: PRectangle; Titulo: Pchar): ElementoVisual;
const
  AlturaCabecalho: single = 20;
  TamanhoFonteTitulo: longInt = 20;
  TamanhoFonteX: longInt = 30;
  CorDoFundo: Color = (R: 169; G: 169; B: 169; A: 255);
  CorDaBordaNaoSelecionado: Color = (R: 128; G: 128; B: 128; A: 255);
  CorDaBordaSelecionado: Color = (R: 150; G: 150; B: 150; A: 255);
  CorDaBordaAtivo: Color = (R: 200; G: 200; B: 200; A: 255);
var
  Retangulo: Rectangle;
  RetanguloOriginal: Rectangle; 
  Cabecalho: Rectangle;
  CabecalhoTitulo: Rectangle;
  CabecalhoX: Rectangle;
  CabecalhoOriginal: Rectangle;
  CorDaBorda: Color;
  TamanhoDaBorda: longint;
  
begin
  Painel.Tipo := TPainel;
  Painel.EstaSelecionado := false;
  Painel.EstaAtivo := false;
  TamanhoDaBorda := 1;
  
  // movendo o painel se necessário
  if (Painel.Tipo = ElementoAntigo.Tipo) and
     (PRetangulo^.X = ElementoAntigo.Retangulo.X) and
     ((PRetangulo^.Y + AlturaCabecalho) = ElementoAntigo.Retangulo.Y) and
     (PRetangulo^.Width = ElementoAntigo.Retangulo.Width) and
     ((PRetangulo^.Height - AlturaCabecalho) = ElementoAntigo.Retangulo.Height) and
     (ElementoAntigo.EstaAtivo) = true then
  begin
      if GetMousePosition ().X < PRetangulo^.X then
      begin
        PRetangulo^.X := PRetangulo^.X - GetMouseDelta ().X;
      end
      else
      begin
        PRetangulo^.X := PRetangulo^.X + GetMouseDelta ().X;
      end;
      if GetMousePosition ().Y < PRetangulo^.Y then
      begin
        PRetangulo^.Y := PRetangulo^.Y - GetMouseDelta ().Y;
      end
      else
      begin
        PRetangulo^.Y := PRetangulo^.Y + GetMouseDelta ().Y;
      end;

  end;

  Retangulo := PRetangulo^;
  RetanguloOriginal := PRetangulo^;
  
  Cabecalho := Linha (@Retangulo, AlturaCabecalho);

  CabecalhoOriginal := Cabecalho;

  CabecalhoTitulo := Coluna (@Cabecalho, Cabecalho.Width - CalcularLarguraAlturaDoTexto ('X', TamanhoFonteX).X);
  CabecalhoX := Coluna (@Cabecalho, CalcularLarguraAlturaDoTexto ('X', TamanhoFonteX).X);

  Painel.Retangulo := Retangulo;
  
  CorDaBorda := CorDaBordaNaoSelecionado;

  if CheckCollisionPointRec (GetMousePosition (), CabecalhoTitulo) or 
     CheckCollisionPointRec (GetMousePosition (), Retangulo) then
  begin
    CorDaBorda := CorDaBordaSelecionado;
    Painel.EstaSelecionado := true;
  end;

  if Painel.EstaSelecionado and CheckCollisionPointRec (GetMousePosition (), CabecalhoTitulo) and IsMouseButtonDown (MOUSE_BUTTON_LEFT) then
  begin
    Painel.EstaAtivo := true;
    CorDaBorda := CorDaBordaAtivo;
  end;

  
    //Desenhando borda do painel inteiro
  DrawRectangleLinesEx (RetanguloOriginal, 1, CorDaBorda);   

  //Desenhando o cabeçalho
  DrawRectangleLinesEx (CabecalhoOriginal, 1, CorDaBordaNaoSelecionado);   
  DrawRectangleRec (CabecalhoOriginal, CorDoFundo);   
  DesenharTextoNoRetangulo (CabecalhoTitulo, Titulo, 5, Esquerda, PRETO);
  if Click (Botao (CabecalhoX, 'X')) then
  begin
    Painel.Valor := 1;
  end
  else
  begin
    Painel.Valor := 0;
  end;

  if Painel.EstaSelecionado then
    ElementoAtual := Painel
  

end;

function Click (ElementoVisual: ElementoVisual): boolean;
begin
  (*
    Lógica:
    O Elemento precisa ser o mesmo do frame atual e do antigo
    e o elementoAntigo precisa ser ativo e o frame atual precisa
    ser selecionado mas não ativo
  *)
  if (ElementoVisual.Tipo = ElementoAtual.Tipo) and
     (ElementoVisual.Retangulo.X = ElementoAtual.Retangulo.X) and
     (ElementoVisual.Retangulo.Y = ElementoAtual.Retangulo.y) and
     (ElementoVisual.Tipo = ElementoAntigo.Tipo) and
     (ElementoVisual.Retangulo.X = ElementoAntigo.Retangulo.X) and
     (ElementoVisual.Retangulo.Y = ElementoAntigo.Retangulo.Y) and
     (ElementoAntigo.EstaAtivo = true) and
     (ElementoAtual.EstaAtivo = false) and
     (ElementoAtual.EstaSelecionado = true) then
  begin
    Click := true
  end
  else
  begin
    Click := false;
  end;
end;

function PainelDeveFechar (ElementoVisual: ElementoVisual): boolean;
begin
    PainelDeveFechar := ElementoVisual.Valor = 1;
end;

function CalcularLarguraAlturaDoTexto (Texto: Pchar; TamanhoFonte: longInt): Vector2; cdecl;
begin
  CalcularLarguraAlturaDoTexto.X := MeasureText (Texto, TamanhoFonte);
  CalcularLarguraAlturaDoTexto.Y := MeasureTextEx (GetFontDefault (), Texto, single (TamanhoFonte), 1).Y;
end;

procedure DesenharTextoNoRetangulo (Retangulo: Rectangle; Texto: Pchar; TamanhoFonte: longInt; Alinhamento: Alinhamento; Cor: Color); 
var
  XTexto: longInt; 
  YTexto: longInt; 
  LarguraAltura: Vector2;
begin
  LarguraAltura := CalcularLarguraAlturaDoTexto (Texto, TamanhoFonte);
  YTexto := Trunc (Retangulo.Y) + Trunc ((Retangulo.Height / 2.0) - (LarguraAltura.Y / 2.0));
  case Alinhamento of
    Esquerda: XTexto := Trunc (Retangulo.X);
    Centro:   XTexto := Trunc (Retangulo.X) + Trunc ((Retangulo.Width / 2.0) - (LarguraAltura.X / 2.0));
    Direita:  XTexto := Trunc (Retangulo.X + Retangulo.Width - LarguraAltura.X);
  end;

  DrawText (Texto, XTexto, YTexto, TamanhoFonte, Cor);
end;

procedure FinalizarFrameUi();
begin
  ElementoAntigo := ElementoAtual;
  ElementoAtual.Tipo :=  TNenhum;
end;

end.
