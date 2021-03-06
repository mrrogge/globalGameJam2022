package game;

/**
    TODO: eventually it will make sense to generate these through build macros. Need to be able to specify the com map property names and corresponding types. Also need to specify interfaces of ComStore "subsets" to allow code to be more modular.
**/
class ComStore {
    var _nextIntId = 1;

    public var anims(default, null) = new heat.ecs.ComMap<h2d.Anim>();
    public var bitmaps(default, null) = new heat.ecs.ComMap<h2d.Bitmap>();
    public var bitmapTweenCouplings(default, null) = new heat.ecs.ComMap<com.BitmapTweenCoupling>();
    public var collidables(default, null) = new heat.ecs.ComMap<col.Collidable>();
    public var heapsTexts(default, null) = new heat.ecs.ComMap<h2d.Text>();
    public var kindComs(default, null) = new heat.ecs.ComMap<com.Kind>();
    public var mass(default, null) = new heat.ecs.ComMap<Float>();
    public var objects(default, null) = new heat.ecs.ComMap<h2d.Object>();
    public var timers(default, null) = new heat.ecs.ComMap<com.Timer>();
    public var tweeners(default, null) = new heat.ecs.ComMap<com.Tweener>();
    public var userInputConfigs(default, null) = new heat.ecs.ComMap<UserInputConfig>();
    public var velocities(default, null) = new heat.ecs.ComMap<com.Velocity>();
    public var tileGroups(default, null) = new heat.ecs.ComMap<h2d.TileGroup>();
    public var heroStates(default, null) = new heat.ecs.ComMap<com.HeroState>();
    public var enemyStates(default, null) = new heat.ecs.ComMap<com.EnemyState>();
    public var bulletDataComs(default, null) = new heat.ecs.ComMap<com.BulletData>();
    public var energyKinds(default, null) = new heat.ecs.ComMap<com.EnergyKind>();
    public var healthComs(default, null) = new heat.ecs.ComMap<com.Health>();
    public var cameras(default, null) = new heat.ecs.ComMap<h2d.Camera>();
    public var camConfigs(default, null) = new heat.ecs.ComMap<com.CameraConfig>();

    public function new() {}

    public function getIntId():heat.ecs.EntityId {
        var id:heat.ecs.EntityId = _nextIntId++;
        return id;
    }

    public function disposeAll() {

    }

    public function disposeId(id:heat.ecs.EntityId) {
        preDisposeHook(id);

    }

    /**
        For custom dispose logic
    **/
    function preDisposeHook(id:heat.ecs.EntityId) {

    }
}