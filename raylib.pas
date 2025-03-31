unit raylib;

{$Linklib c}
{$Linklib m}
interface

(* Tipos *)
type
  Color = record
     R, G, B, A: byte;
  end;
  
  Rectangle = record
     X, Y, Width, Height: single;
  end;

  PRectangle = ^Rectangle;

  Vector2 = record
      X, Y: single;
  end;

  PVector2 = ^Vector2;
  PixelFormat = ( 
      PIXELFORMAT_UNCOMPRESSED_GRAYSCALE := 1, // 8 bit per pixel (no alpha)
      PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA,    // 8*2 bpp (2 channels)
      PIXELFORMAT_UNCOMPRESSED_R5G6B5,        // 16 bpp
      PIXELFORMAT_UNCOMPRESSED_R8G8B8,        // 24 bpp
      PIXELFORMAT_UNCOMPRESSED_R5G5B5A1,      // 16 bpp (1 bit alpha)
      PIXELFORMAT_UNCOMPRESSED_R4G4B4A4,      // 16 bpp (4 bit alpha)
      PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,      // 32 bpp
      PIXELFORMAT_UNCOMPRESSED_R32,           // 32 bpp (1 channel - float)
      PIXELFORMAT_UNCOMPRESSED_R32G32B32,     // 32*3 bpp (3 channels - float)
      PIXELFORMAT_UNCOMPRESSED_R32G32B32A32,  // 32*4 bpp (4 channels - float)
      PIXELFORMAT_UNCOMPRESSED_R16,           // 16 bpp (1 channel - half float)
      PIXELFORMAT_UNCOMPRESSED_R16G16B16,     // 16*3 bpp (3 channels - half float)
      PIXELFORMAT_UNCOMPRESSED_R16G16B16A16,  // 16*4 bpp (4 channels - half float)
      PIXELFORMAT_COMPRESSED_DXT1_RGB,        // 4 bpp (no alpha)
      PIXELFORMAT_COMPRESSED_DXT1_RGBA,       // 4 bpp (1 bit alpha)
      PIXELFORMAT_COMPRESSED_DXT3_RGBA,       // 8 bpp
      PIXELFORMAT_COMPRESSED_DXT5_RGBA,       // 8 bpp
      PIXELFORMAT_COMPRESSED_ETC1_RGB,        // 4 bpp
      PIXELFORMAT_COMPRESSED_ETC2_RGB,        // 4 bpp
      PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA,   // 8 bpp
      PIXELFORMAT_COMPRESSED_PVRT_RGB,        // 4 bpp
      PIXELFORMAT_COMPRESSED_PVRT_RGBA,       // 4 bpp
      PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA,   // 8 bpp
      PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA    // 2 bpp
    );

  KeyboardKey = (
    KEY_NULL            := 0,        // Key: NULL, used for no key pressed
    (* Alphanumeric keys *)
    KEY_APOSTROPHE      := 39,       // Key: (*'*)
    KEY_COMMA           := 44,       // Key: ,
    KEY_MINUS           := 45,       // Key: -
    KEY_PERIOD          := 46,       // Key: .
    KEY_SLASH           := 47,       // Key: /
    KEY_ZERO            := 48,       // Key: 0
    KEY_ONE             := 49,       // Key: 1
    KEY_TWO             := 50,       // Key: 2
    KEY_THREE           := 51,       // Key: 3
    KEY_FOUR            := 52,       // Key: 4
    KEY_FIVE            := 53,       // Key: 5
    KEY_SIX             := 54,       // Key: 6
    KEY_SEVEN           := 55,       // Key: 7
    KEY_EIGHT           := 56,       // Key: 8
    KEY_NINE            := 57,       // Key: 9
    KEY_SEMICOLON       := 59,       // Key: ;
    KEY_EQUAL           := 61,       // Key: =
    KEY_A               := 65,       // Key: A | a
    KEY_B               := 66,       // Key: B | b
    KEY_C               := 67,       // Key: C | c
    KEY_D               := 68,       // Key: D | d
    KEY_E               := 69,       // Key: E | e
    KEY_F               := 70,       // Key: F | f
    KEY_G               := 71,       // Key: G | g
    KEY_H               := 72,       // Key: H | h
    KEY_I               := 73,       // Key: I | i
    KEY_J               := 74,       // Key: J | j
    KEY_K               := 75,       // Key: K | k
    KEY_L               := 76,       // Key: L | l
    KEY_M               := 77,       // Key: M | m
    KEY_N               := 78,       // Key: N | n
    KEY_O               := 79,       // Key: O | o
    KEY_P               := 80,       // Key: P | p
    KEY_Q               := 81,       // Key: Q | q
    KEY_R               := 82,       // Key: R | r
    KEY_S               := 83,       // Key: S | s
    KEY_T               := 84,       // Key: T | t
    KEY_U               := 85,       // Key: U | u
    KEY_V               := 86,       // Key: V | v
    KEY_W               := 87,       // Key: W | w
    KEY_X               := 88,       // Key: X | x
    KEY_Y               := 89,       // Key: Y | y
    KEY_Z               := 90,       // Key: Z | z
    KEY_LEFT_BRACKET    := 91,       // Key: [
    KEY_BACKSLASH       := 92,       // Key: '\'
    KEY_RIGHT_BRACKET   := 93,       // Key: ]
    KEY_GRAVE           := 96,       // Key: `
    // Function keys
    KEY_SPACE           := 32,       // Key: Space
    KEY_ESCAPE          := 256,      // Key: Esc
    KEY_ENTER           := 257,      // Key: Enter
    KEY_TAB             := 258,      // Key: Tab
    KEY_BACKSPACE       := 259,      // Key: Backspace
    KEY_INSERT          := 260,      // Key: Ins
    KEY_DELETE          := 261,      // Key: Del
    KEY_RIGHT           := 262,      // Key: Cursor right
    KEY_LEFT            := 263,      // Key: Cursor left
    KEY_DOWN            := 264,      // Key: Cursor down
    KEY_UP              := 265,      // Key: Cursor up
    KEY_PAGE_UP         := 266,      // Key: Page up
    KEY_PAGE_DOWN       := 267,      // Key: Page down
    KEY_HOME            := 268,      // Key: Home
    KEY_END             := 269,      // Key: End
    KEY_CAPS_LOCK       := 280,      // Key: Caps lock
    KEY_SCROLL_LOCK     := 281,      // Key: Scroll down
    KEY_NUM_LOCK        := 282,      // Key: Num lock
    KEY_PRINT_SCREEN    := 283,      // Key: Print screen
    KEY_PAUSE           := 284,      // Key: Pause
    KEY_F1              := 290,      // Key: F1
    KEY_F2              := 291,      // Key: F2
    KEY_F3              := 292,      // Key: F3
    KEY_F4              := 293,      // Key: F4
    KEY_F5              := 294,      // Key: F5
    KEY_F6              := 295,      // Key: F6
    KEY_F7              := 296,      // Key: F7
    KEY_F8              := 297,      // Key: F8
    KEY_F9              := 298,      // Key: F9
    KEY_F10             := 299,      // Key: F10
    KEY_F11             := 300,      // Key: F11
    KEY_F12             := 301,      // Key: F12
    KEY_LEFT_SHIFT      := 340,      // Key: Shift left
    KEY_LEFT_CONTROL    := 341,      // Key: Control left
    KEY_LEFT_ALT        := 342,      // Key: Alt left
    KEY_LEFT_SUPER      := 343,      // Key: Super left
    KEY_RIGHT_SHIFT     := 344,      // Key: Shift right
    KEY_RIGHT_CONTROL   := 345,      // Key: Control right
    KEY_RIGHT_ALT       := 346,      // Key: Alt right
    KEY_RIGHT_SUPER     := 347,      // Key: Super right
    KEY_KB_MENU         := 348,      // Key: KB menu
    // Keypad keys
    KEY_KP_0            := 320,      // Key: Keypad 0
    KEY_KP_1            := 321,      // Key: Keypad 1
    KEY_KP_2            := 322,      // Key: Keypad 2
    KEY_KP_3            := 323,      // Key: Keypad 3
    KEY_KP_4            := 324,      // Key: Keypad 4
    KEY_KP_5            := 325,      // Key: Keypad 5
    KEY_KP_6            := 326,      // Key: Keypad 6
    KEY_KP_7            := 327,      // Key: Keypad 7
    KEY_KP_8            := 328,      // Key: Keypad 8
    KEY_KP_9            := 329,      // Key: Keypad 9
    KEY_KP_DECIMAL      := 330,      // Key: Keypad :
    KEY_KP_DIVIDE       := 331,      // Key: Keypad /
    KEY_KP_MULTIPLY     := 332,      // Key: Keypad *
    KEY_KP_SUBTRACT     := 333,      // Key: Keypad -
    KEY_KP_ADD          := 334,      // Key: Keypad +
    KEY_KP_ENTER        := 335,      // Key: Keypad Enter
    KEY_KP_EQUAL        := 336,      // Key: Keypad =
    // Android key buttons
    KEY_BACK            := 4,        // Key: Android back button
    KEY_MENU            := 5,        // Key: Android menu button
    KEY_VOLUME_UP       := 24,       // Key: Android volume up button
    KEY_VOLUME_DOWN     := 25        // Key: Android volume down button
  );

 Image  = record
  Data: Pchar;
  Width, Height: longInt;
  Mipmaps: longInt;
  Format: PixelFormat;
 end;

 PImage = ^Image;

 Texture = record
  Id: longWord;
  Width, Height: longInt;
  Mipmaps: longInt;
  Format: PixelFormat;
 end;


  PTexture = ^Texture;

