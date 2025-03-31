unit ui;

interface

uses raylib;

(* Layout *)

function Coluna (Retangulo: PRectangle; Largura: single): Rectangle;
function Linha (Retangulo: PRectangle; Altura: single): Rectangle;

(* Fim Layout *)

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


end.
