with Ada.Strings.Unbounded;
with Ada.Text_IO;

with Bot;
with Message;
with Commands;

use Ada.Text_IO;

procedure Adabot is

   package TIO renames Ada.Text_IO;
   package SU renames Ada.Strings.Unbounded;

   subtype Connection is Bot.Connection;

   use type SU.Unbounded_String;

   Conn   : Bot.Connection;
   Buffer : SU.Unbounded_String;
   Msg    : Message.Message;

begin

   Conn := Bot.Create ("irc.tenthbit.net", 6667);

   Conn.Add_Administrator ("boredomist!");
   Conn.Add_Default_Channel ("#bots");
   Conn.Add_Default_Channel ("#asdf");

   Commands.Install_Commands (Conn);
   Conn.Connect;
   Conn.Identify;

   loop
      Buffer := SU.To_Unbounded_String ("");
      Conn.Read_Line (Buffer);

      exit when SU.Length (Buffer) <= 1;

      begin
         Msg := Message.Parse_Line (SU.To_String (Buffer));
         Conn.Do_Message (Msg);

      exception
         when Message.Parse_Error =>
            Put_Line ("Failed to parse line: " & SU.To_String (Buffer));
      end;
   end loop;

   Conn.Disconnect;

end Adabot;

