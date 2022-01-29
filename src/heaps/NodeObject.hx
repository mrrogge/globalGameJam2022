package heaps;

class NodeObject extends core.Node {
    var object:h2d.Object;

    override public function new(object:h2d.Object) {
        super();
        this.object = object;
    }
}