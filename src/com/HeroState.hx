package com;

class HeroState {
    public var movingState:MovingState = IDLE;
    public var moveLeftCmd = false;
    public var moveRightCmd = false;
    public var moveAccTween(default, null):Tweener;
    public var moveDecTween(default, null):Tweener;
    public var jumpState:JumpState = FLOAT;
    public var jumpCmd = false;
    public var jumpCmdPrev = false;
    public var jumpAccTween(default, null):Tweener;
    public var jumpDecTween(default, null):Tweener;
    public var jumpVel = 0.;
    public var faceDir:dir.Dir4 = RIGHT;


    public function new() {
        var maxSpeed = 300;
        moveAccTween = new Tweener(0.2);
        moveAccTween.start = 0;
        moveAccTween.diff = maxSpeed;
        moveAccTween.easing = motion.easing.Quad.easeOut;
        moveAccTween.mode = ONCE;
        moveDecTween = new Tweener(0.2);
        moveDecTween.start = 0;
        moveDecTween.diff = maxSpeed;
        moveDecTween.easing = motion.easing.Quad.easeIn;
        moveDecTween.mode = ONCE;
        jumpAccTween = new Tweener(0.1);
        jumpAccTween.start = 0;
        jumpAccTween.diff = 500;
        jumpAccTween.easing = motion.easing.Expo.easeOut;
        jumpAccTween.mode = ONCE;
        // jumpAccTween.onRunning = () -> jumpVel += jumpAccTween.delta;
        // jumpAccTween.onDone = () -> jumpVel = jumpAccTween.current;
        jumpDecTween = new Tweener(0.2);
        jumpDecTween.start = 0;
        jumpDecTween.diff = 500;
        jumpDecTween.easing = motion.easing.Sine.easeIn;
        jumpDecTween.mode = ONCE;
        // jumpDecTween.onRunning = () -> jumpVel -= jumpDecTween.delta;
        // jumpDecTween.onDone = () -> jumpVel = 0;
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

enum JumpState {
    RISE_ACC;
    RISE_DEC;
    FLOAT;
    GROUND;
}