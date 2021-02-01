//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyrigt  (C) 2015 Be-3
//  
//  Based on colornotes by Werner Schweer et al.
//  and on colornotes2 improved by Djamana
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 3.0

MuseScore {
      version:  "2.0"
      description: qsTr("Remove Colored Notes")
      menuPath: "Plugins.remove_colored_notes"

  
      property variant col_black : "#000000"
      property variant col_push  : "#DD0000"
      property variant col_pull  : "#008800"


      function colorNote(note) {
		  

		// Color black notes and
		// make colored notes black
		if (note.color != col_black)
			noteColor = col_black
                else
                  return;

	 // color note		
		applyColorOn( note );

	 // color # or b
		applyColorOn( note.accidental );

	 // color . or ..
		forEach ( note.dots, applyColorOn );


/////////////////////////////////////////////////////

        //
        // color also the stem and beam of the note
        //
            var the = cursor.element;
            applyColorOn( the.stem );
            applyColorOn( the.hook);      
        //  applyColorOn( the.beam);      
            applyColorOn( the.stemSlash);      
         // ^- UNCOMMENT/delete these lines if you don't like this!

///////////////////////////////////////////////////////



	 //////////////////////////////////////
	 // Helper function [closure]
		var noteColor;

		function applyColorOn( myObj ) {
			if (myObj) {
		    	myObj.color = noteColor;
                                  
			}
		}
		  
	 }



      // Apply the given function to all notes in selection
      // or, if nothing is selected, in the entire score

      property variant cursor : curScore.newCursor();
 

      function applyToNotesInSelection() {

      var rewind = {    score_start       : 0,
                        selection_start   : 1,
                        selection_end     : 2
                   }


            var startStaff = 0; // start with 1st staf
            var endStaff = curScore.nstaves - 1; // and end with last

            var endTick = 0xffffffff;

           cursor.rewind(rewind.selection_start);

           var fullScore = !cursor.segment;


            if (!fullScore) {
                  startStaff = cursor.staffIdx;

                  cursor.rewind( rewind.selection_end );
                  if (cursor.tick == 0) {
                        // this happens when the selection includes
                        // the last measure of the score.
                        // rewind( rewind.selection_end ) goes behind the last segment (where
                        // there's none) and sets tick=0
                        endTick = curScore.lastSegment.tick + 1;
                  } else {
                        endTick = cursor.tick;
                  }

                  endStaff = cursor.staffIdx;
            }

            console.log(startStaff + " - " + endStaff + " : ..." + endTick)

            // Loop through staffs, voices, measures...
            for (var staff = startStaff; staff <= endStaff; staff++) {


                  for (var voice in [1,2,3,4]) {

	                  cursor.rewind(rewind.selection_start);

                        if (fullScore)
                              cursor.rewind(rewind.score_start) // if no selection, beginning of score

                     // Attention: voice & staff has to be set after 'goTo '
                        cursor.staffIdx = staff;
                        cursor.voice = voice;

                     // Loop through measures ...
                        while ( cursor.segment && 
                               (cursor.tick < endTick) ) {

                              
                              if (cursor.element && 
                                  cursor.element.type == Element.CHORD) {
									  

                                    forEach(cursor.element.graceNotes, 
                                          function (graceChords){
                                                // iterate through all grace chords 
                                                forEach(graceChords.notes, colorNote)
                                          })

                                    var chord = cursor.element
                                    var notes = cursor.element.notes;
                                    //forEach(cursor.element.notes, colorNote)

                                    for (var i = 0; i < notes.length; i++) {

                                          console.log("Note: "+i);
                                          console.log(notes[i].color);
                                          console.log("Pitch: " + notes[i].pitch + " - tpc: " + notes[i].tpc)
                                          if (notes[i].color!="#000000"){
                                          console.log(" Color not black!!" );
                                                chord.remove(notes[i]);
                                          }
                                          //if (typeof notes[i].pitch === "undefined") // just in case
                                          //return;
                                    }
                                  

                              }

                              cursor.next();
                        }
                  }
            }
      }


	// Some Helper function
	function forEach(items, func) {
		  for (var i in items)
				func(items[i]);
	}

		 
      onRun: {
            console.log("Griffschrift: Farbmarkierungen (Zug/Druck) entfernen");

            if (typeof curScore !== 'undefined')
                 applyToNotesInSelection()

            Qt.quit();
         }
}

