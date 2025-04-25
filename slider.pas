program slider;

uses raylib;

var
  retanguloSlider:Rectangle = (
    X: 50;
    Y: 50;
    Width: 450;
    Height: 50;
  );
  retanguloSeletor: Rectangle = (
    X: 50;
    Y: 50;
    Width: 20;
    Height: 50;
  );
  diff: single; 
  mouseDelta: Vector2;
begin
  InitWindow (1280, 720, 'Slider');
   
  while not WindowShouldClose() do
  begin
    if CheckCollisionPointRec(GetMousePosition (), retanguloSlider) then
    begin 
      if CheckCollisionPointRec(GetMousePosition(), retanguloSeletor) and IsMouseButtonDown (MOUSE_BUTTON_LEFT) then
      begin
         mouseDelta := GetMouseDelta (); 
         retanguloSeletor.X := retanguloSeletor.X + mouseDelta.X
      end
      else
      if IsMouseButtonDown (MOUSE_BUTTON_LEFT) then
         retanguloSeletor.X := GetMousePosition ().X - (retanguloSeletor.Width / 2);
    end; 
    BeginDrawing();
    ClearBackground (Branco);
    DrawRectangleLinesEx (retanguloSlider, 1.0, Preto);
    DrawRectangleRec (retanguloSeletor, Preto);
    EndDrawing();
  end;
  CloseWindow();
end.
