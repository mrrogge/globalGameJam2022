package game.sys;

class BulletSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();
    var scene:h2d.Scene;
    public var onSpawnBulletSlot:heat.event.Slot<ESpawnBullet>;
    public var onCollisionSlot:heat.event.Slot<col.ECollision>;
    var disposedBulletIds = new haxe.ds.GenericStack<heat.ecs.EntityId>();

    public function new(coms:ComStore, scene:h2d.Scene) {
        this.coms = coms;
        this.scene = scene;
        query.with(coms.objects).with(coms.bulletDataComs);
        onSpawnBulletSlot = new heat.event.Slot(onSpawnBullet);
        onCollisionSlot = new heat.event.Slot(onCollision);
    }

    public function update(dt:Float) {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var bulletData = coms.bulletDataComs[id];

            object.x += bulletData.velX * dt;
            object.y += bulletData.velY * dt;
        }
    }

    public function disposeBullets() {
        while (!disposedBulletIds.isEmpty()) {
            var id = disposedBulletIds.pop();
            coms.objects[id].remove();
            coms.objects.remove(id);
            coms.anims.remove(id);
            coms.bulletDataComs.remove(id);
            coms.kindComs.remove(id);
            coms.energyKinds.remove(id);
            coms.collidables.remove(id);
        }
    }

    function onSpawnBullet(arg:ESpawnBullet) {
        var id = coms.getIntId();
        var tiles:Array<h2d.Tile>;
        switch arg.kind {
            case HERO: {
                switch arg.energyKind {
                    case LIGHT: {
                        tiles = hxd.Res.img.heroBulletLight_png.toTile().split(2);
                    }
                    case DARK: {
                        tiles = hxd.Res.img.heroBulletDark_png.toTile().split(2);
                    }
                }
            }
            case ENEMY: {
                switch arg.energyKind {
                    case LIGHT: {
                        tiles = hxd.Res.img.enemyBulletLight_png.toTile().split(2);
                    }
                    case DARK: {
                        tiles = hxd.Res.img.enemyBulletDark_png.toTile().split(2);
                    }
                }
            }
        }
        for (tile in tiles) {
            tile.dx = 8;
            tile.dy = 8;
        }
        var anim = new h2d.Anim(tiles, 8);
        scene.addChildAt(anim, LayerKind.MID_OBJECTS);
        coms.anims[id] = anim;
        coms.objects[id] = anim;
        coms.bulletDataComs[id] = new BulletData(arg.velX, arg.velY);
        coms.collidables[id] = new col.Collidable(8, 8, 10, 10);
        coms.energyKinds[id] = arg.energyKind;
        coms.kindComs[id] = Kind.BULLET(arg.kind);
    }

    function onCollision(arg:col.ECollision) {
        var kind1 = coms.kindComs[arg.id1];
        if (kind1 == null) return;
        var kind2 = coms.kindComs[arg.id2];
        if (kind2 == null) return;
        if (!kind1.match(BULLET(_)) && !kind2.match(BULLET(_))) return;
        if (kind1.match(BULLET(_)) && kind2.match(BARRIER)) {
            disposedBulletIds.add(arg.id1);
        }
        else if (kind1.match(BARRIER) && kind2.match(BULLET(_))) {
            disposedBulletIds.add(arg.id2);
        }
        else if (kind1.match(BULLET(HERO)) && kind2.match(ENEMY)) {
            //damage enemy TODO
            disposedBulletIds.add(arg.id1); 
        }
        else if (kind1.match(ENEMY) && kind2.match(BULLET(HERO))) {
            //damage enemy TODO
            disposedBulletIds.add(arg.id2);
        }
        else if (kind1.match(BULLET(ENEMY)) && kind2.match(HERO)) {
            //damage hero TODO
            disposedBulletIds.add(arg.id1);
        }
        else if (kind1.match(HERO) && kind2.match(BULLET(ENEMY))) {
            //damage hero TODO
            disposedBulletIds.add(arg.id2);
        }
        else if (kind1.match(BULLET(HERO)) && kind2.match(BULLET(ENEMY))) {
            //light/dark logic TODO
            disposedBulletIds.add(arg.id1);
            disposedBulletIds.add(arg.id2);
        }
        else if (kind1.match(BULLET(ENEMY)) && kind2.match(BULLET(HERO))) {
            //light/dark logic TODO
            disposedBulletIds.add(arg.id1);
            disposedBulletIds.add(arg.id2);
        }
    }
}