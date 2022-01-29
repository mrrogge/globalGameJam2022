package com;

/**
    Some hardcoded layer indices
**/
enum abstract LayerKind(Int) from Int to Int {
    var BG = 0;
    var BACK_OBJECTS = 1;
    var MID_OBJECTS = 2;
    var FRONT_OBJECTS = 3;
    var UI = 4;
}