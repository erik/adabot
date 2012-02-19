package body Adabot.Bot is

   function Create (Server : String; Port : GNAT.Sockets.Port_Type; Nick : String := "adabot")
                   return Connection is

      use GNAT.Sockets;
      C : Connection;
      NickUB : SU.Unbounded_String := SU.To_Unbounded_String(Nick);
   begin

      C.Address.Addr := Addresses (Get_Host_By_Name (Server));
      C.Address.Port := Port;
      C.Nick.Nick    := NickUB;

      return C;

   end Create;

   procedure Connect (Conn : in out Connection) is
      use GNAT.Sockets;
   begin
      if Conn.Connected then
         return;
      end if;

      GNAT.Sockets.Initialize;

      Create_Socket (Conn.Sock);
      Connect_Socket (Conn.Sock, Conn.Address);
      Conn.Connected := True;

   end Connect;

   procedure Disconnect (Conn : in out Connection) is
      use GNAT.Sockets;
   begin
      if not Conn.Connected then
         return;
      end if;

      Close_Socket (Conn.Sock);
      Conn.Connected := False;

   end Disconnect;

   procedure Identify (This : Connection) is
      User : String := SU.To_String ( This.Nick.Nick & " * * :" &
                                        This.Nick.Realname);
   begin
      This.Command (Cmd => "NICK", Args => SU.To_String (This.Nick.Nick));
      This.Command (Cmd => "USER", Args => User);
   end Identify;

   procedure Privmsg (This : Connection; Chan_Or_Nick, Message : String) is
   begin
      This.Command (Cmd => "PRIVMSG", Args => Chan_Or_Nick & ": " & Message);
   end Privmsg;

   procedure Join (This : Connection; Channel : String) is
   begin
      This.Command (Cmd => "JOIN", Args => Channel);
   end Join;

   procedure Command (This : Connection; Cmd, Args : String) is
   begin
      This.Send_Line (Cmd & " " & Args);
   end Command;

   procedure Send_Line (This : Connection; Line : String) is
   begin
      This.Send_Raw(Line & CRLF);
   end Send_Line;

   procedure Send_Raw (This : Connection; Raw : String) is
      use GNAT.Sockets;
      use Ada.Streams;

      Channel : Stream_Access;
   begin
      This.Should_Be_Connected;

      Channel := Stream (This.Sock);
      String'Write (Channel, Raw);

   end Send_Raw;

   procedure Read_Line (This : Connection; Buffer : out SU.Unbounded_String) is
      use GNAT.Sockets;
      use Ada.Streams;
      use Ada.Characters.Handling;

      Offset  : Stream_Element_Count;
      Data    : Stream_Element_Array (1 .. 1);
      Channel : Stream_Access;
   begin

      This.Should_Be_Connected;

      Channel := Stream (This.Sock);

      Loop
         Ada.Streams.Read(Channel.all, Data (1 .. 1), Offset);

         Exit when Character'Val (Data (1)) = ASCII.LF;

         if Character'Val (Data (1)) /= ASCII.CR then
            SU.Append (Source => Buffer, New_Item => (Character'Val (Data (1))));
         end if;

      End Loop;

   end Read_Line;

   -- private functions / procedures

   procedure Should_Be_Connected (This : Connection) is
   begin
      if This.Connected then
         return;
      end if;

      raise Not_Connected;

   end Should_Be_Connected;

end Adabot.Bot;
