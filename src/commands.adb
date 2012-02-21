package body Commands is

   procedure Install_Commands (Conn : in out Connection) is
   begin
      --  general commands
      Conn.On_Message ("001",      Join_On_Ident'Access);
      Conn.On_Message ("433",      Nick_In_Use'Access);
      Conn.On_Message ("PING",     Ping_Server'Access);
      Conn.On_Regexp  (".*",       Log_Line'Access);

      --  PRIVMSG commands
      Conn.On_Privmsg ("$join ",   Join_Channel'Access);
      Conn.On_Privmsg ("$part ",   Part_Channel'Access);
      Conn.On_Privmsg ("$ping",    Ping_Pong'Access);
   end Install_Commands;

   ----------------------------
   -- Begin general commands --
   ----------------------------

   procedure Join_On_Ident (Conn : in out Connection;
                            Msg  :        IrcMessage) is
      Channels : Bot.Unbounded_Vector.Vector
        := Conn.Get_Default_Channels;
   begin
      for I in Channels.First_Index .. Channels.Last_Index loop
         Conn.Join (SU.To_String (Channels.Element (I)));
      end loop;
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

   procedure Ping_Server (Conn : in out Connection;
                          Msg  :        Message.Message) is
   begin
      Conn.Command (Cmd => "PONG", Args => SU.To_String (Msg.Args));
   end Ping_Server;

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

      Channel : String
        := SU.To_String (Msg.Privmsg.Target);

      Target : String
        := SU.Slice (Msg.Privmsg.Content,
                     SU.Index (Msg.Privmsg.Content, " "),
                     SU.Length (Msg.Privmsg.Content));
   begin

      if Is_Admin (Conn, Msg.Sender) then
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

      if Is_Admin (Conn, Msg.Sender) then
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

   ------------------------------
   -- Begin private functions  --
   ------------------------------

   --  XXX: This function would probably fit better in with the Bot package
   function Is_Admin (Conn   : in Connection;
                      Sender :    SU.Unbounded_String)
                     return Boolean is
      use SU;

      Admins : Bot.Unbounded_Vector.Vector
        := Conn.Get_Administrators;

      Admin : SU.Unbounded_String;

   begin
      for I in Admins.First_Index .. Admins.Last_Index loop
         Admin := Admins.Element (I);

         Ada.Text_IO.Put_Line (SU.To_String (Admin & " with " & Sender));

         if SU.Index (Sender, SU.To_String (Admin)) = 1 then
            return True;
         end if;
      end loop;

      return False;
   end Is_Admin;


end Commands;
