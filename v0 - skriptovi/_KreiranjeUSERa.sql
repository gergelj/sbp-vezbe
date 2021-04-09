 create user sistemibaza identified by ftn
    default tablespace users temporary tablespace TEMP;
    
    
    grant connect, resource to sistemibaza;
    
    grant create table to sistemibaza;

    grant create view to sistemibaza;

    grant create procedure to sistemibaza;

    grant create synonym to sistemibaza;

    grant create sequence to sistemibaza;

    grant select on dba_rollback_segs to sistemibaza;

    grant select on dba_segments to sistemibaza;

	grant unlimited tablespace to sistemibaza;
