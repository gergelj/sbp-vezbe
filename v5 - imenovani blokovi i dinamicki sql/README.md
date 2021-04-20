# Vežba 5 - Imenovani blokovi i dinamički SQL

## PL/SQL imenovani blokovi

- Neimenovani (anonimni) blok

```sql
[DECLARE
... -- Deklarativni deo bloka
]
BEGIN
... -- Izvršni deo bloka
[EXCEPTION
... -- Deo bloka za obradu izuzetaka
]
END;
```

### Vrste imenovanih programskih blokova

1. Serverska procedura ili funkcija

- procedura ili funkcija, kreirana na nivou DBMS i memorisana u rečniku podataka DBMS
- egzistira u rečniku podataka u dva oblika:
    - izvornom (source kod)
    - prekompajliranom (P-kod – izvršni kod, interpretabilan od strane DBMS i PL/SQL Engine-a)

2. Lokalna procedura ili funkcija

- procedura ili funkcija, deklarisana unutar nekog PL/SQL bloka (programa)

3. Klijentska procedura ili funkcija

- procedura ili funkcija, deklarisana u okviru nekog alata iz Oracle Developer Suite
- nalazi se i izvršava na srednjem sloju (aplikativnom serveru)

### Procedura

- Predstavlja naredbu koja se poziva kao i bilo koja druga naredba – navođenjem naziva
- Nema povratnu vrednost
- Može da ima ulazne i izlazne parametre

### Funkcija

- Predstavlja unarni operator koji se koristi u izrazima i namenjen je da vrati izračunatu vrednost u izraz iz kojeg je pozvan
- Ima povratnu vrednost
- Može da ima samo ulazne parametre

## PL/SQL Procedure

```
CREATE [OR REPLACE] PROCEDURE [schema.]procedure_name
  [(parameter1 [IN | OUT | IN OUT] datatype1 [DEFAULT def_value],
   parameter2 [IN | OUT | IN OUT] datatype2 [DEFAULT def_value],
   ...
  )]
IS | AS
[   ... -- Deklarativni deo bloka
]
BEGIN
    ... -- Izvršni deo bloka
[EXCEPTION
    ... -- Deo bloka za obradu izuzetaka
]
END [procedure_name];
```

### Vrsta parametara procedure

1. `IN` - specifikacija ulaznog parametra procedure
- vrednost parametra se zadaje pri pozivu procedure i ne sme da se menja unutar procedure
- dozvoljeno je zadavanje DEFAULT vrednosti parametra
- prenos parametra po referenci

2. `OUT` - specifikacija izlaznog parametra procedure
- procedura generiše i vraća vrednost parametra u pozivajuće okruženje
- nije dozvoljeno zadavanje DEFAULT vrednosti parametra
- prenos parametra po vrednosti
- druga varijanta: `OUT NOCOPY`
    - specifikacija izlaznog parametra s prenosom po referenci

3. `IN OUT` - specifikacija ulazno-izlaznog parametra procedure
- vrednost parametra se zadaje pri pozivu procedure, može da se menja unutar procedure i vraća se izmenjena vrednost u pozivajuće okruženje
- nije dozvoljeno zadavanje DEFAULT vrednosti parametra
- prenos parametra po vrednosti
- druga varijanta: `IN OUT NOCOPY`
    - specifikacija ulazno-izlaznog parametra s prenosom po referenci

```
ALTER PROCEDURE
[schema.]procedure_name COMPILE;

DROP PROCEDURE
[schema.]procedure_name;
```

### Pozivanje procedure

```
Naziv_procedure [([formalni_param1 =>] stvarni_param1, [ ([formalni_param2 =>] stvarni_param2,...)]
```

Umesto `IN` formalnih parametara, kao stvarni parametri, mogu se pojaviti izrazi odgovarajućeg tipa ili promenljive odgovarajućeg tipa. Umesto `IN OUT` i `OUT` formalnih parametara, kao stvarni parametri, mogu se pojaviti samo promenljive odgovarajućeg tipa.

### Deklarisanje i pozivi lokalnih procedura

```
PROCEDURE procedure_name
  [(parameter1 [IN | OUT | IN OUT] datatype1 [DEFAULT def_value],
  parameter2 [IN | OUT | IN OUT] datatype2 [DEFAULT def_value],
  ...
  )]
IS | AS
[   ... -- Deklarativni deo bloka
]
BEGIN
    ... -- Izvršni deo bloka
[EXCEPTION
    ... -- Deo bloka za obradu izuzetaka
]
END;
```

> Primer

```sql
CREATE OR REPLACE PROCEDURE A
IS
    PROCEDURE B (P_1 IN NUMBER)
    IS
    BEGIN
        NULL;
    END;
BEGIN
    B(10);
END;
```

## PL/SQL Funkcije

```
CREATE [OR REPLACE] FUNCTION [schema.]function_name
  [(parameter1 [IN | OUT | IN OUT] datatype1 [DEFAULT def_value],
   parameter2 [IN | OUT | IN OUT] datatype2 [DEFAULT def_value],
   ...
  )]
RETURN ret_datatype
IS | AS
[   ... -- Deklarativni deo bloka
]
BEGIN
    ... -- Izvršni deo bloka
[EXCEPTION
    ... -- Deo bloka za obradu izuzetaka
]
END [function_name];
```

