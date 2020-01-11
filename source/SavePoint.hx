import flixel.util.FlxColor;
import flixel.FlxSprite;

class SavePoint extends FlxSprite {
    public function new(X: Float, Y:Float, boxW:Int, boxH:Int) {
        super(X, Y); 

        makeGraphic(boxW, boxH, FlxColor.CYAN);
    }
}