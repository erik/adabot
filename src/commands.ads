with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with GNAT.String_Split;
with GNAT.Regpat;

with Adabot.Bot;
with Message;

package Commands is
   package SU renames Ada.Strings.Unbounded;
   package SF renames Ada.Strings.Fixed;
   package Regexp renames GNAT.Regpat;

   subtype Bot is Adabot.Bot.Connection;
   subtype IrcMessage is Message.Message;

   procedure Install_Commands (Conn : in out Bot);

   --  General commands.
   procedure Join_On_Ident (Conn : Bot;
                            Msg  : IrcMessage);
   procedure Ping_Pong (Conn : Bot;
                        Msg  : IrcMessage);
   procedure Log_Line (Conn : Bot;
                       Msg  : IrcMessage);

   --  PRIVMSG commands.
   procedure Join_Channel (Conn : Bot;
                           Msg  : IrcMessage);

end Commands;
