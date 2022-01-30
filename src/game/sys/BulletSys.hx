package game.sys;

class BulletSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();
    var scene:h2d.Scene;
    public var onSpawnBulletSlot:heat.event.Slot<ESpawnBullet>;
    public var onCollisionSlot:heat.event.Slot<col.ECollision>;
    var disposedBulletIds = new haxe.ds.GenericStack<heat.ecs.EntityId>();
    public var damageSignal:heat.event.ISignal<EDamage>;
    var damageEmitter = new heat.event.SignalEmitter<EDamage>();
    public var energizeSignal:heat.event.ISignal<EEnergize>;
    var energizeEmitter = new heat.event.SignalEmitter<EEnergize>();

    public function new(coms:ComStore, scene:h2d.Scene) {
        this.coms = coms;
        this.scene = scene;
        query.with(coms.objects).with(coms.bulletDataComs);
        onSpawnBulletSlot = new heat.event.Slot(onSpawnBullet);
        onCollisionSlot = new heat.event.Slot(onCollision);
        damageSignal = damageEmitter.signal;
        energizeSignal = energizeEmitter.signal;
    }

    public function update(dt:Float) {
        query.run();
        for (id in query.result) {
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
            tile.dx = -8;
            tile.dy = -8;
        }
        var anim = new h2d.Anim(tiles, 8);
        anim.setPosition(arg.x, arg.y);
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
            var bulletEnergy = coms.energyKinds[arg.id1];
            var targetEnergy = coms.energyKinds[arg.id2];
            if (!bulletEnergy.equals(targetEnergy)) {
                damageEmitter.emit({
                    damage: 1,
                    targetId: arg.id2
                });
            }
            else {
                energizeEmitter.emit({
                    targetId: arg.id2
                });
            }
            disposedBulletIds.add(arg.id1); 
        }
        else if (kind1.match(ENEMY) && kind2.match(BULLET(HERO))) {
            var bulletEnergy = coms.energyKinds[arg.id2];
            var targetEnergy = coms.energyKinds[arg.id1];
            if (!bulletEnergy.equals(targetEnergy)) {
                damageEmitter.emit({
                    damage: 1,
                    targetId: arg.id1
                });
            }
            else {
                energizeEmitter.emit({
                    targetId: arg.id1
                });
            }
            disposedBulletIds.add(arg.id2);
        }
        else if (kind1.match(BULLET(ENEMY)) && kind2.match(HERO)) {
            damageEmitter.emit({
                damage: 1,
                targetId: arg.id2
            });
            disposedBulletIds.add(arg.id1);
        }
        else if (kind1.match(HERO) && kind2.match(BULLET(ENEMY))) {
            damageEmitter.emit({
                damage: 1,
                targetId: arg.id1
            });
            disposedBulletIds.add(arg.id2);
        }
        else if (kind1.match(BULLET(HERO)) && kind2.match(BULLET(ENEMY))) {
            var heroEnergy = coms.energyKinds[arg.id1];
            var enemyEnergy = coms.energyKinds[arg.id2];
            if (heroEnergy.equals(enemyEnergy)) {
                energizeEmitter.emit({
                    targetId: arg.id2
                });
            }
            else {
                disposedBulletIds.add(arg.id2);
            }
            disposedBulletIds.add(arg.id1);
        }
        else if (kind1.match(BULLET(ENEMY)) && kind2.match(BULLET(HERO))) {
            var heroEnergy = coms.energyKinds[arg.id2];
            var enemyEnergy = coms.energyKinds[arg.id1];
            if (heroEnergy.equals(enemyEnergy)) {
                energizeEmitter.emit({
                    targetId: arg.id1
                });
            }
            else {
                disposedBulletIds.add(arg.id1);
            }
            disposedBulletIds.add(arg.id2);
        }
    }
}