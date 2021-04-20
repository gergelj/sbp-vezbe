# Vežba 6 - Trigeri i paketi

## Upravljanje transakcijama

### Implicitno zaključavanje

Automatsko zaključavanje, realizuje ga sam DBMS. Obezbeđuje minimum smanjenja paralelizma u radu, neophodan za očuvanje konzistentnosti podataka u BP u višekorisničkom režimu rada

SELECT naredba ne izaziva zaključavanja. DML naredbe izazivaju ekskluzivno zaključavanje torki koje su predmet ažuriranja.

### Eksplicitno zaključavanje

Realizuje ga programer transakcionog programa - "pooštrava" restriktrivnost pristupa resursima. Dodatno snižava mogući stepen paralelizma u radu.

#### Naredbe za upravljanje transakcijama

- `COMMIT` - Zahtev za potvrđivanje transakcije i oslobađanje resursa
- `ROLLBACK` - Zahtev za kompletno poništavanje transakcije i oslobađanje resursa
- `SAVEPOINT savepoint_name` - Obeležavanje vremenske tačke napretka transakcije
- `ROLLBACK TO [SAVEPOINT] savepoint_name` - Zahtev za delimično poništavanje transakcije

> Primer

```sql
BEGIN
    INSERT INTO tabela VALUES (5, 6);
    SAVEPOINT sp_1;
    INSERT INTO tabela VALUES (7, 8);
    SAVEPOINT sp_2;
    INSERT INTO tabela VALUES (9, 10);
    ROLLBACK sp_1;
    INSERT INTO tabela VALUES (11, 12);
    COMMIT;
END;
```

## Trigeri

Mehanizam koji se pokreće na događaj, vezan za manipulaciju podacima, ili samom bazom podataka i pokreće PL/SQL program

Događaji:
- DML naredbe (INSERT, UPDATE, DELETE)
- DDL naredbe (CREATE, ALTER, DROP)
- DBMS događaji
  - AFTER SERVERERROR
  - AFTER LOGON
  - BEFORE LOGOFF
  - AFTER STARTUP
  - BEFORE SHUTDOWN

Oblast definisanosti
- jedna tabela, ili
- jedan pogled

Vreme okidanja
- `BEFORE` neposredno pre akcije naredbe
- `AFTER` neposredno nakon akcije naredbe
- `INSTEAD` OF umesto same akcije naredbe (samo za poglede)

Pokretači trigera
- `INSERT`
- `UPDATE [OF lista_kolona]`
- `DELETE`

Frekvencija aktiviranja (tip) trigera
1. Svaka torka, koja je predmet DML naredbe – `FOR EACH ROW`
    - **Row Level Trigger**
    - dodatno, logički uslov pokretanja Row Level trigera
2. DML naredba u celini
    - **Statement Level Trigger**

Aktivnost (procedura – PL/SQL blok), koju triger realizuje, kada je pokrenut.

### Oblikovanje trigera

```
CREATE [OR REPLACE] TRIGGER Naziv_Trigera
BEFORE | AFTER | INSTEAD OF
  INSERT | DELETE | UPDATE [OF ListaObeležja]
    [OR INSERT | DELETE | UPDATE [ OF ListaObeležja ] ... ]
ON Naziv_Tabele
[FOR EACH ROW [WHEN (LogičkiUslovPokretanjaTrigera)]]
[REFERENCING OLD AS NazivOld NEW AS NazivNew]
[DECLARE
    -- Deklarativni deo - lokalne deklaracije
]
BEGIN
    -- Izvršni_deo - proceduralni deo, specifikacija aktivnosti
[EXCEPTION 
    -- Deo_za_obradu_izuzetaka - naredbe oblika WHEN...THEN
]
END [Naziv_Trigera];
```

```
ALTER TRIGGER Naziv_Trigera DISABLE | ENABLE;

ALTER TRIGGER Naziv_Trigera COMPILE;

DROP TRIGGER Naziv_Trigera;
```

