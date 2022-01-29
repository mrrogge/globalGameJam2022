package game;

class BackgroundBuilder {
    var coms:ComStore;

    var tile:h2d.Tile;
    var tileWidth:Float;
    var tileHeight:Float;
    var width:Float;
    var height:Float;
    var parent:h2d.Object;
    var layer:Null<Int>;
    var _autoScrollX = false;
    var autoScrollRateX = 1.;
    var _autoScrollY = false;
    var autoScrollRateY = 1.;
    var _autoFlipX = false;
    var autoFlipRateX = 1.;
    var _autoFlipY = false;
    var autoFlipRateY = 1.;
    var _randScrollX = false;
    var randScrollRateX = 1.;
    var _randScrollY = false;
    var randScrollRateY = 1.;
    var alpha = 1.;

    public function new(coms:ComStore) {
        this.coms = coms;
        setTile(h2d.Tile.fromColor(0x220000));
    }

    public function setTile(tile:h2d.Tile):BackgroundBuilder {
        this.tile = tile;
        tileWidth = tile.width;
        tileHeight = tile.height;
        return this;
    }

    public function setParent(parent:h2d.Object, ?layer:Int):BackgroundBuilder {
        this.parent = parent;
        this.layer = layer;
        return this;
    }

    public function setSize(width:Float, height:Float):BackgroundBuilder {
        this.width = width;
        this.height = height;
        return this;
    }

    public function autoScrollX(enabled:Bool, rate=1.):BackgroundBuilder {
        _autoScrollX = enabled;
        autoScrollRateX = rate;
        return this;
    }

    public function autoScrollY(enabled:Bool, rate=1.):BackgroundBuilder {
        _autoScrollY = enabled;
        autoScrollRateY = rate;
        return this;
    }

    public function autoFlipX(enabled:Bool, rate=1.):BackgroundBuilder {
        _autoFlipX = enabled;
        autoFlipRateX = rate;
        return this;
    }

    public function autoFlipY(enabled:Bool, rate=1.):BackgroundBuilder {
        _autoFlipY = enabled;
        autoFlipRateY = rate;
        return this;
    }

    public function randScrollX(enabled:Bool, rate=1.):BackgroundBuilder {
        _randScrollX = enabled;
        randScrollRateX = rate;
        return this;
    }

    public function randScrollY(enabled:Bool, rate=1.):BackgroundBuilder {
        _randScrollY = enabled;
        randScrollRateY = rate;
        return this;
    }



    public function setAlpha(alpha:Float):BackgroundBuilder {
        this.alpha = alpha;
        return this;
    }

    public function build() {
        if (parent == null) throw new haxe.Exception("parent must be set");
        tile.setSize(width + tileWidth*2, height + tileHeight*2);
        var bg = new h2d.Bitmap(tile);
        var scene = Std.downcast(parent, h2d.Scene);
        if (scene != null) {
            scene.addChildAt(bg, layer == null ? 0 : layer);
        }
        else {
            parent.addChild(bg);
        }
        bg.setPosition(-tileWidth, -tileHeight);
        bg.tileWrap = true;
        bg.alpha = alpha;
        var bgId = coms.getIntId();
        coms.objects[bgId] = bg;
        coms.bitmaps[bgId] = bg;

        if (_autoScrollX) {
            var tween = new com.Tweener(autoScrollRateX);
            tween.start = 0;
            tween.diff = tileWidth;
            tween.easing = motion.easing.Linear.easeNone;
            tween.mode = REPEATING;
            var tweenId = coms.getIntId();
            coms.tweeners[tweenId] = tween;
            var coupling:com.BitmapTweenCoupling = {
                bitmapId: bgId,
                tweenId: tweenId,
                kind: TILE_DX
            }
            coms.bitmapTweenCouplings[coms.getIntId()] = coupling;
        }

        if (_autoScrollY) {
            var tween = new com.Tweener(autoScrollRateY);
            tween.start = 0;
            tween.diff = tileHeight;
            tween.easing = motion.easing.Linear.easeNone;
            tween.mode = REPEATING;
            var tweenId = coms.getIntId();
            coms.tweeners[tweenId] = tween;
            var coupling:com.BitmapTweenCoupling = {
                bitmapId: bgId,
                tweenId: tweenId,
                kind: TILE_DY
            }
            coms.bitmapTweenCouplings[coms.getIntId()] = coupling;
        }

        if (_randScrollX) {
            var timer = new com.Timer(randScrollRateX);
            timer.mode = REPEATING;
            timer.onDone = () -> {
                bg.tile.dx = Random.float(0, tileWidth);
            }
            coms.timers[coms.getIntId()] = timer;
        }

        if (_randScrollY) {
            var timer = new com.Timer(randScrollRateY);
            timer.mode = REPEATING;
            timer.onDone = () -> {
                bg.tile.dy = Random.float(0, tileHeight);
            }
            coms.timers[coms.getIntId()] = timer;
        }

        if (_autoFlipX) {
            var timer = new com.Timer(autoFlipRateX);
            timer.mode = REPEATING;
            timer.onDone = () -> {
                bg.tile.flipX();
                bg.tile.dx = 0;
            }
            coms.timers[coms.getIntId()] = timer;
        }

        if (_autoFlipY) {
            var timer = new com.Timer(autoFlipRateY);
            timer.mode = REPEATING;
            timer.onDone = () -> {
                bg.tile.flipY();
                bg.tile.dy = 0;
            }
            coms.timers[coms.getIntId()] = timer;
        }

    }
}