package game.sys;

class GravitySys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.mass).with(coms.velocities).with(coms.objects);
    }

    public function update(dt:Float) {
        var g = 2;
        for (id in query.iter()) {
            var mass = coms.mass[id];
            var velocity = coms.velocities[id];
            var object = coms.objects[id];
            object.y += mass * g * dt;
            if (velocity.y > 0) {
                object.y += velocity.y * mass * g * dt / 20;
                // trace(velocity.y);
            }
            // velocity.y += mass * g * dt;
        }
    }
}