Ne postoji način da se triger, na bilo koji način "pozove" direktno. Ukoliko triger generiše izuzetak, operacija koja ga je aktivirala se prekida. **Zabranjeno je upravljanje transakcijom (upotreba naredbi `COMMIT`, `ROLLBACK` i `SAVEPOINT`)**

### Referenciranje predmetnih podataka u Row Level trigerima

Podaci koji su predmet pokretačke DML naredbe, mogu biti referencirani unutar tela trigera:
- `:OLD.naziv_kolone`
    - "stara" vrednost kolone - before image
    - ovakvo referenciranje ima smisla u slučaju pokretačke `UPDATE` ili `DELETE` naredbe
- `:NEW.naziv_kolone`
    - "nova" vrednost kolone - after image
    - ovakvo referenciranje ima smisla u slučaju pokretačke `UPDATE` ili `INSERT` naredbe

> Primer

```sql
CREATE OR REPLACE TRIGGER Trg_Radnik_Pre_INSUPD
BEFORE INSERT OR UPDATE OF Pre
ON RADNIK
FOR EACH ROW WHEN (NEW.Pre < 0)
BEGIN
    :NEW.Pre := 0;
END Trg_Radnik_Pre_INSUPD;
```

> Primer kreiranja funkcije za proveru kontrolne cifre JMBG-a

```sql
CREATE OR REPLACE FUNCTION F_ProveraContrBr (P_Jmbg IN VARCHAR)
RETURN BOOLEAN IS
    v_KonCif CHAR(12) := '765432765432';
    v_RAZ NUMBER(4) := 0;
BEGIN
    FOR i IN 1..12 LOOP
        v_RAZ := v_RAZ + TO_NUMBER(SUBSTR(P_Jmbg, i, 1)) * TO_NUMBER(SUBSTR(v_KonCif, i, 1);
    END LOOP;
    v_RAZ := 11 - MOD(v_RAZ, 11);
    IF v_RAZ != 10 AND MOD(v_RAZ, 11) = TO_NUMBER(SUBSTR(P_Jmbg, 13, 1)) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END F_ProveraContrBr;
```

### Logičke funkcije ispitivanja vrste pokretačke DML naredbe

U telu trigera koji može biti pokrenut od strane više vrsta DML naredbi, moguće je ispitati, koja vrsta DML naredbe je pokrenula triger.

- INSERTING
    - TRUE, ako je pokretač trigera bila naredba INSERT, inače FALSE
- UPDATING [('naziv_kolone')]
    - TRUE, ako je pokretač trigera bila naredba UPDATE (opciono, nad navedenoj koloni u listi iza ključne reči UPDATE), inače FALSE
- DELETING
    - TRUE, ako je pokretač trigera bila naredba DELETE, inače FALSE

### Neke oblasti primene trigera

- Realizacija kontrole ograničenja podataka, na nivou DBMS-a
- Realizacija pravila poslovanja, koja rezultuju u obavezama primene određenih operacija nad BP, u zahtevanom redosledu, u okrivu iste DBMS transakcije
- Realizacija zaštite BP od neovlašćenog pristupa
- Praćenje aktivnosti (izvršenja operacija) nad podacima u BP (Journaling)
- Automatsko prosleđivanje podataka ili poruka, ili pokretanje programa, kao rezultat ažuriranja BP
- Osvežavanje materijalizovanih pogleda (replikacionih kopija) u distribuiranim bazama podataka

## Paketi

Paket - kolekcija PL/SQL deklaracija
• tipova, promenljivih, konstanti
• kursorskih područja i izuzetaka
• procedura i funkcija

### Struktura paketa

- Javni (vidljivi) deo paketa
    - Specifikacija paketa
      - sadrži PL/SQL "javne" (public) deklaracije - koje su dostupne za upotrebu (vidljive) i izvan paketa i unutar paketa

- Privatni (skriveni) deo paketa
    - Telo paketa
      - sadrži PL/SQL "privatne" (private) deklaracije - koje su dostupne za upotrebu (vidljive) samo unutar paketa
      - sadrži kompletnu specifikaciju (implementaciju, razradu) javnih deklaracija procedura i funkcija
      - sadrži kompletnu specifikaciju (mplementaciju, razradu) privatnih procedura i funkcija
    - Inicijalizacioni blok paketa
        - sadrži imperativne PL/SQL naredbe, koje se jednokratno izvršavaju, pri prvom referenciranju paketa u sesiji

