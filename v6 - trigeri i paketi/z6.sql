/*
Formirati paket procedura i funkcija za rad s tabelom Radproj. Treba obezbediti sledeću funkcionalnost, putem
poziva odgovarajućih funkcija, ili procedura:
– selektovanje jedne torke iz tabele, saglasno zadatoj vrednosti ključa Spr+Mbr,
– dodavanje jedne nove torke u tabelu, koja se prenosi kao parametar,
– brisanje torke iz tabele, saglasno zadatoj vrednosti ključa Spr+Mbr i
– modifikacija torke u tabeli, saglasno zadatoj vrednosti ključa Spr+Mbr i zadatoj vrednosti za obeležje koje se modifikuje.

Korisnik treba da ima obezbeđenu indikaciju uspešnosti svake od navedenih operacija.
*/

create or replace package PKG_Radproj is
    function F_select(p_spr in Radproj.spr%type, p_mbr in Radproj.mbr%type) return Radproj%rowtype;
    function F_insert(p_radproj in Radproj%rowtype) return boolean;
    function F_delete(p_spr in Radproj.spr%type, p_mbr in Radproj.mbr%type) return boolean;
    function F_update(p_radproj in Radproj%rowtype) return boolean;
end PKG_Radproj;

create or replace package body PKG_Radproj is
    function F_select(p_spr in Radproj.spr%type, p_mbr in Radproj.mbr%type) return Radproj%rowtype is
        ret_val Radproj%rowtype;
    begin
        select * into ret_val
        from Radproj
        where spr = p_spr and mbr = p_mbr;
        
        return ret_val;
    exception
        when NO_DATA_FOUND then
            return null;
    end;
    
    function F_insert(p_radproj in Radproj%rowtype) return boolean is
    begin
        insert into radproj values (p_radproj.spr, p_radproj.mbr, p_radproj.brc);
        return true;
    exception
        when others then
            return false;
    end;
    
    function F_delete(p_spr in Radproj.spr%type, p_mbr in Radproj.mbr%type) return boolean is
    begin
        delete from radproj
        where spr = p_spr and mbr = p_mbr;
        return true;
    exception
        when others then
            return false;
    end;
    
    function F_update(p_radproj in Radproj%rowtype) return boolean is
    begin
        update radproj set brc = p_radproj.brc, mbr = p_radproj.mbr, spr = p_radproj.spr
            where spr = p_radproj.spr and mbr = p_radproj.mbr;
        return true;
    exception
        when others then
            return false;
    end;
end PKG_Radproj;