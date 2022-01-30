package com;

class Velocity {
    public var x:Float;
    public var y:Float;
    public var prevPos:{x:Float,y:Float};
    public var xMax:Float;
    public var yMax:Float;

    public function new(x=0., y=0., prevPosX=0., prevPosY=0., xMax=1000, yMax=1000) {
        this.x = x;
        this.y = y;
        prevPos = {x:prevPosX, y:prevPosY};
        this.xMax = xMax;
        this.yMax = yMax;
    }
}