### Vrste paketa

- Serverski paket
    - kreiran na nivou DBMS i memorisan u rečniku podataka DBMS
    - egzistira u rečniku podataka u dva oblika:
        - izvornom (source kod)
        - prekompajliranom (P-kod – izvršni kod, interpretabilan od strane DBMS i PL/SQL Engine-a)
- Klijentski paket
    - paket, deklarisan u okviru nekog alata iz Oracle Developer Suite
    - nalazi se i izvršava na srednjem sloju (aplikativnom serveru)

### Oblikovanje specifikacije paketa

```
CREATE [OR REPLACE] PACKAGE [schema.]package_name
IS|AS
    deklaracije javnih PL/SQL elemenata ...
END [package_name];

ALTER PACKAGE [schema.]package_name COMPILE;

DROP PACKAGE [schema.]package_name;
```

U okviru specifikacije paketa moguće je deklarisati bilo koji PL/SQL element (tip, promenljiva, konstanta, kursor, izuzetak, procedura, funkcija). Tipovi, promenljive, konstante, kursori i izuzeci se deklarišu na uobičajen način.

Procedure i funkcije se deklarišu samo navođenjem zaglavlja
(header-a), prema sintaksi:

```
PROCEDURE procedure_name
[(parameter1 [IN | OUT | IN OUT] datatype1 [DEFAULT def_value],
  parameter2 [IN | OUT | IN OUT] datatype2 [DEFAULT def_value],
  ...) ];

FUNCTION function_name
[(parameter1 [IN | OUT | IN OUT] datatype1 [DEFAULT def_value],
  parameter2 [IN | OUT | IN OUT] datatype2 [DEFAULT def_value],
  ...)]
RETURN ret_datatype;
```

**Napomene**

Svaka procedura ili funkcija, čije se zaglavlje pojavljuje u specifikaciji paketa mora biti kompletno specificirana (razrađena) u telu paketa, pod istim nazivom kao što je i zaglavlje paketa - u tom slučaju, obavezno je kreiranje tela paketa.

Specifikacija paketa koji nema u sebi deklarisane funkcije ili
procedure, ne zahteva kreiranje tela paketa - u tom slučaju, kreiranje tela paketa nije obavezno.

Sve promenljive, deklarisane u specifikaciji paketa, po default-u, biće inicijalizovane na NULL vrednost.

Sve promenljive, deklarisane u specifikaciji paketa, memorisaće vrednosti koje su jedinstvene na nivou jedne sesije korisnika - bez obzira koliko različitih i kojih PL/SQL programa preuzima ili ažurira vrednosti tih promenljivih.

Svako kompajliranje (izmena) specifikacije paketa, zahteva i ponovno kompajliranje tela paketa.

> Primer kreiranja specifikacije paketa

```sql
CREATE OR REPLACE PACKAGE Var_Methods
IS
    TYPE T_Tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    PROCEDURE Set_Val(P_Key IN BINARY_INTEGER, P_Val IN NUMBER);
    PROCEDURE Inc_Val(P_Key IN BINARY_INTEGER, P_Stp IN NUMBER DEFAULT 1);
    PROCEDURE Rem_Key(P_Key IN BINARY_INTEGER);
    FUNCTION Get_Val(P_Key IN BINARY_INTEGER) RETURN NUMBER;
END Var_Methods;
```

### Oblikovanje tela paketa

```
CREATE [OR REPLACE] PACKAGE BODY [schema.]package_name
IS|AS
    deklaracije privatnih PL/SQL elemenata ...
    implementacije
[BEGIN
    proceduralni deo – inicijalizacija promenljivih
]
END [package_name];

ALTER PACKAGE BODY [schema.]package_name COMPILE;

DROP PACKAGE BODY [schema.]package_name;
```

U okviru tela paketa moguće je deklarisati bilo koji PL/SQL element (tip, promenljiva, konstanta, kursor, izuzetak, procedura, funkcija).

