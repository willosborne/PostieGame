import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import DustPuff;
import Collectable;
import Save;

class Player extends FlxSprite {
    var jumping: Bool;
    var hasControl: Bool = true;
    var autoWalk: Int = FlxObject.NONE;

    inline static var grav = 800;
    inline static var jumpGrav = 350;

    inline static var maxXVel = 100;
    inline static var maxYVel = 500;
    inline static var wallMaxYVel = 80;

    inline static var groundDrag = maxXVel * 8;
    inline static var airDrag = maxXVel * 4;

    inline static var groundAccel = maxXVel * 20;
    inline static var airAccel = maxXVel * 8;

    var flip:Bool = false;

    var remainingAirJumps:Int = 0;

    var onGroundTimer:Int = 0;
    var onGroundTimerMax:Int = 10;
    
    var onWallTimer:Int = 0;
    var onWallTimerMax:Int = 10;

    public var dustEmitter:FlxEmitter;
    public var poofEmitter:FlxEmitter;
    var puffMin:Int = 10;
    var puffMax:Int = 40;

    var timer:Float = 0;

    var runPoof:Bool = false;

    var hup1:FlxSound;
    var hup2:FlxSound;
    var hoo:FlxSound;
    var huup:FlxSound;

    var state:PlayState;
    var collectables:Map<CollectableType, Bool> = new Map();

    public function new(X:Float = 0, Y:Float = 0, state:PlayState) {
        super(X, Y);
        this.state = state;

        loadGraphic("assets/images/player_sheet.png", true, 24, 24);
        animation.add("idle_right", [0], 10, true, false);
        animation.add("idle_left", [0], 10, true, true);
        animation.add("run_right", [1, 2, 3, 4, 5, 6, 7, 8], 15, true, false);
        animation.add("run_left", [1, 2, 3, 4, 5, 6, 7, 8], 15, true, true);
        animation.add("jump", [9, 10], 10, false);
        animation.add("fall", [11]);
        animation.add("climb", [12]);

        hup1 = FlxG.sound.load(AssetPaths.hup1__wav);
        hup2 = FlxG.sound.load(AssetPaths.hup2__wav);
        hoo = FlxG.sound.load(AssetPaths.hoo__wav);
        huup = FlxG.sound.load(AssetPaths.huup__wav);

        jumping = false;
        maxVelocity.set(maxXVel, maxYVel);
        acceleration.y = grav;
        drag.x = groundDrag;

        setSize(12, 20);
        offset.set(6, 4);

        dustEmitter = new FlxEmitter(X, Y, 20);
        for (i in 0...20) {
            dustEmitter.add(new DustPuff());
        }
        dustEmitter.launchMode = FlxEmitterMode.SQUARE;
        dustEmitter.velocity.set(-10, -10, 10, 10);
        dustEmitter.visible = true;
        dustEmitter.exists = true;
        
        poofEmitter = new FlxEmitter(X, Y, 20);
        for (i in 0...20) {
            poofEmitter.add(new DustPuff(true));
        }
        poofEmitter.launchMode = FlxEmitterMode.SQUARE;
        poofEmitter.velocity.set(-10, -10, 10, 10);
        poofEmitter.visible = true;
        poofEmitter.exists = true;
    }

    function handleTimers() {
        if (isTouching(FlxObject.FLOOR)) {
            onGroundTimer = onGroundTimerMax;
        } 
        else {
            onGroundTimer -= 1;
        }
        var onWall = (isTouching(FlxObject.RIGHT) && FlxG.keys.anyPressed([RIGHT])) || 
            (isTouching(FlxObject.LEFT) && FlxG.keys.anyPressed([LEFT]));
        if (onWall) {
            onWallTimer = onWallTimerMax;
        } 
        else {
            onWallTimer -= 1;
        }
    }