**NAPOMENA**: Ne savetuje se da se u okviru funkcije deklarišu `IN OUT`, ili `OUT` parametri! – Ukoliko je to neophodno, treba funkciju preformulisati u proceduru!

```
ALTER FUNCTION [schema.]function_name COMPILE;

DROP FUNCTION [schema.]function_name;
```

### Obezbeđenje povratka vrednosti funkcije

```sql
RETURN expression;
```

Izraz `expression` mora biti kompatibilan s tipom povratnog podatka funkcije `ret_datatype`

**NAPOMENA**: Svaka funkcija, u svom proceduralnom delu, ili delu za obradu izuzetaka, mora posedovati bar jednu naredbu `RETURN`.

> Primer

```sql
CREATE OR REPLACE FUNCTION F_PctInc (P_Num IN NUMBER, P_Pct IN NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN P_Num * (1 + P_Pct / 100);
END F_PctInc;
```

### Pozivanje funkcije

```
Naziv_funkcije [ ([formalni_param1 =>] stvarni_param1,
        [ ([formalni_param2 =>] stvarni_param2,...) ]
```

Moguća mesta (izrazi) u kojima se mogu pozivati serverske funkcije:
- u bilo kojem PL/SQL ili SQL izrazu
    - u okviru naredbe dodele vrednosti
    - u okviru selekcione CASE funkcije
    - u okviru IF i LOOP naredbi
    - u okviru RETURN naredbe funkcije
    - kao stvarni parametar potprograma, na mestu formalnog parametra tipa `IN`
- u SQL izrazima u okviru SQL naredbi
    - Naredba SELECT
        - u SELECT listi
        - u klauzulama WHERE, GROUP BY, HAVING, ORDER BY, CONNECT BY START WITH
    - Naredba INSERT
        - u klauzuli VALUES
    - Naredba UPDATE
        - u klauzuli SET
        - u klauzuli WHERE
    - Naredba DELETE
        - u klauzuli WHERE

**NAPOMENA**: Ograničenja u pisanju funkcija, kada se funkcije koriste u SQL izrazima naredbe SELECT, ili DML naredbi
- Mora se koristiti pozicioni način pozivanja
- Ne smeju se koristiti tipovi povratnih podataka, specifični samo za PL/SQL (BOOLEAN, %ROWTYPE, %TYPE, RECORD)
- Ne smeju se deklarisati formalni parametri tipa IN OUT ili OUT
- Ne smeju se koristiti naredbe SAVEPOINT, COMMIT i ROLLBACK
- Ne smeju se koristiti DML naredbe, ako je funkcija u SELECT naredbi
- Ne smeju se koristiti ni DML naredbe ni SELECT naredba nad istom tabelom, ili povezanim tabelama, ako je funkcija u DML naredbi
- Funkcije koje zove takva funkcija, takođe moraju zadovoljiti iste uslove

### Deklarisanje i pozivi lokalnih funkcija

```
FUNCTION [schema.]function_name
  [(parameter1 [IN | OUT | IN OUT] datatype1 [DEFAULT def_value],
  parameter2 [IN | OUT | IN OUT] datatype2 [DEFAULT def_value],
  ...
  )]
RETURN ret_datatype
IS | AS
[   ... -- Deklarativni deo bloka
]
BEGIN
    ... -- Izvršni deo bloka
[EXCEPTION
    ... -- Deo bloka za obradu izuzetaka
]
END;
```

> Primer

```sql
CREATE OR REPLACE PROCEDURE A
    V_X VARCHAR2(1);
IS
    FUNCTION B (P_1 IN NUMBER)
    RETURN VARCHAR2
    IS
    BEGIN
        RETURN 'B';
    END;
BEGIN
    V_X := B(10);
END;
```

## Dinamički SQL

Dinamički SQL omogućava izvršavanje (PL/)SQL naredbi koje su tek poznate u fazi izvršavanja (runtime, late binding).

Oracle DBMS pruža dva načina za rad sa dinamičkim SQL naredbama u PL/SQL programima:
1. Pozivanje nativnog dinamičkog SQL-a, naredbe se direktno pišu u PL/SQL blokove.
2. Pozivanje procedura iz DBMS_SQL paketa.
    - Obavezno za naredbe sa nepoznatim brojem ulaznih ili izlaznih parametara.

> Primeri

```sql
plsql_block := 'BEGIN calc_stats(:x, :x, :y, :x); END;';
EXECUTE IMMEDIATE plsql_block USING a, b; -- calc_stats(a, a, b, a)

query_str := 'SELECT COUNT(*) FROM ' || ' emp_' || loc || ' WHERE job = :job_title';
EXECUTE IMMEDIATE query_str INTO num_of_employees USING job;
```

```sql
CREATE OR REPLACE PROCEDURE query_invoice(month VARCHAR2, year VARCHAR2)
IS
    TYPE cur_typ IS REF CURSOR;
    c cur_typ;
    query_str VARCHAR2(200);
    inv_num NUMBER := 1;
    inv_cust VARCHAR2(20);
    inv_amt NUMBER;
BEGIN
    query_str := 'SELECT num, cust, amt FROM inv_' || month ||'_'|| year || ' WHERE invnum = :id';
    
    OPEN c FOR query_str USING inv_num;
    LOOP FETCH c INTO inv_num, inv_cust, inv_amt;
        EXIT WHEN c%NOTFOUND;
        -- process row here
    END LOOP;
    CLOSE c;
END;
```