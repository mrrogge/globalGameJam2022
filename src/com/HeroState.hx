package com;

class HeroState {
    public var movingState:MovingState = IDLE;
    public var moveLeftCmd = false;
    public var moveRightCmd = false;
    public var moveAccTween(default, null):Tweener;
    public var moveDecTween(default, null):Tweener;


    public function new() {
        var maxSpeed = 100;
        moveAccTween = new Tweener(0.2);
        moveAccTween.diff = maxSpeed;
        moveAccTween.easing = motion.easing.Quad.easeOut;
        moveAccTween.mode = ONCE;
        moveDecTween = new Tweener(0.2);
        moveDecTween.diff = maxSpeed;
        moveDecTween.easing = motion.easing.Quad.easeIn;
        moveDecTween.mode = ONCE;
    }
}

enum MovingState {
    IDLE;
    ACCEL_LEFT;
    CONST_LEFT;
    DECEL_LEFT;
    ACCEL_RIGHT;
    CONST_RIGHT;
    DECEL_RIGHT;
}