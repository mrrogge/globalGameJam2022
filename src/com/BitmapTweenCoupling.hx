package com;

typedef BitmapTweenCoupling = {
    bitmapId:heat.ecs.EntityId,
    tweenId:heat.ecs.EntityId,
    kind:BitmapTweenCouplingKind
}

enum BitmapTweenCouplingKind {
    TILE_DX;
    TILE_DY;
}