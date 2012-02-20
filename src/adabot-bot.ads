with GNAT.Sockets;
with GNAT.Regpat;

with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Containers.Vectors;

with Message;

private with Ada.Streams;
private with Ada.Characters.Latin_1;
private with Ada.Characters.Handling;

package Adabot.Bot is
   package SU renames Ada.Strings.Unbounded;
   package SF renames Ada.Strings.Fixed;

   package TIO renames Ada.Text_IO;
   package Regexp renames GNAT.Regpat;

   use Ada.Containers;

   use type SU.Unbounded_String;

   type Connection is tagged private;
   type Command_Proc is access procedure (Conn : Connection;
                                          Msg  : Message.Message);

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

   procedure On_Message (This  : in out Connection;
                         OnMsg : String;
                         Func  : Command_Proc);

   procedure On_Regexp (This     : in out Connection;
                        OnRegexp : Regexp.Pattern_Matcher;
                        Func     : Command_Proc);

   procedure On_Privmsg (This  : in out Connection;
                         OnMsg : String;
                         Func  : Command_Proc);

   procedure Do_Message (This : in out Connection;
                         Msg  : Message.Message);

   ---------------------------
   --  Private declarations --
   ---------------------------

private

   Socket_Read_Error : exception;
   Not_Connected     : exception;

   CRLF : constant String :=
     Ada.Characters.Latin_1.CR & Ada.Characters.Latin_1.LF;

   type Command_Pair is record
      Func  : Command_Proc;
      Regex : Regexp.Pattern_Matcher (1024);
   end record;

   package Command_Vector is new Vectors (Natural, Command_Pair);

   type Nick_Attributes is
      record
         Nick      : SU.Unbounded_String := SU.To_Unbounded_String ("adabot");
         Realname  : SU.Unbounded_String := SU.To_Unbounded_String ("adabot");
         Password  : SU.Unbounded_String;
      end record;

   type Connection is tagged record
      Sock      : GNAT.Sockets.Socket_Type;
      Address   : GNAT.Sockets.Sock_Addr_Type;
      Connected : Boolean := False;
      Nick      : Nick_Attributes;
      Commands  : Command_Vector.Vector;
      Privmsg_Commands  : Command_Vector.Vector;
   end record;

   --  Provides a simple runtime check to guarantee that the
   --  given Connection is active before trying to send / receive.
   --  raises Not_Connected unless the connection is active.
   procedure Should_Be_Connected (This : Connection);

   procedure Privmsg_Command_Hook (This : Connection;
                                   Msg  : Message.Message);

end Adabot.Bot;
