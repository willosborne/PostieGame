package;

import haxe.EnumTools;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxObject;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.FlxBasic;
import openfl.Assets;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import Collectable;

class PlayState extends FlxState
{
	var tilesBg:FlxTilemap;
	var tilesCollision:FlxTilemapExt;
	var tilesFg:FlxTilemap;

	var player:Player;

	var save: Save = {
		player_x: 432,
		player_y: 300,
		level: "test_12x12.tmx"
	};

	var currentLevel: String;

	var tileSize:Int;
	var mapW:Int;
	var mapH:Int;

	var entities: FlxGroup;
	var interactables: FlxGroup;
	var touchables: FlxGroup;

	var portals: Map<String, PortalEdge> = new Map();

	override public function create():Void
	{
		player = new Player(save.player_x, save.player_y, this);
		entities = new FlxGroup();
		interactables = new FlxGroup();
		touchables = new FlxGroup();

		currentLevel = "assets/data/" + save.level;

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

		super.create();
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
					var portal:PortalEdge = new PortalEdge(object.x, object.y, 
						object.width, object.height,
						object.name,
						object.properties.get('targetLevel'), 
						object.properties.get('targetPortal'));

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

	function handleInteract(player: Player, other: FlxSprite) {
		if (Std.is(other, SavePoint)) {
			this.save = {
				player_x: other.x,
				player_y: other.y,
				level: currentLevel
			};
			trace('Saving: ${this.save}');
		}
	}

	public function respawn() {
		if (this.save != null) {
			player.setPosition(save.player_x, save.player_y);
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

		super.update(elapsed);
	}
}
