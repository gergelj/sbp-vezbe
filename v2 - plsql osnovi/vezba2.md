# Vežba 2 - Oracle PL SQL

## Uvod

- PL/SQL - jezik III generacije
- PL/SQL - predstavlja proceduralno proširenje SQL-a
- PL/SQL se može koristiti iz različitih okruženja
  - SQL*Plus
  - Oracle Developer Suite (Forms, Reports, Oracle Portal, Oracle Discoverer
  - SQL Developer

### Tipovi PL/SQL blokova
  - anonimni (netipizovani)
  - tipizovani (procedura, funkcija)

### Osnovni leksički elementi 

- Skup simbola
  - A-Z, a-z, 0-9, (, ), &, <, >, =, !, ;, ., ', @, %, ^, {, }, [, ], _, ", #, ?, +, -, *, /
- Delimiteri
  - (, ), %, <>, !=, *, **, :=, itd.
- Literali
  - numerički (114, 12.5, -1.E3)
  - karakter('O"vo je string')
  - logički (TRUE, FALSE, NULL)
- Komentari:
  - jednolinijski (--)
  - višelinijski (/* */)
- Identifikatori
  - do 30 znakova, prvi znak mora biti slovo.
  - dozvoljeni karakteri: slova, brojevi, _, #, $.

### Tipovi podataka

- Skalarni (osnovni)
  - karakter
    - `VARCHAR2` (do 32767 bajtova)
    - `CHAR` (do 32767, default 1)
    - `LONG` (do 32760)
    - `NVARCHAR2`, `NCHAR`
  - numerički
    - `NUMBER(p,s)` (decimalni tip, od 1E-130 do 10E125 )
    - `BINARY_INTEGER` (4B integer, u rasponu od –(2E31-1) do 2E31-1)
    - `PLS_INTEGER` (4B "pakovani" integer, u rasponu od –(2E31-1) do 2E31-1)
  - datumski
    - `DATE`
    - `TIMESTAMP`
    - `TIMESTAMP WITH TIME ZONE`
    - `TIMESTAMP WITH LOCAL TIME ZONE`
    - `INTERVAL DAY TO SECOND`
    - `INTERVAL YEAR TO MONTH`
  - logički
    - `BOOLEAN`
- Složeni (Composite)
  - `RECORD`
  - `TABLE`
  - `VARRAY`
- Pokazivački (Reference)
  - `REF CURSOR`, REF objektni_tip
  - `ROWID`, `RAW`
- LOB
  - `BFILE` (fajl do 4GB)
  - `BLOB` (do 4GB)
  - `CLOB` (do 4GB), `NCLOB` (do 4GB)
  - `RAW` (do 32760), `LONG RAW` (do 32760)


## Osnovne PL/SQL naredbe

### "Prazna" naredba
- NULL
- svaka BEGIN - END sekcija mora da ima makar jednu naredbu

```sql
BEGIN
    NULL;
END;
```

### Naredba dodele vrednosti

```
variable := expression
```

### Prikaz vrednosti izraza

PL/SQL na nivou DBMS-a i SQL*Plus-a - kombinacija:
- `SET SERVEROUTPUT ON` i
- `DBMS_OUTPUT.PUT_LINE(message)`

```sql
DBMS_OUTPUT.PUT_LINE('x = ' || var_x);
```

### Unos kroz podrazumevani prompt

Dve varijante:
- `&promenjiva` - za svaku promenjivu zahteva se unos vrednosti
- `&&promenjiva` - unos se zahteva samo jednom za vreme trenutne sesija
  - ako je potrebno obrisati vrednost potrebno je izvršiti naredbu `UNDEFINE promenjiva`

Definisanje drugačije poruke na konzoli:

```sql
ACCEPT v_prz PROMPT 'Unesite prezime: '

BEGIN
    DBMS_OUTPUT.PUT_LINE('Prezime je: ' || '&v_prz');
END;
```

## Deklarisanje PL/SQL promenljivih i konstanti

```
identifier [CONSTANT] datatype [NOT NULL] [:= | DEFAULT expr]

identifier [CONSTANT] {variable%TYPE | table.column%TYPE}[NOT NULL] [:= | DEFAULT expr]
```

> Primer

```sql
DECLARE
    V_prom1 NUMBER(2);
    V_prom2 CHAR;
    V_prom3 VARCHAR2(40) := '';
    V_prom4 VARCHAR2(40) NOT NULL := '';
    V_prom5 VARCHAR2(40) NOT NULL DEFAULT '';
    V_prom6 DATE NOT NULL := SYSDATE + 2;
    C_prom7 CONSTANT DATE := SYSDATE;
    V_prom8 V_Prom6%TYPE := TO_DATE('01.01.2001', 'DD.MM.YYYY');
    V_prom9 Radnik.Mbr%TYPE := 100;
BEGIN
    NULL;
END
```

## Selekcioni izrazi (Izrazi IF tipa)

```
CASE [expr] WHEN comparison_expr1 THEN return_expr1
    [WHEN comparison_expr2 THEN return_expr2
      WHEN comparison_exprn THEN return_exprn
    ]
    [ELSE else_expr
    ]
END;
```

> Primer

```sql
CASE Status
    WHEN 'A' THEN 'Odlican'
    WHEN 'B' THEN 'Zadovoljava'
    ELSE 'Ne zadovoljava'
END;

CASE 
    WHEN Status = 'A' THEN 'Odlican'
    WHEN Status = 'B' THEN 'Zadovoljava'
    ELSE 'Ne zadovoljava'
END;
```

## Direktni način upotrebe SELECT naredbe

SELECT naredba mora da vrati **jedan i samo jedan red**, u protivnom dolazi do pokretanja odgovarajućih izuzetaka (`TOO_MANY_ROWS`/`NO_DATA_FOUND`)

```
SELECT select_list
INTO {variable[, variable]...
        | record_variable}
FROM table
[WHERE condition]
...
```

## Implicitni SQL kursor

DML naredbama, koje se izvršavaju u PL/SQL bloku, dodeljuju se kursorska područja (kursori), čiji je programski naziv SQL.

### Funkcije ispitivanja statusa implicitnog SQL kursora

- `SQL%FOUND`
    - TRUE, ako je bar jedan red bio predmet poslednje DML operacije, inače FALSE
- `SQL%NOTFOUND`
    - TRUE, ako ni jedan red nije bio predmet poslednje DML operacije, inače FALSE
- `SQL%ROWCOUNT`
    - broj redova, koji su bili predmet poslednje DML operacije
- `SQL%ISOPEN`
    - uvek ima vrednost FALSE.
    - Upravljanje (otvaranje i zatvaranje) implicitnim kursorima je uvek automatsko. Neposredno nakon svake DML operacije, SQL kursorsko područje se automatski zatvori.

## Naredba selekcije

```
IF logički_izraz THEN
    blok_izvršnih naredbi;
[
ELSIF logički_izraz THEN
    blok_izvršnih naredbi;
]...
[
ELSE
    blok_izvršnih naredbi;
]
END IF;
```

## Naredbe iteracije

### Bezuslovna (beskonačna) iteracija / LOOP

```
LOOP
    blok_izvršnih_naredbi;
END LOOP;
```

### Uslovna iteracija, s testom uslova na početku / WHILE LOOP

```
WHILE logički_izraz LOOP
    blok_izvršnih_naredbi;
END LOOP; 
```

### Izlazak iz petlje / EXIT

```
EXIT [labela] [WHEN logički_izraz]
```

### Brojačka iteracija / FOR LOOP

```
FOR brojač IN [REVERSE] donja_granica..gornja_granica LOOP
    blok_izvršnih_naredbi;
END LOOP;
```

> NAPOMENA: Brojačku promenljivu brojač nije potrebno deklarisati. Korak brojača je uvek 1. 



