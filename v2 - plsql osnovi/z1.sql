/*
U konzolu ispisati trenutni datum, datum rođenja, dan u sedmici kada ste rođeni kao i broj dana koje ste proživeli do sada. Datum rođenja uneti kroz interaktivni prompt.
*/

UNDEFINE Dat_rodj;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Danas je: ' || SYSDATE);
    DBMS_OUTPUT.PUT_LINE('Rodjen sam: ' || TO_DATE('&&Dat_rodj', 'DD.MM.YYYY'));
    DBMS_OUTPUT.PUT_LINE('Bio je: ' || TO_CHAR(TO_DATE('&&Dat_rodj', 'DD.MM.YYYY'), 'DAY'));
    DBMS_OUTPUT.PUT_LINE('Sada sam stariji ' || TO_CHAR(ROUND(SYSDATE - TO_DATE('&&Dat_rodj', 'DD.MM.YYYY'), 0)) || ' dana');
END;