# Vežba 4 - Izuzeci i kursorska ažuriranja

## Izuzeci

Događaj koji izaziva prekid normalnog toka izvođenja programa.

- EXCEPTION – programska celina za obradu PL/SQL izuzetaka
- Exception Handler - deo PL/SQL bloka koji obrađuje izuzetke

Prelaskom na exception handler, nemoguće je vratiti tok izvođenja programa nazad, u BEGIN deo programskog bloka.

### Tipovi PL/SQL izuzetaka

- Predefinisani
- Nepredefinisani
- Korisnički definisan

#### Predefinisani izuzetak

- Unapred definisano ime
- Unapred povezan sa ORA (DBMS) greškom koja ga izaziva
- Programer može i direktno izazvati ovu vrstu izuzetka, ali je prirodno da se on izaziva automatski, pojavom greške s kojom je povezan.

Lista predefinisanih izuzetaka

| NAZIV IZUZETKA | ORACLE KOD GREŠKE | Vrednost SQLCODE |
| -------------- | ----------------- | :--------------: |
| ACCESS_INTO_NULL | ORA-06530 | -6530 |
| CASE_NOT_FOUND | ORA-06592 | -6592 |
| COLLECTION_IS_NULL | ORA-06531 | -6531 |
| CURSOR_ALREADY_OPEN | ORA-06511 | -6511 |
| **DUP_VAL_ON_INDEX** | ORA-00001 | -0001 |
| INVALID_CURSOR | ORA-01001 | -1001 |
| INVALID_NUMBER | ORA-01722 | -1722 |
| LOGIN_DENIED | ORA-01017 | -1017 |
| **NO_DATA_FOUND** | ORA-01403 | +0100 |
| NOT_LOGGED_ON | ORA-01012 | -1012 |
| PROGRAM_ERROR | ORA-06501 | -6501 |
| ROWTYPE_MISMATCH | ORA-06504 | -6504 |
| STORAGE_ERROR | ORA-06500 | -6500 |
| SUBSCRIPT_BEYOND_COUNT | ORA-06533 | -6533 |
| SUBSCRIPT_OUTSIDE_LIMIT | ORA-06532 | -6532 |
| TIMEOUT_ON_RESOURCE | ORA-00051 | -0051 |
| **TOO_MANY_ROWS** | ORA-01422 | -1422 |
| VALUE_ERROR | ORA-06502 | -6502 |
| ZERO_DIVIDE | ORA-01476 | -1476 |

#### Nepredefinisani izuzetak

- Nema unapred definisano ime
- Nije unapred povezan sa ORA (DBMS) greškom koja ga izaziva
- Programer ga mora, eksplicitno, deklarisati i povezati sa ORA (DBMS) greškom koja će ga izazivati
- Programer može i direktno izazvati ovu vrstu izuzetka, ali je prirodno da se on izaziva automatski, pojavom greške s kojom je povezan
- Deklarisanje i povezivanje nepredefinisanog izuzetka u *deklarativnom* delu programa

```
naziv_izuzetka EXCEPTION;
PRAGMA EXCEPTION_INIT(naziv_izuzetka, kod_ORA_greške);
```

> Primer

```sql
DECLARE
    Delete_RefInt_ERR EXCEPTION;
    PRAGMA EXCEPTION_INIT (Delete_RefInt_ERR, -2292);
BEGIN
    ...
EXCEPTION
    ...
END;
```

#### Korisnički definisani izuzetak

- Nema unapred definisano ime
- Ne povezuje se sa ORA (DBMS) greškom koja bi ga izazivala
- Programer isključivo direktno izaziva ovu vrstu izuzetka, posebnom naredbom
- Deklarisanje korisničkog izuzetka – u deklarativnom delu programa

```
naziv_izuzetka EXCEPTION
```

- Izazivanje korisničkog izuzetka – u proceduralnom delu programa, ili u delu programa za obradu izuzetaka – naredba RAISE

```
RAISE [naziv_izuzetka];
```

> Primer

```sql
DECLARE
    Izuzetak EXCEPTION;
BEGIN
    ...
    RAISE Izuzetak;
    ...
EXCEPTION
    ...
END;
```

### Obrada izuzetaka u EXCEPTION delu programa

```
EXCEPTION
    WHEN exception1 [OR exception2 . . .] THEN
        statement1;
        statement2;
    ...
    [WHEN exception3 [OR exception4 . . .] THEN
        statement1;
        statement2;
    ...
    ]
    [WHEN OTHERS THEN
        statement1;
        statement2;
    ...
    ]
```

Klauzula OTHERS pokriva sve ostale izuzetke, koji u EXCEPTION bloku nisu prethodno eksplicitno navedeni. Ako se navodi, OTHERS je uvek poslednja klauzula u EXCEPTION bloku.

### Pravila upravljanja tokom izvođenja programa

U slučaju izazivanja izuzetka prekida se normalni tok izvođenja programa i programski tok se preusmerava u Exception Handler - EXCEPTION deo PL/SQL bloka. Traži se prva WHEN klauzula, koja sadrži naziv izuzetka koji je nastao, ili sadrži naziv OTHERS.

#### OBRAĐENI IZUZETAK

- izuzetak za koji postoji odgovarajuća WHEN klauzula u EXCEPTION delu

> Primer obrade predefinisanog izuzetka

```sql
ACCEPT P_ruk PROMPT 'Unesi sifru rukovodioca'
DECLARE
    V_Proj Projekat%ROWTYPE;
BEGIN
    SELECT *
    INTO V_Proj
    FROM Projekat
    WHERE Ruk = &P_ruk;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nije selektovana ni jedna torka ...');
        RAISE NO_DATA_FOUND;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Selektovano je vise od jedne torke ...');
        RAISE;
END;
```

