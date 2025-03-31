program game;

uses raylib;

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
  Gravidade: single = 67.5;
  DuracaoPulo: double = 0.2; 
  Pulo: single = 15.0;
  ContinuacaoPulo: single = 0.5;
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
  //Jogador^.Velocidade.Y := 0; 
  //Jogador^.Aceleracao.Y := 0;
  Jogador^.PodePular := false;
  Jogador^.EstaPulando := true;
  Jogador^.Aceleracao.Y := Jogador^.Aceleracao.Y  - (Pulo * Gravidade);
  Jogador^.Velocidade.Y := Jogador^.Velocidade.y + (Jogador^.Aceleracao.Y * Tempo);
  Jogador^.Retangulo.Y := Jogador^.Retangulo.Y +
                          (Jogador^.Velocidade.Y * Tempo) +
                          ((Jogador^.Aceleracao.Y * (Tempo * Tempo)) / 2.0);
  //Jogador^.Retangulo.Y := Jogador^.Retangulo.Y - (150 * Tempo );
  //Jogador^.Retangulo.Y := Jogador^.Velocidade.Y + ((-Pulo * (Tempo*Tempo)) / 2.0);
end;

procedure ContinuarPulo (Jogador: PTJogador; Tempo: single);
begin
  Jogador^.Aceleracao.Y := Jogador^.Aceleracao.Y  - (Gravidade * ContinuacaoPulo);
  Jogador^.Velocidade.Y := Jogador^.Velocidade.y + (Jogador^.Aceleracao.Y * Tempo);
  Jogador^.Retangulo.Y := Jogador^.Retangulo.Y +
                          (Jogador^.Velocidade.Y * Tempo) +
                          ((Jogador^.Aceleracao.Y * (Tempo * Tempo)) / 2.0);
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
   if Jogador.PodePular and IsKeyPressed (KEY_SPACE) then
   begin
      IniciarPulo (@Jogador, Tempo);
   end;
  
    if Jogador.EstaPulando and IsKeyDown (KEY_SPACE)  and ((GetTime - Jogador.TempoInicioPulo) <= DuracaoPulo) then
    begin
      writeln ('Tempo: ', GetTime, ' TempoInicioPulo: ', Jogador.TempoInicioPulo, ' Diferenca: ', Tempo - Jogador.TempoInicioPulo);
      ContinuarPulo (@Jogador, Tempo);
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
   ClearBackground (BRANCO);
   DrawRectangleRec (Jogador.Retangulo, Jogador.Cor);
   DrawRectangleRec (Chao.Retangulo, Chao.Cor);
   EndDrawing ();
 end; 
 ImageDestroy (Imagem); 
 UnloadTexture (Textura);
end.
