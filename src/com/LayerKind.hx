package com;

/**
    Some hardcoded layer indices
**/
enum abstract LayerKind(Int) from Int to Int {
    var BG = 0;
    var FLOOR = 1;
    var OBJECTS1 = 2;
    var OBJECTS2 = 3;
    var UI = 4;
}