> Primer obrade nepredefinisanog, deklarisanog izuzetka

```sql
DECLARE
    Delete_RefInt_ERR EXCEPTION;
    PRAGMA EXCEPTION_INIT (Delete_RefInt_ERR, -2292);
BEGIN
    DELETE FROM Projekat
    WHERE Spr = &p_spr;
    COMMIT;
EXCEPTION
    WHEN Delete_RefInt_ERR THEN
        DBMS_OUTPUT.PUT_LINE ('Nije dozvoljeno brisanje projekta ' || TO_CHAR(&p_spr) || '.Postoje povezani radnici.');
        ROLLBACK;
END;
```

> Primer obrade korisnički definisanih izuzetaka

```sql
ACCEPT X PROMPT 'Unesite vrednost za x'
DECLARE
    A EXCEPTION;
    B EXCEPTION;
    C EXCEPTION;
    D EXCEPTION;
    r NUMBER;
BEGIN
    BEGIN
        IF &x = 0 THEN RAISE A;
        ELSIF &x = 1 THEN RAISE B;
        ELSIF &x = 2 THEN RAISE C;
        ELSE RAISE D;
        END IF;
    EXCEPTION
        WHEN A THEN r := 1;
            DBMS_OUTPUT.PUT_LINE ('Za izuzetak A r je ' || r);
    END;
    r := 2;
    DBMS_OUTPUT.PUT_LINE ('Nema izuzetka i r je ' || r);
EXCEPTION
    WHEN B THEN
        r := 3;
        DBMS_OUTPUT.PUT_LINE ('Za izuzetak B r je ' || r);
    WHEN OTHERS THEN
        r:=10;
        DBMS_OUTPUT.PUT_LINE ('Za sve nenavedene izuzetke (C,D) r je ' || r);
END;
```

#### NEOBRAĐENI IZUZETAK

- izuzetak za koji ne postoji odgovarajuća WHEN klauzula u EXCEPTION delu, niti postoji klauzula WHEN OTHERS

U slučaju **obrađenog izuzetka**, izvršava se imperativni blok odgovarajuće WHEN klauzule i završava se izvođenje PL/SQL bloka.

Izvršavanje bloka koji obrađuje izuzetak može biti uspešno, ili neuspešno
- USPEŠNO: ako nije došlo do pojave istog, ili nekog drugog izuzetka (greške) – tok upravljanja programom vraća se u nadređeni kontekst, na mesto odakle je PL/SQL blok pozvan
- NEUSPEŠNO: ako je došlo do pojave istog, ili nekog drugog izuzetka (greške) – tok upravljanja programom vraća se u nadređeni kontekst, a izuzetak se prosleđuje u nadređeni kontekst.

U slučaju neobrađenog izuzetka, izuzetak se prosleđuje u pozivajući kontekst:
- u nadređeni blok, iz kojeg je dati blok pozvan - izaziva se isti izuzetak u tom bloku i prenosi se tok upravljanja programom na njegov EXCEPTION deo – ova situacija može rekurzivno da se ponavlja sve do pozivajućeg radnog okruženja
- u pozivajuće radno okruženje (npr. SQL*Plus) - izuzetak se, u radnom okruženju, ispoljava kao neobrađena greška

U slučaju pojave greške u radnom okruženju, poništavaju se samo efekti izvođenja celokupnog
PL/SQL bloka, ali se transakcija niti poništava, niti potvrđuje.

### Funkcije za obradu grešaka u EXCEPTION delu PL/SQL bloka

- SQLCODE

Rezultat funkcije je numerička vrednost. SQLCODE vraća broj greške, koji odgovara poslednjem
izazvanom izuzetku. Izvan EXCEPTION bloka, vrednost funkcije je 0.

- SQLERRM [(<broj_greške>)]

Rezultat funkcije je karakter vrednost. SQLERRM vraća broj i opis greške, koji odgovara poslednjem izazvanom izuzetku. Izvan EXCEPTION bloka, vrednost funkcije je **'ORA-0000: normal, successful completion'**.

### Naredba za izazivanje korisničke ORA greške

Način da se programskim putem izazove ORA (DBMS) greška

```
raise_application_error (error_number, message [,{TRUE | FALSE}]);
```

Broj greške (`error_number`) može biti zadat u intervalu od -20000 do -20999.

`TRUE` - kod i poruka o grešci se memorišu na stek grešaka
- omogućen prikaz svih grešaka na pozivajućem putu PL/SQL blokova - pogodno za veliku dubinu pozivanja

`FALSE` - kod i poruka o grešci brišu prethodni sadržaj steka grešaka
- prikazuje se samo poslednji kod i poruka o grešci - jednostavniji pristup

> Primer

```sql
ACCEPT P_ruk PROMPT 'Unesi sifru rukovodioca'
DECLARE
    V_Proj Projekat%ROWTYPE;
BEGIN
    SELECT *
    INTO V_Proj
    FROM Projekat
    WHERE Ruk = &P_ruk;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nije selektovana ni jedna torka ...');
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
        RAISE NO_DATA_FOUND;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Selektovano je vise od jedne torke ...');
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
        RAISE TOO_MANY_ROWS;
    WHEN OTHERS THEN
        Raise_Application_Error(-20000, SQLCODE || ' ' || SQLERRM);
END;
```

## Kursorska ažuriranja

```
SELECT ...
FROM ...
FOR UPDATE [OF column_list][NOWAIT];
```

```
UPDATE ... | DELETE ...
WHERE CURRENT OF naziv_kursora
```

> Primer

```sql
CURSOR cur1 IS
SELECT *
FROM projekat
FOR UPDATE OF nar NOWAIT;

UPDATE projekat
SET nar = null
WHERE CURRENT OF cur1;
```