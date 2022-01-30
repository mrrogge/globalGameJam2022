package game;

class ESpawnBullet {
    public var x = 0.;
    public var y = 0.;
    public var velX = 0.;
    public var velY = 0.;
    public var kind:com.Kind.BulletKind = HERO;
    public var energyKind:com.EnergyKind = LIGHT;

    public function new() {

    }

    public function setPos(x:Float, y:Float):ESpawnBullet {
        this.x = x;
        this.y = y;
        return this;
    }

    public function setVel(x:Float, y:Float):ESpawnBullet {
        this.velX = x;
        this.velY = y;
        return this;
    }

    public function setKind(kind:com.Kind.BulletKind, energy:com.EnergyKind)
    :ESpawnBullet
    {
        this.kind = kind;
        this.energyKind = energy;
        return this;
    }
}