package com;

class Velocity {
    public var x:Float;
    public var y:Float;
    public var prevPos:{x:Float,y:Float};

    public function new(x=0., y=0., prevPosX=0., prevPosY=0.) {
        this.x = x;
        this.y = y;
        prevPos = {x:prevPosX, y:prevPosY};
    }
}