with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with Ada.Streams;

with GNAT.Sockets;
with GNAT.String_Split;
with GNAT.Regpat;

with Irc.Bot;
with Irc.Message;
with Irc.Commands;

package Commands is
   package IO renames Ada.Text_IO;
   package SU renames Ada.Strings.Unbounded;
   package SF renames Ada.Strings.Fixed;
   package Regexp renames GNAT.Regpat;

   subtype Connection is Irc.Bot.Connection;
   subtype IrcMessage is Irc.Message.Message;

   procedure Install_Bot_Commands (Conn : in out Connection);

   --  PRIVMSG commands.
   procedure Join_Channel (Conn : in out Connection;
                           Msg  :        IrcMessage);
   procedure Part_Channel (Conn : in out Connection;
                           Msg  :        IrcMessage);
   procedure Ping_Pong    (Conn : in out Connection;
                           Msg  :        IrcMessage);
   procedure Slowpoke     (Conn : in out Connection;
                           Msg  :        IrcMessage);

end Commands;
