# notes2tabs_accordion

MuseScore Plugin zur Umwandlung von Noten in Griffschrift für eine 3-reihige Clubharmonika mit C-F Stimmung.



Die Konversionstabelle ist hier zu sehen:

![](/home/natalie/Documents/Noten2Griffschrift/notes2tab_accordion/conversion_table.png)





## Koversionsprozess



**(1)  Zug und Druck Passagen festlegen**

In den Plugins rufe das Skript *push_or_pull.qml* auf. Es legt fest welche Passagen auf Druck und welche auf Zug gespielt werden.

Dabei wird die folgende Heuristik befolgt:

- Manche Töne können auf der Harmonika nur im Zug oder Druck gespielt werden. Daher bestimmen diese Töne ob dieser Teil im Zug oder Druck gespielt wird
- Zug/Druck Passagen dürfen nicht zu lange oder zu kurz sein (ca. 3-4 Takte??)
- Pausen dienen als bevorzugte Wechselstellen
- Druck wird bevorzugt



**(2) Umwandlung**

Wende das *notes2tabs.qml* Plugin an

- Je nach Zug / Druck Markierung werden die Noten transponiert
- Druck Passagen werden mit einem Balken unter den Notenlinien markiert 
- gibt es mehrere Möglichkeiten einen Ton zu spielen so werden alle angezeigt. 



**(3) Nachbearbeitung**

In den Plugins wähle das *remove_colored_notes.qml* Skript aus.

Die Originalnoten, die jetzt farbig markiert sind werden entfernt

Spieler:innen müssen nun noch manuel den Notenschlüssel, sowie die Vorzeichen löschen, da diese in der Griffschrift keine Verwendung finden





## Schritt für Schritt Anleitung

(1) Lied in Musescore erstellen und abspeichern

(2) Eine Kopie davon öffnen! (falls bei der Umwandlung etwas schief geht haben wir noch die Orginaldatei und müssen nicht das Lied neu abtippen)

​		` --> Kopie speichern (anderer Name, bspws _Griffschrift)

​			--> Kopie öffnen `



(3) Wende die oben genannten Schritte an

