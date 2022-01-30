package game.sys;

class TweenerSys {
    var tweeners:heat.ecs.ComMap<Tweener>;
    var query = new heat.ecs.ComQuery();

    public function new(tweeners:heat.ecs.ComMap<Tweener>) {
        this.tweeners = tweeners;
        query.with(tweeners);
    }

    public function update(dt:Float) {
        query.run();
        for (id in query.result) {
            tweeners[id].update(dt);
        }
    }
}