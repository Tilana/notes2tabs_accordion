# notes2tabs_accordion

A [MuseScore](https://musescore.org/en) plugin to convert notes into tablature for button accordion.





## The Instrument

This notes2tab converter is written for a three-row Club Accordion with C-F tuning, such as the *Weltmeister Club Harmonika 333*.

The following mapping displays the mapping from notes to tablature:

![](/home/natalie/Documents/Noten2Griffschrift/notes2tab_accordion/conversion_table.png)







## Step by Step Guide



**(1)  Determine the push and pull sections**
Apply the script *push_or_pull.qml* to your sheet. It will color the notes in green for pull and red for push sections. When coloring it follows some simple rules:

- With the button accordion some notes can only played as pull or as push notes. If they occur they will determine the current section type
- Push / Pull sections should be limited to a few measures. Therefore, a maximum number of 12 notes is hard coded after which push and pull sections will be switched
- Breaks are preferred changeover positions
- push is set as default

It's possible to manually adjust this process by coloring notes in the musescore sheet according to your own preferences.



**(2) Conversion**
Run the *notes2tabs.qml* plugin. Based on the notes coloring in the previous step it will convert them into tablature for button accordion.

Push sections will be marked with bar on top. If there are multiple ways of playing a note, right now, only one is shown.



**(3) Finalization**

In the last step the original (now colored) notes have to be removed. For this apply the *remove_colored_notes.qml* plugin.

Now, manually remove the clef, as well as the accidentals because the tablature does not have any of these.
