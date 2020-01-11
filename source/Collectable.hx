import flixel.util.FlxColor;
import flixel.FlxSprite;

enum CollectableType {
    WallClimb;
    DoubleJump;
    WallJump;
}

class Collectable extends FlxSprite {
    public var collectableType: CollectableType;
    public function new(X: Float, Y:Float, type: CollectableType) {
        super(X - 7, Y -14);
        this.collectableType = type;
        
        switch(type) {
            case WallClimb:
                makeGraphic(14, 14, FlxColor.GREEN);
            case DoubleJump:
                makeGraphic(14, 14, FlxColor.YELLOW);
            case WallJump:
                makeGraphic(14, 14, FlxColor.BLUE);
            default:
                throw("Invalid collectable type.");
        }
    }
}