Tipovi, promenljive, konstante, kursori i izuzeci se deklarišu na uobičajen način.

Procedure i funkcije, bez obzira da li su javne ili privatne, kompletno se specificiraju, na isti način kao i lokalne procedure i funkcije – na uobičajen način.

Proceduralni deo koda koji se nalazi u BEGIN – END delu tela paketa izvršava se samo jednom, na nivou sesije - prvi put, kada se referencira bilo koji element paketa i/ili kada se sadržaj paketa učitava u radnu memoriju DBMS-a.

**Napomene**

Svaka procedura ili funkcija, čije se zaglavlje pojavljuje u specifikaciji paketa mora biti kompletno specificirana (razrađena) u telu paketa, pod istim nazivom kao što je i zaglavlje paketa - zaglavlje javne procedure ili funkcije, koja se specificira u telu paketa, mora u potpunosti da odgovara zaglavlju, deklarisanom u specifikaciji paketa.

Sve promenljive, deklarisane u telu paketa, po default-u, biće inicijalizovane na NULL vrednost.

Sve promenljive, deklarisane u telu paketa, memorisaće vrednosti koje su jedinstvene na nivou jedne sesije korisnika - bez obzira koliko različitih i kojih PL/SQL programa preuzima ili ažurira vrednosti tih promenljivih.

Kompajliranje (izmena) tela paketa, ne mora da zahteva ponovno kompajliranje specifikacije paketa.

> Primer kreiranja tela paketa

```sql
CREATE OR REPLACE PACKAGE BODY Var_Methods
IS
    TabValue T_Tab;

    PROCEDURE Set_Val(P_Key IN BINARY_INTEGER, P_Val IN NUMBER) IS
    BEGIN
        TabValue(P_Key) := P_Val;
    END Set_Val;

    PROCEDURE Inc_Val(P_Key IN BINARY_INTEGER, P_Stp IN NUMBER DEFAULT 1) IS
    BEGIN
        IF TabValue.EXISTS(P_Key) AND TabValue(P_Key) IS NOT NULL THEN
            TabValue(P_Key) := TabValue(P_Key) + P_Stp;
        END IF;
    END Inc_Val;

    PROCEDURE Rem_Key(P_Key IN BINARY_INTEGER) IS
    BEGIN
        IF TabValue.EXISTS(P_Key) THEN
            TabValue.DELETE(P_Key);
        END IF;
    END Rem_Key;

    FUNCTION Get_Val(P_Key IN BINARY_INTEGER) RETURN NUMBER IS
    BEGIN
        IF TabValue.EXISTS(P_Key) THEN
            RETURN TabValue(P_Key);
        ELSE
            RETURN -1;
        END IF;
    END Get_Val;
BEGIN
    TabValue(1) := 0;
END Var_Methods;
```

### Referenciranje elemenata PL/SQL paketa

- Referenciranje unutar paketa
    - Na uobičajeni način, navođenjem naziva referenciranog elementa, saglasno sintaksnim pravilima jezika PL/SQL
- Referenciranje izvan paketa
    - Navođenjem naziva paketa, kao prefiksa, a zatim na uobičajeni način, saglasno sintasksnim pravilima jezika PL/SQL

### Function overloading

Identifikacija jedinstvenosti procedure ili funkcije
unutar paketa:
- Naziv funkcije / procedure
- Broj, tipovi i vrste deklarisanih formalnih parametara
- Tip povratnog podatka (samo za funkcije)

Funkcije / procedure koje su iste po nazivu, ali se razlikuju po deklarisanim listama prametara (i/ili tipu povratne vrednosti), smatraju se različitim funkcijama.

Preklapanje funkcija ili procedura - deklarisanje funkcija / procedura sa istim nazivom, ali različitim listama formalnih parametara (ili tipom povratne vrednosti). **NAPOMENA** Moguće je obezbediti preklapanje samo procedura / funkcija koje pripadaju nekom (istom) paketu - nije moguće obezbediti preklapanje samostalnih serverskih procedura ili funkcija.




