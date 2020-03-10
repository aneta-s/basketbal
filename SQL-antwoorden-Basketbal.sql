-- UPDATE ANETA:
-- Scripts dienen ervoor dat informatie over de basketbal met leden, wedstrijden, uitslagen, tabelen en records toevoegen. 
-- Opg 7-9 toegevoegd.
-- Bij opgaven 10 aangegeven dat MySQL Workbench deze query standaard niet toe laat (zie antwoord).


use Basketbal;
-- 1.	Geef van de vrouwelijke leden de achternaam, de geboortedatum en hun lidnummer.
SELECT achternaam, geb_datum, lidnr
FROM Lid
WHERE geslacht = 'v';

-- 2.	Geef alle leden die geen emailadres hebben.
SELECT *
FROM Lid
WHERE emailadres IS NULL;

-- 3.	Geef de gegevens van de thuiswedstrijden van Dames 1 teams. Daarvan eindigt de code op D1.
SELECT *
FROM wedstrijd
WHERE teamthuis LIKE "%D1";
-- OF
SELECT *
FROM wedstrijd
WHERE teamthuis REGEXP "D1$";

-- 4.	Geef de uitslagen (teamthuis, teamuit, scorethuis, scoreuit) van de wedstrijden uit klasse B1000 die tussen 15u en 19u gespeeld zijn.
SELECT *
FROM wedstrijd
WHERE klasse = "B1000"
AND tijd >= "15:00"
AND tijd <= "19:00";
-- OR
SELECT *
FROM wedstrijd
WHERE klasse = "B1000"
AND tijd BETWEEN "15:00" AND "19:00";

--	5.	Voeg je zelf toe als lid sinds 1998 met lidnr 300. 
--	(NB Hoe laat je een veld leeg, hoe voer je de datum in)
INSERT INTO Lid(lidnr, achternaam, voorletters, tussenvoegsel, geb_datum, geslacht,jaartoe, straat, huisnr, toevoeging, postcode, woonplaats, telefoon, emailadres)
VALUES (300	, 'Waterman', 'E', NULL , '1965-04-23', 'v', 1998, 'Commelinstraat' , 374,NULL,'1093VD', 'Amsterdam', '0203344556', 'e.waterman@hva.nl');

--	6.	Verhoog de boetes van speler 109 met 10.
UPDATE boete
SET bedrag = bedrag + 10
WHERE lidnummer = 109;

-- 7.	Schrijf een create-script om de tabel Bestuurslid toe te voegen. Deze tabel bevat informatie over de bestuursfuncties die leden van de club hebben bekleed. De primaire sleutel bestaat uit de kolommen lidnummer en begin_datum. De tabel is hieronder gegeven.
CREATE TABLE Bestuurslid
(
lidnummer SMALLINT NOT NULL, 
begin_datum DATE NOT NULL, 
eind_datum DATE, 
Functie character(14) NOT NULL, 
PRIMARY KEY (lidnummer, begin_datum)
);

-- Of 

CREATE TABLE Bestuurslid
(
lidnummer smallint NOT NULL,
begin_datum date NOT NULL,
eind_datum date,
functie character(14) NOT NULL,
CONSTRAINT bestuurslid_pkey PRIMARY KEY (lidnummer,begin_datum)
);

DROP TABLE Bestuurslid;

-- 15.	Voeg de eerste 5 records toe aan de tabel Bestuursleden.
INSERT INTO bestuurslid (lidnummer, begin_datum, eind_datum, functie) VALUES (109, '2008-01-01', '2008-12-31', 'Voorzitter    ');
INSERT INTO bestuurslid (lidnummer, begin_datum, eind_datum, functie) VALUES (107, '2008-01-01', '2008-12-31', 'Secretaris    ');
INSERT INTO bestuurslid (lidnummer, begin_datum, eind_datum, functie) VALUES (107, '2009-01-01', '2009-12-31', 'Lid           ');
INSERT INTO bestuurslid (lidnummer, begin_datum, eind_datum, functie) VALUES (107, '2010-01-01', NULL, 'Penningmeester');
INSERT INTO bestuurslid (lidnummer, begin_datum, eind_datum, functie) VALUES (107, '2007-01-01', '2010-12-31', 'Voorzitter    ');

-- 9.	Geef van elk team uit de klasse B2000 de teamcode en de achternaam van de aanvoerder.
SELECT t.teamcode, l.achternaam
FROM Team t, Lid l
WHERE t.aanvoerder = l.lidnr AND t.klasse = 'B2000';

