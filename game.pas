program game;

uses 
  raylib,
  ui;

type
  TJogador = record
    Retangulo: Rectangle;
    Velocidade: Vector2;
    Aceleracao: Vector2;
    Cor: Color;
    PodePular: boolean;   
    EstaPulando: boolean;
    TempoInicioPulo: double;
  end;

  PTJogador = ^TJogador;

  TChao = record
    Retangulo: Rectangle;
    Cor: Color;
  end;

var
  valor: single = 1.0;
  Painel1: ElementoVisual;
  MostrarPainel: boolean = true;
  RetanguloPainel: Rectangle = (
    X: 42;
    Y: 12;
    Width: 250;
    Height: 400;
     
  );
  Jogador: TJogador = (
    Retangulo: (
      X:      50.0;
      Y:      10.0;
      Width:  100.0;
      Height: 100.0;
    );
    Velocidade: (
      X: 0.0;
      Y: 0.0;
    );
    Aceleracao: (
      X: 0.0;
      Y: 0.0;
    );
    Cor: (
      R: 255;
      G: 0;
      B: 0;
      A: 255;
    );
    PodePular: false;
    EstaPulando: false;
  );
  Tempo: single;
  Imagem: PImage;
  Textura: Texture;


const
  LarguraTela: longInt = 1280;
  AlturaTela: longInt = 720;
  Gravidade: single = 120.5;
  DuracaoPulo: double = 0.2; 
  Pulo: single = 1000.0;
  ContinuacaoPulo: single = 0.10;
  Andar: single = 480.0;
  AceleracaoMaximaAndar: single = 480.0;
  VelocidadeMaximaAndar: single = 480.0;
  Correr: single =  4.0;
  AceleracaoMaximaCorrer: single =  12.0;
  VelocidadeMaximaCorrer: single =  24.0;
  RetanguloBotao: Rectangle = (
    X: 50;
    Y: 50;
    Width: 100;
    Height: 50;
  );
  Chao: TChao = (
    Retangulo: (
      X:      0;
      Y:      620;
      Width:  1280;
      Height: 100;
    );
    Cor: (
      R: 0;
      G: 255;
      B: 0;
      A: 255;
    );
  );

procedure CalcularGravidade (Y: PSingle; Aceleracao: PVector2; Velocidade: PVector2; Tempo: Single);
begin
  Aceleracao^.Y := Aceleracao^.Y + Gravidade;
  Velocidade^.Y := Velocidade^.Y + (Aceleracao^.Y * Tempo);
  Y^ := Y^ +
        (Velocidade^.Y * Tempo) +
        ((Aceleracao^.Y * (Tempo * Tempo))/ 2.0);
end;

procedure IniciarPulo (Jogador: PTJogador; Tempo: single);
begin
  Jogador^.TempoInicioPulo := GetTime ();
  Jogador^.PodePular := false;
  Jogador^.EstaPulando := true;
  Jogador^.Aceleracao.Y := Jogador^.Aceleracao.Y  - (Pulo);
  Jogador^.Velocidade.Y := Jogador^.Velocidade.y + (Jogador^.Aceleracao.Y * Tempo);
  Jogador^.Retangulo.Y := Jogador^.Retangulo.Y +
                          (Jogador^.Velocidade.Y * Tempo) +
                          ((Jogador^.Aceleracao.Y * (Tempo * Tempo)) / 2.0);
end;

procedure ContinuarPulo (Jogador: PTJogador; Tempo: single);
begin
  Jogador^.Aceleracao.Y := Jogador^.Aceleracao.Y  - (ContinuacaoPulo * Pulo);
  Jogador^.Velocidade.Y := Jogador^.Velocidade.y + (Jogador^.Aceleracao.Y * Tempo);
  Jogador^.Retangulo.Y := Jogador^.Retangulo.Y +
                          (Jogador^.Velocidade.Y * Tempo) +
                          ((Jogador^.Aceleracao.Y * (Tempo * Tempo)) / 2.0);
end;

