package body Commands is

   procedure Install_Commands (Conn : in out Adabot.Bot.Connection) is
      subtype Proc is Adabot.Bot.Command_Proc;

      Join_Access : Proc := Join_On_Ident'Access;
      Ping_Access : Proc := Ping_Pong'Access;
      Join_Chan_Access : Proc := Join_Channel'Access;
   begin

      Conn.Add_Command ("001",  Join_Access);
      Conn.Add_Command ("PING", Ping_Access);
      Conn.Add_Privmsg_Command ("join", Join_Chan_Access);

   end Install_Commands;

   procedure Join_On_Ident (Conn : Adabot.Bot.Connection;
                            Msg  : Message.Message) is
   begin
      Conn.Join ("#bots");
      Conn.Privmsg ("#bots", "testin'");
   end Join_On_Ident;

   procedure Ping_Pong (Conn : Adabot.Bot.Connection;
                        Msg  : Message.Message) is
   begin
      Conn.Command (Cmd => "PONG", Args => SU.To_String (Msg.Args));
   end Ping_Pong;

   procedure Join_Channel (Conn : Bot;
                           Msg  : IrcMessage) is
      Args : String := SU.To_String (Msg.Args);

      Channel : String
        := Args (Args'First .. SF.Index (Args, " ", Args'First) - 1);

      Target : String
        := Args (SF.Index (Args, ":", Args'First) + 1 + 4 .. Args'Last);

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
