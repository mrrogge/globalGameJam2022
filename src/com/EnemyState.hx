package com;

class EnemyState {
    public var movingState:EnemyMovingState = LEFT;

    public function new() {

    }
}

enum EnemyMovingState {
    LEFT;
    RIGHT;
}