    override function update(elapsed:Float) {
        if (!inWorldBounds()) {
            if (autoWalk != FlxObject.NONE) {
                // just walked off level transition
                state.triggerLevelChange();
            }
            else {
                // we just died
				state.respawn();
            }
        }
        var onGround = isTouching(FlxObject.FLOOR);
        var onWall = (isTouching(FlxObject.RIGHT) && FlxG.keys.anyPressed([RIGHT])) || 
            (isTouching(FlxObject.LEFT) && FlxG.keys.anyPressed([LEFT]));

        handleTimers();

        if (onGround) {
            remainingAirJumps = maxAirJumps();
        }
        if ((animation.frameIndex == 4 || animation.frameIndex == 8)) {
            if (!runPoof) {
                if (flipX)
                    makePoof(10, 18, FlxObject.RIGHT, 1);
                else 
                    makePoof(6, 18, FlxObject.LEFT, 1);

                runPoof = true;
            }
        }
        else {
            runPoof = false;
        }

        drag.x = onGround ? groundDrag : airDrag;
        acceleration.x = 0;

        var moveLeft = (hasControl && FlxG.keys.anyPressed([LEFT])) || autoWalk == FlxObject.LEFT;
        var moveRight = (hasControl && FlxG.keys.anyPressed([RIGHT])) || autoWalk == FlxObject.RIGHT;

        if (moveLeft) {
            move(FlxObject.LEFT, onGround);
        } else if (moveRight) {
            move(FlxObject.RIGHT, onGround);
        } else {
            if (onGround)
                animation.play("idle_right");
        }

        if (hasControl) {
            if (FlxG.keys.anyJustPressed([UP, Z, SPACE])) {
                if (onGroundTimer > 0) {
                    // ground jump
                    onGroundTimer = 0;
                    velocity.y = -maxVelocity.y / 2.5;
                    jumping = true;
                    acceleration.y = jumpGrav;
                    animation.play("jump");

                    if (flipX)
                        makeSmokePuff(10, 18, FlxObject.RIGHT);
                    else
                        makeSmokePuff(6, 18, FlxObject.LEFT);

                    var snd = FlxG.random.getObject([hup1, hup2]);
                    snd.play(true);
                } else if (onWallTimer > 0 && hasWallJump()) {
                    // wall jump
                    onWallTimer = 0;
                    velocity.y = -maxVelocity.y / 2.5;
                    jumping = true;
                    acceleration.y = jumpGrav;
                    animation.play("jump");
                    if (flipX)
                        makeSmokePuff(2, 14, FlxObject.DOWN);
                    else
                        makeSmokePuff(10, 14, FlxObject.DOWN);

                    if (onWall) {
                        flipX = !flipX;
                        velocity.x = maxXVel * 4 * (flipX ? -1 : 1);
                        acceleration.x = 0;
                    }
                    onWall = false;

                    var snd = FlxG.random.getObject([hup1, hup2]);
                    snd.play(true);
                } else if (remainingAirJumps > 0) {
                    // air jump
                    velocity.y = -maxVelocity.y / 2.5;
                    jumping = true;
                    acceleration.y = jumpGrav;
                    animation.play("jump");

                    remainingAirJumps -= 1;
                    if (flipX)
                        makePoof(10, 18, FlxObject.RIGHT);
                    else
                        makePoof(6, 18, FlxObject.LEFT);

                    var snd = FlxG.random.getObject([hup1, hup2]);
                    snd.play(true);
                }
            }
            

            if (FlxG.keys.anyJustPressed([X])) {
                state.interact();
            }
        }

        if (velocity.y > 0 && !onGround) {
            jumping = false;
            acceleration.y = grav;
            animation.play("fall");
        }
        if (jumping && !onGround) {
            if (FlxG.keys.anyPressed([UP, Z, SPACE]) && hasControl) {
				acceleration.y = jumpGrav;
            }
            else {
                acceleration.y = grav;
                jumping = false;
            }
        }
        else {
            acceleration.y = grav;
        }

        if (onWall && hasWallClimb()) {
            if (!onGround) {
                animation.play("climb");
            }
            if (velocity.y > wallMaxYVel) {
                velocity.y = wallMaxYVel;
            }
        }

        super.update(elapsed);
    }

