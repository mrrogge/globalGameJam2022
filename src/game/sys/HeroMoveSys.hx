package game.sys;

class HeroMoveSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();
    public var onActionSlot(default, null):heat.event.Slot<EAction>;
    public var onCollisionSlot(default, null):heat.event.Slot<col.ECollision>;
    public var bulletSignal(default, null):heat.event.ISignal<ESpawnBullet>;
    var bulletSignalEmitter = new heat.event.SignalEmitter<ESpawnBullet>();
    public var onKilledSlot(default, null):heat.event.Slot<EKilled>;

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.heroStates).with(coms.velocities).with(coms.mass)
            .with(coms.objects);
        onActionSlot = new heat.event.Slot(onAction);
        onCollisionSlot = new heat.event.Slot(onCollision);
        bulletSignal = bulletSignalEmitter.signal;
        onKilledSlot = new heat.event.Slot(onKilled);
    }

    public function update(dt:Float) {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var state = coms.heroStates[id];
            var vel = coms.velocities[id];
            var mass = coms.mass[id];
            var moveLeftCmd = state.moveLeftCmd && !state.moveRightCmd;
            var moveRightCmd = !state.moveLeftCmd && state.moveRightCmd;
            var idleCmd = !moveLeftCmd && !moveRightCmd;

            if (moveLeftCmd) state.faceDir = LEFT;
            else if (moveRightCmd) state.faceDir = RIGHT;

            switch state.movingState {
                case IDLE: {
                    if (moveLeftCmd) {
                        state.movingState = ACCEL_LEFT;
                        state.moveAccTween.reset();
                    }
                    else if (moveRightCmd) {
                        state.movingState = ACCEL_RIGHT;
                        state.moveAccTween.reset();
                    }
                }
                case ACCEL_LEFT: {
                    state.moveAccTween.update(dt);
                    object.x -= state.moveAccTween.current * dt;
                    if (!moveLeftCmd) {
                        state.movingState = DECEL_LEFT;
                        state.moveDecTween.reset();
                    }
                    else if (state.moveAccTween.justFinished) {
                        state.movingState = CONST_LEFT;
                    }
                }
                case CONST_LEFT: {
                    object.x -= state.moveAccTween.current * dt;
                    if (!moveLeftCmd) {
                        state.movingState = DECEL_LEFT;
                        state.moveDecTween.reset();
                    }
                }
                case DECEL_LEFT: {
                    state.movingState = IDLE;
                }
                case ACCEL_RIGHT: {
                    state.moveAccTween.update(dt);
                    object.x += state.moveAccTween.current * dt;
                    if (!moveRightCmd) {
                        state.movingState = DECEL_RIGHT;
                        state.moveDecTween.reset();
                    }
                    else if (state.moveAccTween.justFinished) {
                        state.movingState = CONST_RIGHT;
                    }
                }
                case CONST_RIGHT: {
                    object.x += state.moveAccTween.current * dt;
                    if (!moveRightCmd) {
                        state.movingState = DECEL_RIGHT;
                        state.moveDecTween.reset();
                    }
                }
                case DECEL_RIGHT: {
                    state.movingState = IDLE;
                }
            }

            switch state.jumpState {
                case GROUND: {
                    if (!state.jumpCmdPrev && state.jumpCmd) {
                        state.jumpState = RISE_ACC;
                        state.jumpAccTween.reset();
                        state.jumpVel = state.jumpAccTween.start;
                    }
                }
                case RISE_ACC: {
                    state.jumpAccTween.update(dt);
                    state.jumpVel += state.jumpAccTween.delta;
                    object.y -= state.jumpVel * dt;
                    if (!state.jumpCmd || state.jumpAccTween.justFinished) {
                        state.jumpState = RISE_DEC;
                        state.jumpDecTween.reset();
                        state.jumpVel = state.jumpAccTween.current;
                        state.jumpVel -= state.jumpDecTween.start;
                    }
                }
                case RISE_DEC: {
                    state.jumpDecTween.update(dt);
                    state.jumpVel -= state.jumpDecTween.delta;
                    object.y -= state.jumpVel * dt;
                    if (state.jumpDecTween.justFinished || state.jumpVel <= 0) {
                        state.jumpState = FLOAT;
                        state.jumpVel = 0;
                    }
                }
                case FLOAT: {
                    //wait for ground to be detected via collision signal
                    //add a little extra gravity
                    // vel.y += mass * 200 * dt;
                }
            }

            state.jumpCmdPrev = state.jumpCmd;
        }
    }

    public function onAction(arg:EAction) {
        switch arg {
            case BOOL(MOVE_HERO(dir), boolState): {
                for (id in query.iter()) {
                    var state = coms.heroStates[id];
                    switch dir {
                        case LEFT: state.moveLeftCmd = boolState;
                        case RIGHT: state.moveRightCmd = boolState;
                        case UP: state.jumpCmd = boolState;
                        case DOWN: {}
                    }
                }
            }
            case BOOL(HERO_SHOOT(energy), boolState): {
                if (!boolState) return;
                for (id in query.iter()) {
                    var state = coms.heroStates[id];
                    var object = coms.objects[id];
                    var event = new ESpawnBullet();
                    event.setPos(object.x, object.y-16);
                    switch state.faceDir {
                        case LEFT: {
                            event.setVel(-500, 0);
                        }
                        case RIGHT: {
                            event.setVel(500, 0);
                        }
                        case UP, DOWN: {}
                    }
                    event.setKind(HERO, energy);
                    bulletSignalEmitter.emit(event); 
                }
            }
            default: {}
        }
    }

    public function onCollision(arg:col.ECollision) {
        var kind1 = coms.kindComs[arg.id1];
        if (kind1 == null) return;
        var kind2 = coms.kindComs[arg.id2];
        if (kind2 == null) return;
        var heroId:EntityId = null;
        var floorId:EntityId = null;
        var normalY:Float = 0;
        switch kind1 {
            case HERO: {
                heroId = arg.id1;
                normalY = arg.normal1.y;
            }
            case BARRIER: floorId = arg.id1;
            default: {}
        }
        switch kind2 {
            case HERO: {
                heroId = arg.id2;
                normalY = arg.normal2.y;
            }
            case BARRIER: floorId = arg.id2;
            default: {}
        }
        if (heroId == null || floorId == null) return;
        var heroState = coms.heroStates[heroId];
        if (heroState == null) return;
        if (normalY < 0) {
            heroState.jumpState = switch heroState.jumpState {
                case FLOAT: GROUND;
                default: heroState.jumpState;
            }
        }
    }

    function onKilled(arg:EKilled) {
        var heroState = coms.heroStates[arg.targetId];
        if (heroState == null) return;
        //TODO proper game over handling
        trace("YOU DIED");
    }
}