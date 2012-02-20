package body Message is

   function Parse_Line (Line : in String) return Message is
      Msg    : Message;
      Index  : Natural  := Line'First + 1;
      Start, Finish : Natural := 0;

      package SF renames Ada.Strings.Fixed;

      procedure Read_Word;

      procedure Read_Word is
         Next_WS : Natural := SF.Index (Line, " ", Index);
      begin
         Start := Index;

         if Next_WS > Line'Last then
            raise Parse_Error;
         end if;

         Finish := Next_WS - 1;
         Index := Next_WS + 1;
      end Read_Word;

   begin

      if Line (Line'First) /= ':' then

         if SF.Index (Line, "PING", Line'First) = Line'First then
            Msg.Sender := SU.To_Unbounded_String ("<server>");
            Msg.Command := SU.To_Unbounded_String ("PING");
            Msg.Args := SU.To_Unbounded_String
              (Line (Line'First + 6 .. Line'Last));

            return Msg;
         end if;

         raise Parse_Error;
      end if;

      Read_Word;
      Msg.Sender  := SU.To_Unbounded_String (Line (Start .. Finish));

      Read_Word;
      Msg.Command := SU.To_Unbounded_String (Line (Start .. Finish));

      Msg.Args    := SU.To_Unbounded_String
        (Line (Finish + 2 .. Line'Last));

      if Msg.Command = "PRIVMSG" then
         Msg.Parse_Privmsg;
      end if;

      return Msg;
   end Parse_Line;

   procedure Print (This : Message) is
      use Ada.Text_IO;
   begin
      Ada.Text_IO.Put_Line
        (SU.To_String
           (This.Sender & "» " & This.Command & " " & This.Args));
   end Print;


   procedure Parse_Privmsg (Msg : in out Message) is

      Args   : String
        := SU.To_String (Msg.Args);

      Target : String
        := Args (Args'First .. SF.Index (Args, " ", Args'First) - 1);

      Content : String
        := Args (SF.Index (Args, ":", Args'First) ..  Args'Last);

   begin

      Msg.Privmsg.Target  := SU.To_Unbounded_String (Target);
      Msg.Privmsg.Content := SU.To_Unbounded_String (Content);

   end Parse_Privmsg;

end Message;

