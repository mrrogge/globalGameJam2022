package tiled;

typedef MapRawData = {
    layers:Array<LayerData>,
    tilewidth:Int,
    tileheight:Int,
    width:Int,
    height:Int
}

typedef ObjectData = {
    width:Float,
    height:Float,
    type:String,
    x:Float,
    y:Float
}

typedef LayerData = {
    ?data:Array<Int>,
    name:String,
    type:String,
    ?objects:Array<ObjectData>
}