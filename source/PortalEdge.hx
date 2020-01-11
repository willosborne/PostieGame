import flixel.FlxObject;

class PortalEdge extends FlxObject {
    public var targetLevel: String;
    public var targetPortal: String;
    public var name: String;


    public function new(X:Float, Y:Float, W:Float, H:Float, name: String, level:String, portal:String) {
        super(X, Y, W, H);

        this.name = name;
        this.targetLevel = level;
        this.targetPortal = portal;
    }
}