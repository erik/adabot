with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with GNAT.String_Split;
with GNAT.Regpat;

with Bot;
with Message;

package Commands is
   package SU renames Ada.Strings.Unbounded;
   package SF renames Ada.Strings.Fixed;
   package Regexp renames GNAT.Regpat;

   subtype Connection is Bot.Connection;
   subtype IrcMessage is Message.Message;

   procedure Install_Commands (Conn : in out Connection);

   --  General commands.
   procedure Join_On_Ident (Conn : in out Connection;
                            Msg  :        IrcMessage);
   procedure Nick_In_Use   (Conn : in out Connection;
                            Msg  :        IrcMessage);
   procedure Ping_Server   (Conn : in out Connection;
                            Msg  :        IrcMessage);
   procedure Log_Line      (Conn : in out Connection;
                            Msg  :        IrcMessage);

   --  PRIVMSG commands.
   procedure Join_Channel (Conn : in out Connection;
                           Msg  :        IrcMessage);
   procedure Ping_Pong    (Conn : in out Connection;
                           Msg  :        IrcMessage);

end Commands;
