package game.sys;

class HeroMoveSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();
    public var actionSlot(default, null):heat.event.Slot<EAction>;

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.heroStates).with(coms.velocities).with(coms.objects);
        actionSlot = new heat.event.Slot(onAction);
    }

    public function update(dt) {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var state = coms.heroStates[id];
            var vel = coms.velocities[id];
            var moveLeftCmd = state.moveLeftCmd && !state.moveRightCmd;
            var moveRightCmd = !state.moveLeftCmd && state.moveRightCmd;
            var idleCmd = !moveLeftCmd && !moveRightCmd;

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
                    // state.moveDecTween.update(dt);
                    // var dVel = state.moveDecTween.current;
                    // if (vel.x + dVel < 0) {
                    //     object.x += dVel * dt;
                    // }
                    // else {
                    //     object.x += (dVel - vel.x) * dt;
                    //     state.movingState = IDLE;
                    // }
                    // if (moveLeftCmd) {
                    //     state.movingState = ACCEL_LEFT;
                    // }
                    // else if (state.moveDecTween.justFinished) {
                        state.movingState = IDLE;
                    // }
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
                    // state.moveDecTween.update(dt);
                    // var dVel = state.moveDecTween.current;
                    // if (vel.x - dVel > 0) {
                    //     object.x -= dVel * dt;
                    // }
                    // else {
                    //     object.x -= vel.x * dt;
                    //     state.movingState = IDLE;
                    // }
                    // if (moveRightCmd) {
                    //     state.movingState = ACCEL_RIGHT;
                    // }
                    // else if (state.moveDecTween.justFinished) {
                        state.movingState = IDLE;
                    // }
                }
            }
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
                        case UP,DOWN: {}
                    }
                }
            }
            default: {}
        }
    }
}