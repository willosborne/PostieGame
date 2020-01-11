import flixel.math.FlxPoint;
import flixel.effects.particles.FlxParticle;

class DustPuff extends FlxParticle {
    var poof:Bool;
    public function new(poof:Bool = false) {
        super();

        loadGraphic("assets/images/smoke-puff.png", true, 12, 12);
        animation.add("puff", [0, 1, 2, 3], 5, false);
        animation.add("poof", [1, 2, 3], 5, false);
        exists = false;
        this.poof = poof;
        // lifespan = 0;
    }

    override function onEmit() {
        drag = new FlxPoint(4, 4);
        // exists = true;
        if (poof)
            animation.play("poof");
        else
			animation.play("puff");
        
    }
}