package tiled;

typedef MapRawData = {
    layers:Array<{
        data:Array<Int>,
        name:String
    }>,
    tilewidth:Int,
    tileheight:Int,
    width:Int,
    height:Int
}