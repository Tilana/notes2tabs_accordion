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
  description: qsTr("Divides a song in push and pull sections. Push notes are colored red, pull sections green.")
  menuPath: "Plugins.push_or_pull"

  property variant col_push  : "#DD0000"
  property variant col_pull  : "#008800"

  // Some notes exist only in push or pull direction. If these appear they will determine the push and pull sections
  property variant only_push: [78];
  property variant only_pull: [61, 68, 71];
     
  function switch_color (color) {
  
      console.log("switch_color");
  
      if (color == col_push) {
            return col_pull;
      }
      else{
            return col_push;
      }
  }

  onRun: {

    if (typeof curScore === 'undefined'){
      Qt.quit();
    }
    var cursor = curScore.newCursor();
    var count = 0;
    var startStaff;
    var endStaff;
    var endTick;
    var fullScore = false;

    // set default to push
    var curr_col = col_push;
    cursor.rewind(1);
    
    
    // no selection
    if (!cursor.segment) {
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
        
          cursor.segment.color = col_pull;
          
          if (cursor.element.type == Element.REST && count > 0) {
            console.log('REST & SWITCH');
            curr_col = switch_color(curr_col);
            count = 0;
          }
          
          
          if (cursor.element && cursor.element.type == Element.CHORD) {
          
            var graceChords = cursor.element.graceNotes;
            var notes = cursor.element.notes;   
            

            
            for (var i = 0; i < notes.length; i++) {

                  var orgPitch = notes[i].pitch
                  var orgTPC = notes[i].tpc
          
                  console.log("Pitch: " + notes[i].pitch + " - tpc: " + notes[i].tpc);
                  console.log("Count: " + count);
                  console.log("Color: " + curr_col);
                  
                  if (count > 12) {
                     
                      console.log('Counter reached maximum');
                      curr_col = switch_color(curr_col);
                      count = 0;
                  }


                  if (only_pull.indexOf(orgPitch) != -1){
                        
                        console.log('ONLY PULL');
                  
                        if (curr_col == col_push) {
                        
                              curr_col = switch_color(curr_col);
                              count = 0;
                        }

                 }
                 
                 if (only_push.indexOf(orgPitch) != -1){
                        
                        console.log('ONLY PUSH');
                  
                        if (curr_col == col_pull) {
                        
                              curr_col = switch_color(curr_col);
                              count = 0;
                        }

                 }
                 
                  notes[i].color = curr_col;
                  count = count + 1;

                  
    } // end for note       
          } // end if CHORD
          cursor.next();
        } // end while segment
      } // end for voice
        
    } // end for staff
    Qt.quit();
  } // end onRun
}