    function move(direction: Int, onGround: Bool) {
        if (direction == FlxObject.RIGHT) {
			var accel = onGround ? groundAccel : airAccel;
			acceleration.x = accel;
			if (onGround)
				animation.play("run_right");
			flip = false;
			flipX = false;
        }
        else if (direction == FlxObject.LEFT) {
			var accel = onGround ? groundAccel : airAccel;
			acceleration.x = -accel;
			if (onGround)
				animation.play("run_right");
			flip = true;
			flipX = true;
        }
        else 
            throw("Invalid run direction");
    }

    function makeSmokePuff(dx:Int, dy:Int, direction:Int=FlxObject.NONE, n:Int=4) {
		dustEmitter.setPosition(x+dx, y+dy);
        switch(direction) {
            case FlxObject.LEFT:
				dustEmitter.velocity.set(-puffMax, -puffMin, puffMin, puffMin);
            case FlxObject.RIGHT:
				dustEmitter.velocity.set(-puffMin, -puffMin, puffMax, puffMin);
            case FlxObject.UP:
				dustEmitter.velocity.set(-puffMin, -puffMax, puffMin, puffMin);
            case FlxObject.DOWN:
				dustEmitter.velocity.set(-puffMin, -puffMin, puffMin, puffMax);
            default:
				dustEmitter.velocity.set(-puffMin, -puffMin, puffMin, puffMin);
        }
        for (i in 0...n) {
			dustEmitter.emitParticle();
        }
    }

    function makePoof(dx:Int, dy:Int, direction:Int=FlxObject.NONE, n:Int=4) {
		poofEmitter.setPosition(x+dx, y+dy);
        switch(direction) {
            case FlxObject.LEFT:
				poofEmitter.velocity.set(-puffMax, -puffMin, puffMin, puffMin);
            case FlxObject.RIGHT:
				poofEmitter.velocity.set(-puffMin, -puffMin, puffMax, puffMin);
            case FlxObject.UP:
				poofEmitter.velocity.set(-puffMin, -puffMax, puffMin, puffMin);
            case FlxObject.DOWN:
				poofEmitter.velocity.set(-puffMin, -puffMin, puffMin, puffMax);
            default:
				poofEmitter.velocity.set(-puffMin, -puffMin, puffMin, puffMin);
        }
        for (i in 0...n) {
			poofEmitter.emitParticle();
        }
    }

    public function addCollectable(collect: CollectableType) {
        collectables.set(collect, true);
    }

    public function removeCollectable(collect: CollectableType) {
        collectables.set(collect, false);
    }
    
    public function setControl(hasControl: Bool) {
        this.hasControl = hasControl;
        if (hasControl) {
            autoWalk = FlxObject.NONE;
        }
    }

    public function beginAutoWalk(direction: String) {
        if (autoWalk != FlxObject.NONE) 
            return;
        switch(direction) {
            case "left":
                autoWalk = FlxObject.LEFT;
            case "right":
                autoWalk = FlxObject.RIGHT;
            default: 
                throw("Invalid walk direction; expected left or right");
        }
        trace('Walking $direction');
    }

    public function stopAutoWalk() {
        autoWalk = FlxObject.NONE;
    }

    public function save(): PlayerSave {
        var collected:Array<CollectableType> = new Array();
        for (key => value in collectables) {
            if (value) {
                collected.push(key);
            }
        }
        return {
            collectables: collected
        };
    }

    public function restore(playerSave: PlayerSave) {
        collectables.clear();
        for (collectable in playerSave.collectables) {
            collectables.set(collectable, true);
        }
    }

    function hasWallClimb() : Bool {
        return collectables.get(WallClimb) == true;
    }
    
    function hasWallJump() : Bool {
        return collectables.get(WallJump) == true;
    }

    function hasDoubleJump() : Bool {
        return collectables.get(DoubleJump) == true;
    }

    function maxAirJumps() : Int {
        return hasDoubleJump() ? 1 : 0;
    }

}