package body Message is

   function Parse_Line (Line : in String) return Message is
      Msg    : Message;
      Index  : Natural  := Line'First + 1;
      Start, Finish : Natural := 0;

      package SF renames Ada.Strings.Fixed;

      procedure Read_Word is
         Next_Ws : Natural := SF.Index (Line, " ", Index);
      begin
         Start := Index;

         if Next_WS >= Line'Last then
            raise Message_Parse_Error;
         end if;

         Finish := Next_Ws - 1;
         Index := Next_Ws + 1;
      end Read_Word;

   begin

      if Line (Line'First) /= ':' then
         raise Message_Parse_Error;
      end if;

      Read_Word;
      Msg.Sender  := SU.To_Unbounded_String (Line (Start .. Finish));

      Read_Word;
      Msg.Command := SU.To_Unbounded_String (Line (Start .. Finish));

      Msg.Args    := SU.To_Unbounded_String
        (Line (Finish + 2 .. Line'Last));

      return Msg;
   end Parse_Line;

   procedure Print (This : Message) is
      use Ada.Text_IO;
   begin
      Ada.Text_IO.Put_Line
        (SU.To_String (This.Sender & "» " & This.Command & " " & This.Args));
   end Print;

end Message;

