package game.sys;

class ScrollingBitmapSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.bitmapTweenCouplings);
    }

    public function update(dt:Float) {
        query.run();
        for (id in query.result) {
            var coupling = coms.bitmapTweenCouplings[id];
            var bitmap = coms.bitmaps[coupling.bitmapId];
            if (bitmap == null) continue;
            var tween = coms.tweeners[coupling.tweenId];
            if (tween == null) continue;
            switch coupling.kind {
                case TILE_DX: bitmap.tile.dx = tween.current;
                case TILE_DY: {
                    bitmap.tile.dy = tween.current;
                }
            }
        }
    }
}