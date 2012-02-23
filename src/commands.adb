package body Commands is

   procedure Install_Bot_Commands (Conn : in out Connection) is
   begin

      Irc.Commands.Install_Commands (Conn);

      --  PRIVMSG commands
      Conn.On_Privmsg ("$join ",   Join_Channel'Access);
      Conn.On_Privmsg ("$part ",   Part_Channel'Access);
      Conn.On_Privmsg ("$ping",    Ping_Pong'Access);
      Conn.On_Privmsg ("$slowpoke", Slowpoke'Access);

   end Install_Bot_Commands;

   ----------------------------
   -- Begin PRIVMSG commands --
   ----------------------------

   procedure Join_Channel (Conn : in out Connection;
                           Msg  :        IrcMessage) is

      Channel : String
        := SU.To_String (Msg.Privmsg.Target);

      Target : String
        := SU.Slice (Msg.Privmsg.Content,
                     SU.Index (Msg.Privmsg.Content, " "),
                     SU.Length (Msg.Privmsg.Content));
   begin

      if Conn.Is_Admin (Msg.Sender) then
         Conn.Privmsg (Channel, "yeah, sure");
         Conn.Join (Target);
      else
         Conn.Privmsg (Channel, "absolutely not.");
      end if;
   end Join_Channel;

   procedure Part_Channel (Conn : in out Connection;
                           Msg  :        IrcMessage) is
      Channel : String
        := SU.To_String (Msg.Privmsg.Target);

      Target : String
        := SU.Slice (Msg.Privmsg.Content,
                     SU.Index (Msg.Privmsg.Content, " "),
                     SU.Length (Msg.Privmsg.Content));
   begin

      if Conn.Is_Admin (Msg.Sender) then
         Conn.Privmsg (Channel, "yeah, sure");
         Conn.Command (Cmd => "PART", Args => Target);
      else
         Conn.Privmsg (Channel, "absolutely not.");
      end if;
   end Part_Channel;

   procedure Ping_Pong (Conn : in out Connection;
                        Msg  :        IrcMessage) is

      Nick : String
        := SU.Slice (Msg.Sender, 1, SU.Index (Msg.Sender, "!") - 1);

   begin
      Conn.Privmsg (SU.To_String (Msg.Privmsg.Target), Nick & ": pong");
   end Ping_Pong;


   procedure Slowpoke (Conn : in out Connection;
                       Msg  :        IrcMessage) is
   begin
      delay 5.0;
      Conn.Privmsg (SU.To_String (Msg.Privmsg.Target),
                    "...poke.");
   end Slowpoke;

end Commands;
