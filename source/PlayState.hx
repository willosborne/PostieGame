package;

import Save.PlayerSave;
import flixel.util.FlxTimer;
import haxe.EnumTools;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxObject;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledTileLayer;
import openfl.Assets;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;
import Collectable;

class PlayState extends FlxState
{
	var tilesBg:FlxTilemap;
	var tilesCollision:FlxTilemapExt;
	var tilesFg:FlxTilemap;

	var player:Player;

	var save: Save = {
		playerX: 432,
		playerY: 300,
		level: "test_12x12.tmx",
		playerSave: {
			collectables: []
		}
	};

	var currentLevel: String;

	var tileSize:Int;
	var mapW:Int;
	var mapH:Int;

	var entities: FlxGroup;
	var interactables: FlxGroup;
	var touchables: FlxGroup;
	var edgePortals: FlxTypedGroup<EdgePortal>;

	var touchedPortal: EdgePortal;
	var transitioningLevel: Bool = false;

	// var portals: Map<String, PortalEdge> = new Map();

	override public function create():Void
	{
		player = new Player(save.playerX, save.playerY, this);
		loadLevel(save.level);

		super.create();
	}

	function loadLevel(path: String) {
		trace('Loading level $path');
		// empty group
		clear();

		// init groups
		entities = new FlxGroup();
		interactables = new FlxGroup();
		touchables = new FlxGroup();
		edgePortals = new FlxTypedGroup<EdgePortal>();

		currentLevel = "assets/data/" + path;

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.followLerp = 0.1;

		var level:TiledMap = new TiledMap(currentLevel);
		tileSize = level.tileWidth;
		mapW = level.width;
		mapH = level.height;
		FlxG.camera.setScrollBoundsRect(0, 0, level.fullWidth, level.fullHeight, true);

		bgColor = level.backgroundColor;

		for (layer in level.layers) {
			switch(layer.type) {
				case TILE: 
					handleTileLayer(cast(layer, TiledTileLayer));
				case OBJECT:
					handleObjectLayer(cast(layer, TiledObjectLayer));
				default:
					throw("Unhandled layer type.");
			}
		}

		var oneWayTiles = [10, 11, 12, 13, 14, 40];
		var nonSolidTiles = [212, 214, 242, 244];

		for (tile in oneWayTiles) {
			tilesCollision.setTileProperties(tile, FlxObject.NONE, oneWayTile);
		}
		for (tile in nonSolidTiles) {
			tilesCollision.setTileProperties(tile, FlxObject.NONE);
		}


		add(player.dustEmitter);
		add(player.poofEmitter);
		add(tilesCollision);
		add(entities);
		add(player);
		add(tilesFg);
	}

	function handleTileLayer(layer:TiledTileLayer) {
		var data:String = layer.csvData;

		var tileset:String = layer.properties.get("tileset");
		var tilesetPath:String = "assets/images/" + tileset;

		if (layer.name == "tiles_collision") {
			var tilemap:FlxTilemapExt = new FlxTilemapExt();
			// var tileGID =
			tilemap.loadMapFromCSV(data, Assets.getBitmapData(tilesetPath), tileSize, tileSize, OFF, 1);

			tilesCollision = tilemap;
		} else {
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromCSV(data, Assets.getBitmapData(tilesetPath), tileSize, tileSize, OFF, 1);
			switch (layer.name) {
				case "tiles_bg":
					tilesBg = tilemap;
				case "tiles_fg":
					tilesFg = tilemap;
				default:
			}
		}
	}

	function handleObjectLayer(layer: TiledObjectLayer) {
		for (object in layer.objects) {
			switch(object.type) {
				case "player":
					player.setPosition(object.x, object.y);

				case "save":
					var savePoint:SavePoint = new SavePoint(object.x, object.y, object.width, object.height);
					entities.add(savePoint);
					interactables.add(savePoint);

				case "collectable":
					var collect:Collectable = new Collectable(
						object.x, 
						object.y,
						EnumTools.createByName(CollectableType, object.properties.get("collectableType"))
					);
					entities.add(collect);
					touchables.add(collect);
				
				case "portalEdge":
					var portal: EdgePortal = new EdgePortal(object.x, object.y, 
						object.width, object.height,
						object.name,
						object.properties.get('targetLevel'), 
						object.properties.get('targetPortal'),
						object.properties.get('entryDirection'),
						object.properties.get('exitDirection'));
					edgePortals.add(portal);

				default:
					throw('Unknown object type ${object.type}');
			}	
		}
	}

	function oneWayTile(Tile:FlxObject, Object:FlxObject):Void
	{
		if (FlxG.keys.anyPressed([DOWN]))
		{
			Tile.allowCollisions = FlxObject.NONE;
		}
		else if (Object.y >= Tile.y)
		{
			Tile.allowCollisions = FlxObject.CEILING;
		}
	}

	public function interact() {
		FlxG.overlap(player, interactables, handleInteract);
	}

	function handleTouch(player: Player, other: FlxSprite) {
		if (Std.is(other, Collectable)) {
			entities.remove(other);
			touchables.remove(other);
			player.addCollectable(cast(other, Collectable).collectableType);
		}
	}

	function handlePortalTouch(player: Player, other: EdgePortal) {
		if (!transitioningLevel) {
			transitioningLevel = true;

			player.setControl(false);
			player.beginAutoWalk(other.exitDirection);

			touchedPortal = other;
		}
	}

	function handleInteract(player: Player, other: FlxSprite) {
		if (Std.is(other, SavePoint)) {
			saveGame(other);
		}
	}


	function saveGame(savePoint: FlxSprite) {
		var playerSave:PlayerSave = player.save();

		this.save = {
			playerX: savePoint.x,
			playerY: savePoint.y,
			level: currentLevel,
			playerSave: playerSave
		};
		trace('Saving: ${this.save}');
	}

	public function respawn() {
		if (this.save != null) {
			player.setPosition(save.playerX, save.playerY);
		}
	}

	public function triggerLevelChange() {
		if (transitioningLevel) {
			loadLevel(touchedPortal.targetLevel);

			for (portal in edgePortals) {
				if (portal.name == touchedPortal.targetPortal) {
					player.x = portal.x + portal.width / 2;
					player.y = portal.y  + portal.height - player.height;
					player.last.set(portal.x, portal.y + portal.height - player.height);
					FlxG.camera.snapToTarget();
				}
			}

			new FlxTimer().start(0.25, function(Timer:FlxTimer) {
				player.stopAutoWalk();
				player.setControl(true);
				transitioningLevel = false;
			}, 1);
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER) {
			FlxG.resetGame();
		}

		FlxG.collide(tilesCollision, player);
		FlxG.mouse.visible = false;

		FlxG.overlap(player, touchables, handleTouch);
		FlxG.overlap(player, edgePortals, handlePortalTouch);

		// if (touchedPortal == null) {
		// }

		super.update(elapsed);
	}
}
