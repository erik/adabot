with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with GNAT.String_Split;

with Adabot.Bot;
with Message;

package Commands is
   package SU renames Ada.Strings.Unbounded;
   package SF renames Ada.Strings.Fixed;

   subtype Bot is Adabot.Bot.Connection;
   subtype IrcMessage is Message.Message;

   procedure Install_Commands (Conn : in out Bot);

   procedure Join_On_Ident (Conn : Bot; Msg : IrcMessage);
   procedure Ping_Pong (Conn : Bot; Msg : IrcMessage);
   procedure Join_Channel (Conn : Bot; Msg : IrcMessage);

end Commands;