(* Fim Tipos *)

(* Constantes *)
const
  Branco: Color = (
    R: 255;
    G: 255;
    B: 255;
    A: 255;
  );
(* Fim Constantes *)

(* Janela *)
{$L libraylib.a}
procedure InitWindow (width: longInt; height: longInt; title: Pchar); cdecl; external;

{$L libraylib.a}
procedure CloseWindow (); cdecl; external;

{$L libraylib.a}
function WindowShouldClose (): Boolean; cdecl; external;

(* Fim Janela*)

(* Desenho *)
{$L libraylib.a}
procedure BeginDrawing (); cdecl; external;
{$L libraylib.a}
procedure EndDrawing (); cdecl; external;
{$L libraylib.a}
procedure ClearBackground (color: Color); cdecl; external;
{$L libraylib.a}
procedure DrawRectangleRec (rec: Rectangle; color: Color); cdecl; external;

(* Fim Desenho *)

(* Tempo *)
{$L libraylib.a}
procedure SetTargetFPS (fps: longInt); cdecl; external;
{$L libraylib.a}
function GetFrameTime (): single; cdecl; external;
{$L libraylib.a}
function GetTime (): double; cdecl; external;
(* Fim Tempo *)

(* Colisão *)
{$L libraylib.a}
function CheckCollisionRecs(rec1: Rectangle; rec2: Rectangle): boolean; cdecl; external;
(* Fim Colisão *)

