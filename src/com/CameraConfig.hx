package com;

class CameraConfig {
    public var lockX:Float;
    public var lockY:Float;
    public var enableLock:Bool;
    public var moveType:CameraConfigMoveType;
    public var deadzone:core.MutRect;
    public var enableDeadzoneX = true;
    public var enableDeadzoneY = true;


    public function new() {
        lockX = 0;
        lockY = 0;
        enableLock = true;
        moveType = DAMPENED(1);
        deadzone = new core.MutRect();
    }
}

enum CameraConfigMoveType {
    LINEAR(speed:Float);
    DAMPENED(stiffness:Float);
    NULL;
}