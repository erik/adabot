package body Commands is

   procedure Install_Commands (Conn : in out Bot) is
      subtype Proc is Adabot.Bot.Command_Proc;

      Pat : Regexp.Pattern_Matcher (1024);

   begin
      Regexp.Compile (Pat, ".*");

      --  general commands
      Conn.On_Message ("001",      Join_On_Ident'Access);
      Conn.On_Message ("PING",     Ping_Pong'Access);
      Conn.On_Regexp  (Pat, Log_Line'Access);

      --  PRIVMSG commands
      Conn.On_Privmsg ("$join ", Join_Channel'Access);

   end Install_Commands;

   ----------------------------
   -- Begin general commands --
   ----------------------------

   procedure Join_On_Ident (Conn : Bot;
                            Msg  : Message.Message) is
   begin
      Conn.Join ("#bots");
      Conn.Privmsg ("#bots", "testin'");
   end Join_On_Ident;

   procedure Ping_Pong (Conn : Bot;
                        Msg  : Message.Message) is
   begin
      Conn.Command (Cmd => "PONG", Args => SU.To_String (Msg.Args));
   end Ping_Pong;

   procedure Log_Line (Conn : Bot;
                       Msg  : IrcMessage) is
   begin
      Msg.Print;
   end Log_Line;

   ----------------------------
   -- Begin PRIVMSG commands --
   ----------------------------

   procedure Join_Channel (Conn : Bot;
                           Msg  : IrcMessage) is
      Content : String := SU.To_String (Msg.Privmsg.Content);

      Channel : String
        := SU.To_String (Msg.Privmsg.Target);

      Target  : String
        := Content (SF.Index (Content, " ", Content'First) ..
                      Content'Last);

      Sender : String := SU.To_String (Msg.Sender);
   begin

      if SF.Index (Sender, "boredomist!", Sender'First) /= Sender'First then
         Conn.Privmsg (Channel, "absolutely not.");
      else
         Conn.Privmsg (Channel, "yeah, sure");
         Conn.Join (Target);
      end if;
   end Join_Channel;

end Commands;
