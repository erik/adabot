with Ada.Strings.Unbounded;
with Ada.Text_IO;

with Adabot.Bot;
with Message;
with Commands;

use Ada.Text_IO;

procedure Main is

   package TIO renames Ada.Text_IO;
   package SU renames Ada.Strings.Unbounded;

   subtype Connection is Adabot.Bot.Connection;

   use type SU.Unbounded_String;

   Bot    : Adabot.Bot.Connection;
   Buffer : SU.Unbounded_String;
   Msg    : Message.Message;

begin

   Bot := Adabot.Bot.Create("irc.tenthbit.net", 6667);

   Commands.Install_Commands (Bot);

   Bot.Connect;

   Bot.Identify;

   loop
      Buffer := SU.To_Unbounded_String("");
      Bot.Read_Line(Buffer);

      exit when SU.Length(Buffer) <= 1;

      begin
         Msg := Message.Parse_Line (SU.To_String (Buffer));
         Bot.Do_Message (Msg);

      exception
         when Message.Parse_Error =>
            Put_Line ("Failed to parse line: " & SU.To_String (Buffer));
      end;

      Msg.Print;

   end loop;

   Bot.Disconnect;

end Main;

