import Collectable.CollectableType;
import flixel.math.FlxPoint;

typedef PlayerSave = {
    collectables: Array<CollectableType>
}

typedef Save = {
    level: String,
    playerX: Float,
    playerY: Float,
    playerSave: PlayerSave
}