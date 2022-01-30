package game.sys;

class EnemyMoveSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();
    public var onCollisionSlot:heat.event.Slot<col.ECollision>;
    var disposedEnemyIds = new haxe.ds.GenericStack<heat.ecs.EntityId>();
    public var onKilledSlot:heat.event.Slot<EKilled>;
    public var spawnBulletSignal:heat.event.ISignal<ESpawnBullet>;
    var spawnBulletEmitter = new heat.event.SignalEmitter<ESpawnBullet>();
    public var onEnergizedSlot:heat.event.Slot<EEnergize>;

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.enemyStates).with(coms.velocities).with(coms.objects);
        onCollisionSlot = new heat.event.Slot(onCollision);
        onKilledSlot = new heat.event.Slot(onKilled);
        spawnBulletSignal = spawnBulletEmitter.signal;
        onEnergizedSlot = new heat.event.Slot(onEnergized);
    }

    public function update(dt:Float) {
        var speed = 24.;
        query.run();
        for (id in query.result) {
            var state = coms.enemyStates[id];
            var vel = coms.velocities[id];
            var object = coms.objects[id];

            switch state.movingState {
                case LEFT: object.x -= speed*dt;
                case RIGHT: object.x += speed*dt;
            }
        }
    }

    function onCollision(arg:col.ECollision) {
        var kind1 = coms.kindComs[arg.id1];
        if (kind1 == null) return;
        var kind2 = coms.kindComs[arg.id2];
        if (kind2 == null) return;
        var enemyId:EntityId = null;
        var barrierId:EntityId = null;
        var normalX:Float = 0;
        switch kind1 {
            case ENEMY: {
                enemyId = arg.id1;
                normalX = arg.normal1.x;
            }
            case BARRIER, ENEMY_BARRIER: barrierId = arg.id1;
            default: {}
        }
        switch kind2 {
            case ENEMY: {
                enemyId = arg.id2;
                normalX = arg.normal2.x;
            }
            case BARRIER, ENEMY_BARRIER: barrierId = arg.id2;
            default: {}
        }
        if (enemyId == null || barrierId == null) return;
        var enemyState = coms.enemyStates[enemyId];
        if (enemyState == null) return;
        switch enemyState.movingState {
            case LEFT: {
                if (normalX > 0) enemyState.movingState = RIGHT;
            }
            case RIGHT: {
                if (normalX < 0) enemyState.movingState = LEFT;
            }
        }
    }

    public function disposeEnemies() {
        while (!disposedEnemyIds.isEmpty()) {
            var id = disposedEnemyIds.pop();
            coms.objects[id].remove();
            coms.objects.remove(id);
            coms.anims.remove(id);
            coms.bitmaps.remove(id);
            coms.enemyStates.remove(id);
            coms.kindComs.remove(id);
            coms.energyKinds.remove(id);
            coms.collidables.remove(id);
            coms.mass.remove(id);
            coms.velocities.remove(id);
            coms.healthComs.remove(id);
        }
    }

    function onKilled(arg:EKilled) {
        var state = coms.enemyStates[arg.targetId];
        if (state == null) return;
        disposedEnemyIds.add(arg.targetId);
    }

    function spawnBulletFromAngle(angle:Float, speed:Float, x:Float, y:Float, 
    energy:EnergyKind) 
    {
        spawnBulletEmitter.emit(new ESpawnBullet()
            .setPos(x, y-6)
            .setVel(Math.cos(angle)*speed, Math.sin(angle)*speed)
            .setKind(com.Kind.BulletKind.ENEMY, energy)
        );
    }

    function onEnergized(arg:EEnergize) {
        var state = coms.enemyStates[arg.targetId];
        var object = coms.objects[arg.targetId];
        var energy = coms.energyKinds[arg.targetId];
        if (state == null || object == null || energy == null) return;
        var speed = 100;
        spawnBulletFromAngle(0, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI/4, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI/2, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI*3/4, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI*5/4, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI*3/2, speed, object.x, object.y-16, energy);
        spawnBulletFromAngle(Math.PI*7/4, speed, object.x, object.y-16, energy);
    }
}