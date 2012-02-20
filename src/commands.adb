package body Commands is

   procedure Install_Commands (Conn : in out Connection) is
   begin
      --  general commands
      Conn.On_Message ("001",      Join_On_Ident'Access);
      Conn.On_Message ("433",      Nick_In_Use'Access);
      Conn.On_Message ("PING",     Ping_Pong'Access);
      Conn.On_Regexp  (".*",       Log_Line'Access);

      --  PRIVMSG commands
      Conn.On_Privmsg ("$join ", Join_Channel'Access);

   end Install_Commands;

   ----------------------------
   -- Begin general commands --
   ----------------------------

   procedure Join_On_Ident (Conn : in out Connection;
                            Msg  :        IrcMessage) is
   begin
      Conn.Join ("#bots");
      Conn.Privmsg ("#bots", "testin'");
   end Join_On_Ident;

   procedure Nick_In_Use (Conn : in out Connection;
                          Msg  :        IrcMessage) is
      use SU;

      Attr     : Bot.Nick_Attributes := Conn.Get_Attributes;
      New_Nick : SU.Unbounded_String := Attr.Nick & "_";
   begin
      Attr.Nick := New_Nick;
      Conn.Command (Cmd => "NICK", Args => SU.To_String (New_Nick));

      Conn.Set_Attributes (Attr);
   end Nick_In_Use;

   procedure Ping_Pong (Conn : in out Connection;
                        Msg  :        Message.Message) is
   begin
      Conn.Command (Cmd => "PONG", Args => SU.To_String (Msg.Args));
   end Ping_Pong;

   procedure Log_Line (Conn : in out Connection;
                       Msg  :        IrcMessage) is
   begin
      Msg.Print;
   end Log_Line;

   ----------------------------
   -- Begin PRIVMSG commands --
   ----------------------------

   procedure Join_Channel (Conn : in out Connection;
                           Msg  :        IrcMessage) is
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
