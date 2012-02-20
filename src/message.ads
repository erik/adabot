with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;

with Ada.Text_IO;

package Message is

   package SU renames Ada.Strings.Unbounded;

   use type SU.Unbounded_String;

   type Message is tagged record
      Sender  : SU.Unbounded_String;
      Command : SU.Unbounded_String;
      Args    : SU.Unbounded_String;
   end record;

   -- parse a given IRC line
   function Parse_Line (Line : in String) return Message;

   -- give a nicer representation of the message
   procedure Print (This : Message);

   Parse_Error : exception;

end Message;
