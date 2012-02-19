with Ada.Strings.Unbounded;
with Ada.Text_IO;

with Adabot.Bot;
with Message;

use Ada.Text_IO;

procedure Main is

   package TIO renames Ada.Text_IO;
   package SU renames Ada.Strings.Unbounded;

   use type SU.Unbounded_String;

   Bot    : Adabot.Bot.Connection;
   Buffer : SU.Unbounded_String;
   Msg    : Message.Message;
begin

   Bot := Adabot.Bot.Create("irc.tenthbit.net", 6667);
   Bot.Connect;

   Bot.Identify;

   loop
      Buffer := SU.To_Unbounded_String("");
      Bot.Read_Line(Buffer);

      exit when SU.Length(Buffer) <= 1;

      Msg := Message.Parse_Line (SU.To_String (Buffer));
      Msg.Print;

   end loop;

   Bot.Disconnect;

end Main;

