with GNAT.Sockets;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

with Message;

private with Ada.Streams;
private with Ada.Characters.Latin_1;
private with Ada.Characters.Handling;

package Adabot.Bot is
   package SU renames Ada.Strings.Unbounded;
   package TIO renames Ada.Text_IO;

   use type SU.Unbounded_String;

   type Connection is tagged private;

   function Create (Server : String;
                    Port   : GNAT.Sockets.Port_Type;
                    Nick   : String                 := "adabot")
                   return Connection;

   procedure Connect (Conn : in out Connection);
   procedure Disconnect (Conn : in out Connection);

   procedure Identify (This : Connection);

   procedure Privmsg (This                  : Connection;
                      Chan_Or_Nick, Message : String);

   procedure Join (This    : Connection;
                   Channel : String);

   procedure Command (This      : Connection;
                      Cmd, Args : String);

   procedure Send_Line (This : Connection;
                        Line : String);

   procedure Send_Raw (This : Connection;
                       Raw  : String);

   procedure Read_Line (This   :     Connection;
                        Buffer : out SU.Unbounded_String);

private

   Socket_Read_Error : exception;
   Not_Connected     : exception;

   CRLF : constant String := Ada.Characters.Latin_1.CR & Ada.Characters.Latin_1.LF;

   type Nick_Attributes is
      record
         Nick      : SU.Unbounded_String := SU.To_Unbounded_String("adabot");
         Realname  : SU.Unbounded_String := SU.To_Unbounded_String("adabot");
         Password  : SU.Unbounded_String;
      end record;

   type Connection is tagged record
      Sock      : GNAT.Sockets.Socket_Type;
      Address   : GNAT.Sockets.Sock_Addr_Type;
      Connected : Boolean := False;
      Nick      : Nick_Attributes;
   end record;

   -- raises Not_Connected unless the connection is active
   procedure Should_Be_Connected (This : Connection);

end Adabot.Bot;
