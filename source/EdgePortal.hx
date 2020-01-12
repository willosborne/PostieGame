import flixel.FlxObject;

class EdgePortal extends FlxObject {
    public var targetLevel: String;
    public var targetPortal: String;

    public var name: String;

    public var entryDirection: String;
    public var exitDirection: String;


    public function new(X:Float, Y:Float, W:Float, H:Float, 
        name: String, level:String, portal:String,
        entry: String, exit: String) {
        super(X, Y, W, H);

        this.name = name;
        this.targetLevel = level;
        this.targetPortal = portal;
        this.entryDirection = entry;
        this.exitDirection = exit;
    }
}