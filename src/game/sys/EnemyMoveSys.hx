package game.sys;

class EnemyMoveSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();
    public var onCollisionSlot:heat.event.Slot<col.ECollision>;

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.enemyStates).with(coms.velocities).with(coms.objects);
        onCollisionSlot = new heat.event.Slot(onCollision);
    }

    public function update(dt:Float) {
        var speed = 24.;
        for (id in query.iter()) {
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
}