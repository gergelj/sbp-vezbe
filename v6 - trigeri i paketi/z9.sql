/*
Kreirati triger koji pri upisu i modifikaciji obeležja BRC tabele Radproj, dozvoljava samo upis celobrojnih vrednosti od 1 do 40. Svaku pozitivnu vrednost koja je izvan ovog opsega treba postaviti na vrednost 40. Za negativnu vrednost izazvati izuzetak sa odgovarajućom porukom o grešci.
*/

create or replace trigger TR_Radproj_BRC
before insert or update of brc
on Radproj
for each row
declare
    min_val NUMBER(1) := 1;
    max_val NUMBER(2) := 40;
    neg_num_ex EXCEPTION;
begin
    if :new.brc < min_val then
        raise neg_num_ex;
    elsif :new.brc > max_val then
        :new.brc := max_val;
    else
        :new.brc := ROUND(:new.brc);
    end if;
exception
    when neg_num_ex then
        Raise_application_error(-20001, 'Uneli ste vrednost manje od ' || to_char(min_val) || ' za obelezje BRC');
end TR_Radproj_BRC;