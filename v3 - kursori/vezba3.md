# Vežba 3 - Kursori i kompleksni tipovi

## Kursori

Kursori u jezku PL/SQL
- Implicitni (SQL)
- Eksplicitni
  - Deklariše se programski
  - Njime se upravlja programski

### Životni ciklus kursora

1. Deklarisanje kursora

```
CURSOR naziv_kursora [(lista_formalnih_parametara)]
    IS SELECT ...
```

2. Otvaranje kursora

```
OPEN naziv_kursora [(lista_stvarnih_parametara)];
```

3. Preuzimanje torke kursora

```
FETCH naziv_kursora INTO [var1, var2,... | record_var];
```

4. Zatvaranje kursora

```
CLOSE naziv_kursora;
```

### Funkcije ispitivanja statusa kursora

- `naziv_kursora%FOUND`
  - TRUE, ako je bar jedan red bio predmet poslednje fetch operacije, inače FALSE
- `naziv_kursora%NOTFOUND`
  - TRUE, ako ni jedan red nije bio predmet poslednje fetch operacije, inače FALSE
- `naziv_kursora%ROWCOUNT`
  - broj redova, koji su bili predmet poslednje fetch operacije
- `naziv_kursora%ISOPEN`
  - TRUE, ako je kursor otvoren, a inače FALSE

> Primer

```sql
DECLARE
    Ukup_plt NUMBER;
    L_Mbr radnik.Mbr%TYPE;
    L_Plt radnik.Plt%TYPE;

    CURSOR spisak_rad IS
    SELECT Mbr, Plt
    FROM radnik
    WHERE Mbr BETWEEN 01 AND 99;

BEGIN
    Ukup_Plt := 0;
    OPEN spisak_rad;  -- otvoren kursor, izvršava se SELECT
    
    LOOP
        FETCH spisak_rad
        INTO L_Mbr, L_Plt;             -- dobavljanje naredne torke iz kursora
        EXIT WHEN spisak_rad%NOTFOUND; -- uslov izlaska iz petlje
        Ukup_Plt := Ukup_Plt + L_Plt;
    END LOOP;
    
    CLOSE spisak_rad; -- zatvoren kursor
    DBMS_OUTPUT.PUT_LINE('Plata je: ' || Ukup_Plt);END;
```

### Kursorska FOR petlja

Obavezna je deklaracija kursorskog područja, vrši se automatsko otvaranje, preuzimanje torki i zatvaranje kursora. Slogovsku promenljivu `record_var` nije potrebno eksplicitno deklarisati.

```
FOR record_var IN naziv_kursora [(lista_stvarnih_parametara)] LOOP
    statement1;
    statement2;
    ...
END LOOP;
```

### Kursorska FOR petlja sa implicitnom deklaracijom kursora

Kursorsko područje se ne deklariše eksplicitno, vrši se automatsko otvaranje, preuzimanje torki i zatvaranje kursora. Slogovsku promenljivu `record_var` nije potrebno eksplicitno deklarisati.

```
FOR record_var IN (SELECT ...) LOOP
    statement1;
    statement2;
    ...
END LOOP;
```

## Složeni tipovi podataka

PL/SQL tip sloga
- `RECORD`

PL/SQL tip kolekcije
- `INDEX BY` tables – indeksirane tabele
- `NESTED` tables – "ugnježdene" tabele
- `VARRAY` – nizovi ograničene maksimalne dužine

### PL/SQL tip sloga

- Deklarisanje
    ```
    TYPE type_name IS RECORD
    (field_declaration[, field_declaration]...);
    ```

    ```
    <field_declaration>:
    
    field_name {field_type | variable%TYPE| table.column%TYPE | table%ROWTYPE}
    [[NOT NULL] {:= | DEFAULT} expr]
    ```

    ```
    identifier type_name;
    ```
- Referenciranje polja sloga
    ```
    identifier.field_name
    ```

