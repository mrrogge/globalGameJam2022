package game.sys;

class FrictionSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.velocities);
    }

    public function update(dt:Float) {
        var mag = 1000;
        query.run();
        for (id in query.result) {
            var vel = coms.velocities[id];
            if (vel.x > 0) {
                vel.x -= Math.min(vel.x, mag*dt);
            }
            else if (vel.x < 0) {
                vel.x += Math.min(-vel.x, mag*dt);
            }
        }
    }
}