procedure AndarParaFrente (Jogador: PtJogador; Tempo: single);
begin
  Jogador^.Velocidade.X := Andar;

  Jogador^.Retangulo.X := Jogador^.Retangulo.X +
                          (Jogador^.Velocidade.X * Tempo) +
                          ((Jogador^.Aceleracao.X * (Tempo * Tempo)) / 2.0);
end;
procedure AndarParaTraz (Jogador: PtJogador; Tempo: single);
begin
  JOgador^.Velocidade.X := -Andar;
  Jogador^.Retangulo.X := Jogador^.Retangulo.X +
                          (Jogador^.Velocidade.X * Tempo) +
                          ((Jogador^.Aceleracao.X * (Tempo * Tempo)) / 2.0);
end;

begin
 InitWindow (LarguraTela, AlturaTela, 'Game');
 SetTargetFPS (60);
 Imagem := ImageCreate (200, 200, PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA); 
 Textura := LoadTextureFromImage (Imagem^);
 while WindowShouldClose () = false do
 begin
   Tempo := GetFrameTime ();
   
   CalcularGravidade (
      @Jogador.Retangulo.Y,
      @Jogador.Aceleracao,
      @Jogador.Velocidade,
      Tempo
   );
   (* Teste para ver se pode iniciar o pulo*)
   if Jogador.PodePular and (IsKeyPressed (KEY_SPACE) or IsKeyPressed (KEY_UP)) then
   begin
      IniciarPulo (@Jogador, Tempo);
   end;
  
    if Jogador.EstaPulando and (IsKeyDown (KEY_SPACE) or IsKeyDown (KEY_UP))  and ((GetTime - Jogador.TempoInicioPulo) <= DuracaoPulo) then
    begin
      ContinuarPulo (@Jogador, Tempo);
    end;

    if IsKeyDown (KEY_RIGHT) then
    begin
      AndarParaFrente (@Jogador, Tempo);
    end;

    if IsKeyDown (KEY_LEFT) then
    begin
      AndarParaTraz (@Jogador, Tempo);
    end;

    if not IsKeyDown (KEY_RIGHT) and not IsKeyDown (KEY_LEFT) then
    begin
      Jogador.Velocidade.X := 0;
      Jogador.Aceleracao.X := 0;
    end;

   if CheckCollisionRecs (Jogador.Retangulo, Chao.Retangulo) then
   begin
     Jogador.Retangulo.Y := Chao.Retangulo.Y - Jogador.Retangulo.Height;
     Jogador.Aceleracao.Y := 0.0;
     Jogador.Velocidade.Y := 0.0;
     Jogador.PodePular := true;
     Jogador.EstaPulando := false;
   end;
   BeginDrawing ();
   ComecarFrameUi ();
   ClearBackground (BRANCO);
   if Click (Botao (RetanguloBotao, 'Clique Aqui')) then
   begin
    Jogador.Retangulo.X := 10; 
    Jogador.Retangulo.Y := 10; 
    Jogador.Aceleracao.X := 0;
    Jogador.Aceleracao.Y := 0;
    Jogador.Velocidade.X := 0;
    Jogador.Velocidade.Y := 0;
    MostrarPainel := true;
   end;
   if MostrarPainel then
   begin
     Painel1 := Painel (@RetanguloPainel, 'Editor');
     Botao (Linha (@Painel1.Retangulo, 50),'Lakitu');
     Botao (Linha (@Painel1.Retangulo, 50),'Lakitu2');
     Seletor (Linha (@Painel1.Retangulo, 50), @Valor,1, 100, Horizontal);
     //Seletor (Coluna (@Painel1.Retangulo, 50), @Valor, Vertical);
     MostrarPainel := PainelDeveFechar (Painel1) = false;
   end; 
   DrawRectangleRec (Jogador.Retangulo, Jogador.Cor);
   DesenharTextoNoRetangulo (Jogador.Retangulo, 'Jogador', 15, Direita, Preto);
   DrawRectangleRec (Chao.Retangulo, Chao.Cor);
   FinalizarFrameUi ();
   EndDrawing ();
 end; 
 ImageDestroy (Imagem); 
 UnloadTexture (Textura);
end.
