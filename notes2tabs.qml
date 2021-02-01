//
// Harmonica Tabs Plugin
//
// Copyright (C) 2015 Be-3
//
// Based on Note Names Plugin
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License version 2
// as published by the Free Software Foundation and appearing in
// the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 3.0

MuseScore {
  version: "2.0"
  description: qsTr("Converts notes into tabulature for button accordion.")
  menuPath: "Plugins.notes2tabs"

  property variant col_push  : "#DD0000"
  property variant col_pull  : "#008800"
   
     
     property variant first_octave_push: {
                                           60: [{'pitch': 60, 'tcp': 14, 'acc': 0}, {'pitch': 62, 'tcp': 16, 'acc': 0}],  // c'
                                           61: [],                                        // c#'
                                           62: [{'pitch': 59, 'tcp': 26, 'acc': 1}],      // d'
                                           63: [{'pitch': 62, 'tcp': 23, 'acc': 1}],      // d#'
                                           64: [{'pitch': 65, 'tcp': 13, 'acc': 0}],      // e'
                                           65: [{'pitch': 64, 'tcp': 18, 'acc': 0}],      // f'
                                           66: [{'pitch': 69, 'tcp': 17, 'acc': 1}],      // f#'
                                           67: [{'pitch': 69, 'tcp': 17, 'acc': 0}],      // g'
                                           68: [],                                        // g#'
                                           69: [{'pitch': 67, 'tcp': 15, 'acc': 0}],      // a'
                                           70: [{'pitch': 65, 'tcp': 13, 'acc': 1}],      // a#'
                                           71: [],                                        // b'                                           
                                           72: [{'pitch': 71, 'tcp': 19, 'acc': 0}, {'pitch': 72, 'tcp': 14, 'acc': 0}],  // c''
                                           73: [],                                         // c#''                                           
                                           74: [{'pitch': 76, 'tcp': 25, 'acc': 1}],       // d''
                                           75: [{'pitch': 73, 'tcp': 19, 'acc': 1}],       // d#''
                                           76: [{'pitch': 76, 'tcp': 18, 'acc': 0}],       // e''
                                           77: [{'pitch': 74, 'tcp': 18, 'acc': 0}],       // f''
                                           
                                           78: [{'pitch': 69, 'tcp': 18, 'acc': 1}],      // f#''
                                           79: [{'pitch': 79, 'tcp': 18, 'acc': 0}],      // g''
                                           80: [],                                        // g#''
                                           81: [{'pitch': 77, 'tcp': 19, 'acc': 0}],      // a''
                                           82: [],                                        // a#''
                                           83: [],                                        // b''                                           
                                           84: [{'pitch': 81, 'tcp': 19, 'acc': 0}, {'pitch': 83, 'tcp': 19, 'acc': 0}],      // c'''
                                            }
                                            
      property variant first_octave_pull: {
                                           60: [{'pitch': 57, 'tcp': 17, 'acc': 0}],      // c'
                                           61: [{'pitch': 62, 'tcp': 23, 'acc': 1}],      // c#'
                                           62: [{'pitch': 62, 'tcp': 23, 'acc': 0}],      // d'
                                           63: [{'pitch': 59, 'tcp': 19, 'acc': 1}],      // d#'
                                           64: [{'pitch': 60, 'tcp': 14, 'acc': 0}],      // e'
                                           65: [{'pitch': 65, 'tcp': 13, 'acc': 0}],      // f'
                                           66: [{'pitch': 65, 'tcp': 13, 'acc': 1}],      // f#'
                                           67: [{'pitch': 64, 'tcp': 18, 'acc': 0}],      // g'
                                           68: [{'pitch': 69, 'tcp': 17, 'acc': 1}],      // g#'
                                           69: [{'pitch': 69, 'tcp': 17, 'acc': 0}],      // a'
                                           70: [{'pitch': 67, 'tcp': 15, 'acc': 0}],      // a#'
                                           71: [{'pitch': 72, 'tcp': 14, 'acc': 0}],      // b'                                           
                                           
                                           72: [{'pitch': 71, 'tcp': 19, 'acc': 0}],      // c''
                                           73: [{'pitch': 72, 'tcp': 21, 'acc': 1}],      // c#''
                                           74: [{'pitch': 76, 'tcp': 23, 'acc': 0}],      // d''
                                           75: [{'pitch': 76, 'tcp': 19, 'acc': 1}],      // d#''
                                           76: [{'pitch': 74, 'tcp': 14, 'acc': 0}],      // e''
                                           77: [{'pitch': 79, 'tcp': 13, 'acc': 0}],      // f''
                                           78: [],                                        // f#''
                                           79: [{'pitch': 77, 'tcp': 13, 'acc': 0}],      // g''
                                           80: [{'pitch': 80, 'tcp': 22, 'acc': 1}],      // g#''
                                           81: [{'pitch': 83, 'tcp': 19, 'acc': 0}],      // a''
                                           82: [{'pitch': 81, 'tcp': 17, 'acc': 0}],      // a#''
                                           83: [{'pitch': 86, 'tcp': 16, 'acc': 0}],      // b''                                           
                                           84: [{'pitch': 89, 'tcp': 19, 'acc': 0}],      // c'''
                                           
                                            }



  function tabNotes (notes, text) {

    for (var i = 0; i < notes.length; i++) {

      var dir = 0
      var note = 0
      var mapping = 0
      var pitch = 0
      var tpc   = 0
      var newNote = newElement(Element.NOTE);

      var orgPitch = notes[i].pitch
      var orgTPC = notes[i].tpc
      
      var accidental
      
      console.log("Note: "+i)
      console.log(orgPitch)
      console.log("Pitch: " + notes[i].pitch + " - tpc: " + notes[i].tpc)
      
      if (typeof notes[i].pitch === "undefined") // just in case
      return;

      switch (notes[i].color) {
        case col_push: dir =  1; break;
        case col_pull: dir = -1; break;
        default: dir = 1;
      }
      
      mapping = first_octave_pull[orgPitch];
      if (notes[i].color == col_push){
            console.log('PUSH _COLOR');
            mapping = first_octave_push[orgPitch];
            text.text = text.text + '_';
      }

      if ((orgPitch >= 60 && orgPitch <= 84) && (mapping.length > 0)){
      
        var newNotes = [];
        
        for (var map_idx = 0; map_idx < mapping.length; map_idx++) {
            note = mapping[map_idx].pitch;
            tpc = mapping[map_idx].tcp;
            console.log("Transposed note: " + note + " - tpc: " + tpc);
            
            newNote.pitch = note;
            newNote.tpc1 = tpc;
            newNote.tpc2 = tpc;

            if (mapping[map_idx].acc==1) {
                  console.log('ACCIDENTAL')
                  newNote.headType = 5;
                  }
            newNotes[map_idx] = newNote;    
            
            }
              
      return newNotes;
      }
      
      else {
        console.log("Not out of range or not transposable");
        return [];
      }
    } 
  }

  onRun: {
    if (typeof curScore === 'undefined')
      Qt.quit();
    var cursor = curScore.newCursor();
    var startStaff;
    var endStaff;
    var endTick;
    var fullScore = false;
    cursor.rewind(1);

    if (!cursor.segment) {
      // no selection
      fullScore = true;
      startStaff = 0; // start with 1st staff
      endStaff = curScore.nstaves - 1; // and end with last
    } else {
      startStaff = cursor.staffIdx;
      cursor.rewind(2);
      if (cursor.tick == 0) {
        endTick = curScore.lastSegment.tick + 1;
      } else {
        endTick = cursor.tick;
      }
      endStaff = cursor.staffIdx;
    }
    console.log(startStaff + " - " + endStaff + " - " + endTick);

    for (var staff = startStaff; staff <= endStaff; staff++) {
      for (var voice = 0; voice < 4; voice++) {
        cursor.rewind(1); // beginning of selection
        cursor.voice = voice;
        cursor.staffIdx = staff;

        if (fullScore) // no selection
        cursor.rewind(0); // beginning of score

        while (cursor.segment && (fullScore || cursor.tick < endTick)) {
          if (cursor.element && cursor.element.type == Element.CHORD) {
            var text = newElement(Element.STAFF_TEXT);
            var graceChords = cursor.element.graceNotes;
            }

            var notes = cursor.element.notes;
            
            var newNotes = tabNotes(notes, text);
            for (var i = 0; i < notes.length; i++) {
                  console.log("ADD ELEM" + i);
                  cursor.element.add(newNotes[i]);
            }

          } // end if CHORD
          cursor.next();
        } // end while segment
      } // end for voice
    } // end for staff
    Qt.quit();
  } // end onRun
}