-- 10.	Geef van de vrouwelijke leden uit Volendam het lidnummer, de naam en de boetebedragen die voor haar betaald zijn.
SELECT l.lidnr, l.achternaam, b.bedrag
FROM Lid l INNER JOIN Boete b
ON l.lidnr = b.lidnummer
WHERE l.woonplaats = 'Volendam' AND l.geslacht = 'v';
-- OF
SELECT l.lidnr, l.achternaam, b.bedrag
FROM Lid l, Boete b
WHERE l.lidnr = b.lidnummer
AND l.woonplaats = 'Volendam' AND l.geslacht = 'v';

-- 11.	Geef van de leden het lidnummer, de achternaam, en de teamcode en de klasse van de teams waarvan hij of zij aanvoerder is. Sorteer de leden op achternaam.
SELECT l.lidnr, l.achternaam, t.teamcode, t.klasse
FROM Team t INNER JOIN Lid l
ON t.aanvoerder = l.lidnr
ORDER BY achternaam;
-- OF
SELECT l.lidnr, l.achternaam, t.teamcode, t.klasse
FROM Team t, Lid l
WHERE t.aanvoerder = l.lidnr
ORDER BY achternaam;

-- 12.	Geef het nummer, de achternaam en de woonplaats van elke vrouwelijke speler die niet in Delft woonachtig is.
SELECT lidnr, achternaam, woonplaats 
FROM Lid 
WHERE woonplaats !='Delft' AND geslacht = 'v';

-- 13.	Geef een lijst van teams met hun thuis gewonnen wedstrijden. Laat het team zien met daarachter uitslag in één kolom als volgt: 30 – 24.
SELECT teamcode, teamnaam, concat(scorethuis,'-',scoreuit) AS uitslag 
FROM Team t INNER JOIN Wedstrijd w 
ON t.teamcode= w.teamthuis  
where scorethuis >  scoreuit;

-- 14.	Geef een lijst met boetes die meer dan acht jaar geleden betaald zijn.
-- DEZE LIJKT NIET TE WERKEN, GEEFT OOK BOETES WEER WELKE VIER JAAR GELEDEN 'BETAALD' ZIJN.
SELECT * 
FROM Boete 
WHERE datumovertreding < CURRENT_DATE - (8*365);
-- Wat te doen met schrikkeljaren?
-- ALTERNATIEF (HERGEBRUIKT EEN DEEL VAN OPDRACHT 9)
SELECT *
FROM Boete 
WHERE TIMESTAMPDIFF(YEAR,datumovertreding,CURDATE()) >= 8;

-- 15.	Geef een lijst met leden, waarbij voorletters, voorvoegsel en achternaam in één kolom verschijnt en het geslacht in de tweede. In die tweede kolom moet het woord ´man´ of ´vrouw´ komen te staan. (tip: gebruik case when….)
SELECT CONCAT_WS(' ',RTRIM(voorletters),RTRIM(Coalesce(tussenvoegsel, '' )),achternaam) as naam,  		case 	when geslacht = 'm' then 'man'     
when geslacht = 'v' then 'vrouw' END as Geslacht 
from Lid;

EXTRA opdrachten na SET sql_mode=‘ONLY_FULL_GROUP_BY’;

-- 1.	Geef voor elk lid voor wie minstens 1 boete is betaald, het lidnummer, de gemiddelde boete (2 decimalen) en het aantal boetes.

SELECT l.lidnr, round(AVG(b.bedrag),2) AS gemiddelde_boete, COUNT(b.betalingnummer) AS aantal_boetes 
FROM Lid l, Boete b 
WHERE l.lidnr = b.lidnummer 
GROUP BY l.lidnr;

-- 2.	Geef het lidnummer van elke speler voor wie in totaal meer dan €15.- aan boetes is betaald.

SELECT boete.lidnummer, SUM(bedrag) AS totaal_boetes 
FROM Boete 
GROUP BY lidnummer 
HAVING SUM(bedrag) > 15;

-- 3.	Geef de voorletters, tussenvoegsel en achternaam en het aantal boetes van elk lid voor wie meer dan één boete is betaald.

SELECT l.voorletters, l.tussenvoegsel, l.achternaam, COUNT(b.betalingnummer) AS aantal_boetes 
FROM Lid l, Boete b 
WHERE l.lidnr=b.lidnummer 
GROUP BY l.achternaam, l.voorletters, l.tussenvoegsel  
HAVING COUNT(b.betalingnummer) > 1;

-- 4.	Geef van elk team de teamcode, het totaal aantal thuis gewonnen wedstrijden.

SELECT teamthuis, count(scorethuis) AS thuisgewonnen 
FROM Wedstrijd 
WHERE scorethuis > scoreuit 
GROUP BY teamthuis;





