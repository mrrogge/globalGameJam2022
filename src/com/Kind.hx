package com;

/**
    A general-purpose category value for various comparisons, e.g. collision filtering and handling.
**/
enum Kind {
    HERO;
    ENEMY;
    BULLET(kind:BulletKind);
    PICKUP(kind:PickupKind);
    BARRIER;
}

enum BulletKind {
    HERO;
    ENEMY;
}

enum PickupKind {
    POWERUP;
    MONEY;
}