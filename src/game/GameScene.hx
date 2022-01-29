package game;

class GameScene extends Scene {
    override public function new(app:App)
    {
        super(app);

        var id = coms.getIntId();
        var collidable = new col.Collidable(0, 0, 200, 50);
        collidable.movable = false;
        coms.collidables[id] = collidable;
        var tile = assetService.getTileFromSpriteKind(RECT(0, 0, Std.int(w), Std.int(h), color, 1));
        var bitmap = new h2d.Bitmap(tile);
        bitmap.setPosition(x, y);
        coms.bitmaps[id] = bitmap;
        scene.heapsScene.addChildAt(bitmap, LayerKind.OBJECTS1);
        coms.posComs[id] = new heaps.ObjPosAdapter(bitmap);
        coms.kindComs[id] = Kind.BARRIER;

    }
}