(* Teclado *)
{$L libraylib.a}
function IsKeyPressed (key: KeyboardKey): boolean; cdecl; external;
{$L libraylib.a}
function IsKeyDown (key: KeyboardKey): boolean; cdecl; external;

(* Fim Teclado *)

(* Imagem *)

function BytesPerPixel (Format: PixelFormat): integer;

function ImageCreate (Width: longInt; Height: longInt; Format: PixelFormat): PImage;

procedure ImageDestroy (Image: PImage);

{$L libraylib.a}
procedure ImageClearBackground (Image: PImage; Color: Color); cdecl; external;

{$L libraylib.a}
procedure ImageDrawRectangleRec (Image: PImage; Rectangle: Rectangle; Color: Color); cdecl; external;
(* Fim Imagem *)

(* Textura *)

{$L libraylib.a}
function LoadTextureFromImage (Image: Image): Texture; cdecl; external;

{$L libraylib.a}
function IsTextureValid(Texture: Texture): boolean; cdecl; external;

{$L libraylib.a}
procedure UnloadTexture (Texture: Texture); cdecl; external;

{$L libraylib.a}
procedure UpdateTexture (Texture: Texture; Pixels: PChar); cdecl; external;

{$L libraylib.a}
procedure UpdateTextureRec (Texture: Texture; Rec: Rectangle; Pixels: Pchar ); cdecl; external;

