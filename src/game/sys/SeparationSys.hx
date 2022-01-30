package game.sys;

class SeparationSys {
    var coms:ComStore;
    public var onCollisionSlot:heat.event.ISlot<col.ECollision>;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        onCollisionSlot = new heat.event.Slot(onCollision);
        query.with(coms.kindComs)
            .with(coms.collidables)
            .with(coms.objects);
    }

    function shouldSeparate(kind1:Kind, kind2:Kind):Bool {
        return switch kind1 {
            case HERO: switch kind2 {
                case BARRIER: true;
                case HERO, ENEMY, BULLET(_), PICKUP(_), ENEMY_BARRIER: false;
            }
            case ENEMY: switch kind2 {
                case BARRIER, ENEMY_BARRIER: true;
                case HERO, ENEMY, BULLET(_), PICKUP(_): false;
            }
            case BULLET(_), PICKUP(_): false;
            case BARRIER: switch kind2 {
                case HERO, ENEMY: true;
                case BULLET(_), PICKUP(_), BARRIER, ENEMY_BARRIER: false;
            }
            case ENEMY_BARRIER: switch kind2 {
                case ENEMY: true;
                case HERO, BULLET(_), PICKUP(_), BARRIER, ENEMY_BARRIER: false;
            }
        }
    }

    function onCollision(event:col.ECollision) {
        if (!query.checkId(event.id1) || !query.checkId(event.id2)) return;
        var kind1 = coms.kindComs[event.id1];
        var kind2 = coms.kindComs[event.id2];
        if (!shouldSeparate(kind1, kind2)) return;
        var pos1 = coms.objects[event.id1];
        if (pos1 == null) return;
        var pos2 = coms.objects[event.id2];
        if (pos2 == null) return;
        var collidable1 = coms.collidables[event.id1];
        if (collidable1 == null) return;  
        var collidable2 = coms.collidables[event.id2];
        if (collidable2 == null) return;   
        if (collidable1.movable && collidable2.movable) {
            pos1.x += event.separateX1/2;
            pos1.y += event.separateY1/2;
            pos2.x += event.separateX2/2;
            pos2.y += event.separateY2/2;
        }
        else if (collidable1.movable && !collidable2.movable) {
            pos1.x += event.separateX1;
            pos1.y += event.separateY1;
        }
        else if (!collidable1.movable && collidable2.movable) {
            pos2.x += event.separateX2;
            pos2.y += event.separateY2;
        }
    }
}