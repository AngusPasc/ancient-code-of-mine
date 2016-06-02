unit Dialogy;

interface

procedure DialogPridajPolozku( Skupina : Word );
procedure DialogPridajSkupinu( Zrusit : Boolean );

implementation

uses FormPridatPolozku, FormPridatSkupinu, Data;

procedure DialogPridajPolozku( Skupina : Word );
var Polozka : TPolozka;
begin
  if PridatPolozku.ShowModal = 1 then
    begin
      Polozka.Cislo := PridatPolozku.EditCislo.Text;
      Polozka.Nazov := PridatPolozku.EditNazov.Text;
      Polozka.Seriove := PridatPolozku.EditSeriove.Text;
      Polozka.Prompt := PridatPolozku.EditPrompt.Text;
      PridajPolozku( Polozka );
    end; 
end;

procedure DialogPridajSkupinu( Zrusit : Boolean );
begin
  if PridatSkupinu.ShowModal = 1 then
    PridajSkupinu( PridatSkupinu.EditPridatSkupinu.Text );
end;

end.