#### %ROWTYPE atribut

Deklariše promenljivu prema kolekciji kolona u tabeli ili pogledu baze podataka. Ispred `%ROWTYPE` može da stoji ime *tabele*, *pogleda* ili *kursora*. Polja u slogu imaju isti naziv i tip podatka kao i kolone u tabeli ili pogledu.

```
identifier table%ROWTYPE;
```

### PL/SQL tip indeksirane tabele

- Deklarisanje 
    ```
    TYPE type_name IS TABLE OF
    {column_type | variable%TYPE| table.column%TYPE} [NOT NULL]| table%ROWTYPE
    [INDEX BY BINARY_INTEGER];
    ```
    
    ```
    identifier type_name; 
    ```
- Referenciranje elementa tabele (niza)
    ```
    identifier(index)
    identifier(ind1)...(indn) - za višedimenzionalne strukture
    ```
- Referenciranje polja sloga, koji predstavlja element tabele (niza)
    ```
    identifier(index).field_name
    ```

#### Metode (operacije) nad promenljivama tabelarnog tipa

| Naziv metode | Opis |
| ------------ | ---- |
| `COUNT` | Ukupan broj elemenata kolekcije |
| `EXISTS(n)` | Indikacija postojanja n-tog elementa kolekcije |
| `EXTEND(n)` | Alokacija prostora za novih n članova tabele – obavezno kada se ne koristi `INDEX BY` deklaracija indeksa tabele. |
| `FIRST` | Indeks prvog elementa kolekcije |
| `LAST` | Indeks poslednjeg elementa kolekcije |
| `PRIOR(n)` | Indeks prethodnog elementa kolekcije, u odnosu na n |
| `NEXT(n)` | Indeks narednog elementa kolekcije, u odnosu na n |
| `DELETE[(n [, m])]` | Brisanje svih, ili samo n-tog, ili intervala od n-tog do m-tog elementa iz kolekcije. Oslobađase memorijski prostor. |
| `TRIM[(n)]` | Brisanje poslednjeg, ili n poslednjih elemenata iz kolekcije ("odsecanje" kolekcije) i oslobađanje memorijskog prostora |

- Referenciranje metode
    ```
    identifier.method_name[(parameters)] 
    ```

> Primer

```sql
DECLARE
    TYPE T_Tab IS TABLE OF VARCHAR2(20)
        INDEX BY BINARY_INTEGER;
    Tab T_Tab;
    i BINARY_INTEGER;
BEGIN
    Tab(1) := 'DEJAN';
    Tab(3) := 'NENAD';
    Tab(-1) := 'MARKO';
    Tab(5) := 'ACA';
    
    Tab.DELETE(1);
    i := Tab.FIRST;
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || Tab(i));
        i := Tab.NEXT(i);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(i), 'i ima NULL vrednost.'));
END;
```

> Primer sa matricama

```sql
DECLARE
    TYPE T_Tab1 IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TYPE T_Mat1 IS TABLE OF T_Tab1 INDEX BY BINARY_INTEGER;
    
    Mat1 T_Mat1;
    Tab1 T_Tab1;
BEGIN
    Mat1(1)(1) := 1;
    Mat1(1)(2) := 2;
    Tab1 := Mat1(1);
    DBMS_OUTPUT.PUT_LINE(Mat1(1)(1));
END;
```

### PL/SQL tip ugnježdene tabele

```sql
DECLARE
    TYPE T_Tab IS TABLE OF VARCHAR2(20);
    Tab1 T_Tab := T_Tab();
    Tab2 T_Tab := T_Tab('Janko', 'Jana');
BEGIN
    Tab1.EXTEND(5);
    Tab1(1) := 'Ana';
    Tab1(3) := 'Bora';
    -- Tab1(-1) := 'Cane’; NIJE MOGUĆE! Indeks ugneždenih tabela može ići samo od 1!
    ...
END;
```
