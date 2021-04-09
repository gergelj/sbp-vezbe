/*
Obrisati radnika čiji matični broj je unet preko tastature.
Na konzoli prikazati koliko je radnika obrisano.
*/

begin
    delete from radnik where mbr = &mbr;
    
    dbms_output.put_line('Obrisano je ' || sql%rowcount || ' radnika');
end;