(* Fim Textura *)

implementation

function BytesPerPixel (Format: PixelFormat): integer;
begin
 case Format of
    PIXELFORMAT_UNCOMPRESSED_GRAYSCALE: BytesPerPixel := 1; // 8 bit per pixel (no alpha)
    PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA: BytesPerPixel := 2;    // 8*2 bpp (2 channels)
    PIXELFORMAT_UNCOMPRESSED_R5G6B5: BytesPerPixel := 2;        // 16 bpp
    PIXELFORMAT_UNCOMPRESSED_R8G8B8: BytesPerPixel := 3;        // 24 bpp
    PIXELFORMAT_UNCOMPRESSED_R5G5B5A1: BytesPerPixel := 2;      // 16 bpp (1 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R4G4B4A4: BytesPerPixel := 2;      // 16 bpp (4 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R8G8B8A8: BytesPerPixel := 4;      // 32 bpp
    PIXELFORMAT_UNCOMPRESSED_R32: BytesPerPixel := 4;           // 32 bpp (1 channel - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32: BytesPerPixel := 12;     // 32*3 bpp (3 channels - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32A32: BytesPerPixel := 16; // 32*4 bpp (4 channels - float)
    PIXELFORMAT_UNCOMPRESSED_R16: BytesPerPixel := 2;           // 16 bpp (1 channel - half float)
    PIXELFORMAT_UNCOMPRESSED_R16G16B16: BytesPerPixel := 6; // 16*3 bpp (3 channels - half float)
    PIXELFORMAT_UNCOMPRESSED_R16G16B16A16: BytesPerPixel := 8;  // 16*4 bpp (4 channels - half float)
    PIXELFORMAT_COMPRESSED_DXT1_RGB: BytesPerPixel := 1;       // 4 bpp (no alpha)
    PIXELFORMAT_COMPRESSED_DXT1_RGBA: BytesPerPixel := 1;       // 4 bpp (1 bit alpha)
    PIXELFORMAT_COMPRESSED_DXT3_RGBA: BytesPerPixel := 1;       // 8 bpp
    PIXELFORMAT_COMPRESSED_DXT5_RGBA: BytesPerPixel := 1;       // 8 bpp
    PIXELFORMAT_COMPRESSED_ETC1_RGB: BytesPerPixel := 1;        // 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_RGB: BytesPerPixel := 1;        // 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA: BytesPerPixel := 1;   // 8 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGB: BytesPerPixel := 1;        // 4 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGBA: BytesPerPixel := 1;       // 4 bpp
    PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA: BytesPerPixel := 1;   // 8 bpp
    PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA: BytesPerPixel := 1;    // 2 bpp
 end; 
end;

function ImageCreate (Width: longInt; Height: longInt; Format: PixelFormat): PImage;
var
  Data: Pchar;
  Image: PImage;
begin
  Getmem (Data, PtrUInt (Width * Height) * PtrUInt (BytesPerPixel (Format)));
  if Data = nil then
  begin
      Image := nil; 
  end

  else
  begin
    New (Image);
    if Image = nil then
    begin
      Freemem (Data, PtrUInt (Width * Height) * PtrUInt (BytesPerPixel (Format)));
      ImageCreate := nil;
    end
    else
      Image^.Data := Data;
      Image^.Width := Width;
      Image^.Height := Height;
      Image^.Mipmaps := 1;
      Image^.Format := Format;
    end;
  //end;
  ImageCreate := Image;
end;

procedure ImageDestroy (Image: PImage);
begin
  if Image^.Data <> nil then
      Freemem (Image^.Data, PtrUInt (Image^.Width * Image^.Height) * PtrUInt (BytesPerPixel (Image^.Format)));
end;

end.
