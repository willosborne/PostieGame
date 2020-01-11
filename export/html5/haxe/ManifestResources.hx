package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy53:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-tilemap.pngy4:sizei115811y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y66:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-character-animations.pngR2i7793R3R4R5R7R6tgoR0y35:assets%2Fimages%2Fplayer_2.asepriteR2i1538R3y6:BINARYR5R8R6tgoR0y53:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-enemies.pngR2i3631R3R4R5R10R6tgoR0y36:assets%2Fimages%2Fplayertst.asepriteR2i711R3R9R5R11R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3y4:TEXTR5R12R6tgoR0y32:assets%2Fimages%2Fplayer_run.pngR2i679R3R4R5R14R6tgoR0y49:assets%2Fimages%2Fs4m_ur4i_8x8_minimal-future.pngR2i6157R3R4R5R15R6tgoR0y52:assets%2Fimages%2Fs4m_ur4i_huge-ui-portrait-item.pngR2i18415R3R4R5R16R6tgoR0y58:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-ui-portraits.pngR2i147053R3R4R5R17R6tgoR0y56:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-characters.pngR2i5723R3R4R5R18R6tgoR0y37:assets%2Fimages%2Ftiles12x12.asepriteR2i1657R3R9R5R19R6tgoR0y51:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-intro.pngR2i4196R3R4R5R20R6tgoR0y32:assets%2Fimages%2Ftiles12x12.pngR2i1895R3R4R5R21R6tgoR0y39:assets%2Fimages%2Fplayer_sheet.asepriteR2i1116R3R9R5R22R6tgoR0y48:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-ui.pngR2i80931R3R4R5R23R6tgoR0y32:assets%2Fimages%2Ftiles.asepriteR2i1692R3R9R5R24R6tgoR0y53:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-animals.pngR2i1494R3R4R5R25R6tgoR0y33:assets%2Fimages%2Fplayer.asepriteR2i1202R3R9R5R26R6tgoR0y27:assets%2Fimages%2Ftiles.pngR2i1828R3R4R5R27R6tgoR0y34:assets%2Fimages%2Fplayer_sheet.pngR2i912R3R4R5R28R6tgoR0y37:assets%2Fimages%2Fplayer_run.asepriteR2i2205R3R9R5R29R6tgoR0y52:assets%2Fimages%2Fs4m_ur4i_huge-assetpack-drones.pngR2i968R3R4R5R30R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R13R5R31R6tgoR0y28:assets%2Fdata%2Fexplore.ogmoR2i156862R3R13R5R32R6tgoR0y27:assets%2Fdata%2Flevel1.jsonR2i15851R3R13R5R33R6tgoR0y27:assets%2Fdata%2Ftileset.tsxR2i602R3R13R5R34R6tgoR0y30:assets%2Fdata%2Ftest_level.tmxR2i11086R3R13R5R35R6tgoR0y28:assets%2Fdata%2Fsam_huge.tsxR2i260R3R13R5R36R6tgoR0y30:assets%2Fdata%2Ftest_12x12.tmxR2i11000R3R13R5R37R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R13R5R38R6tgoR0y30:assets%2Fdata%2Ftiles12x12.tsxR2i742R3R13R5R39R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R13R5R40R6tgoR2i39706R3y5:MUSICR5y28:flixel%2Fsounds%2Fflixel.mp3y9:pathGroupaR42y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i2114R3R41R5y26:flixel%2Fsounds%2Fbeep.mp3R43aR45y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i5794R3y5:SOUNDR5R46R43aR45R46hgoR2i33629R3R47R5R44R43aR42R44hgoR2i15744R3y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R48R49y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R4R5R54R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R4R5R55R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_tilemap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_character_animations_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_2_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_enemies_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_playertst_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_run_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_8x8_minimal_future_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_ui_portrait_item_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_ui_portraits_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_characters_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tiles12x12_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_intro_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tiles12x12_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_sheet_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_ui_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tiles_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_animals_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tiles_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_sheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_player_run_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_drones_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_explore_ogmo extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_level1_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_tileset_tsx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_test_level_tmx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_sam_huge_tsx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_test_12x12_tmx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_tiles12x12_tsx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-tilemap.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_tilemap_png extends lime.graphics.Image {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-character-animations.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_character_animations_png extends lime.graphics.Image {}
@:keep @:file("assets/images/player_2.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_player_2_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-enemies.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_enemies_png extends lime.graphics.Image {}
@:keep @:file("assets/images/playertst.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_playertst_aseprite extends haxe.io.Bytes {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/player_run.png") @:noCompletion #if display private #end class __ASSET__assets_images_player_run_png extends lime.graphics.Image {}
@:keep @:image("assets/images/s4m_ur4i_8x8_minimal-future.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_8x8_minimal_future_png extends lime.graphics.Image {}
@:keep @:image("assets/images/s4m_ur4i_huge-ui-portrait-item.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_ui_portrait_item_png extends lime.graphics.Image {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-ui-portraits.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_ui_portraits_png extends lime.graphics.Image {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-characters.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_characters_png extends lime.graphics.Image {}
@:keep @:file("assets/images/tiles12x12.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_tiles12x12_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-intro.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_intro_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tiles12x12.png") @:noCompletion #if display private #end class __ASSET__assets_images_tiles12x12_png extends lime.graphics.Image {}
@:keep @:file("assets/images/player_sheet.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_player_sheet_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-ui.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_ui_png extends lime.graphics.Image {}
@:keep @:file("assets/images/tiles.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_tiles_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-animals.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_animals_png extends lime.graphics.Image {}
@:keep @:file("assets/images/player.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_player_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/tiles.png") @:noCompletion #if display private #end class __ASSET__assets_images_tiles_png extends lime.graphics.Image {}
@:keep @:image("assets/images/player_sheet.png") @:noCompletion #if display private #end class __ASSET__assets_images_player_sheet_png extends lime.graphics.Image {}
@:keep @:file("assets/images/player_run.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_player_run_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/s4m_ur4i_huge-assetpack-drones.png") @:noCompletion #if display private #end class __ASSET__assets_images_s4m_ur4i_huge_assetpack_drones_png extends lime.graphics.Image {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/explore.ogmo") @:noCompletion #if display private #end class __ASSET__assets_data_explore_ogmo extends haxe.io.Bytes {}
@:keep @:file("assets/data/level1.json") @:noCompletion #if display private #end class __ASSET__assets_data_level1_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/tileset.tsx") @:noCompletion #if display private #end class __ASSET__assets_data_tileset_tsx extends haxe.io.Bytes {}
@:keep @:file("assets/data/test_level.tmx") @:noCompletion #if display private #end class __ASSET__assets_data_test_level_tmx extends haxe.io.Bytes {}
@:keep @:file("assets/data/sam_huge.tsx") @:noCompletion #if display private #end class __ASSET__assets_data_sam_huge_tsx extends haxe.io.Bytes {}
@:keep @:file("assets/data/test_12x12.tmx") @:noCompletion #if display private #end class __ASSET__assets_data_test_12x12_tmx extends haxe.io.Bytes {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/tiles12x12.tsx") @:noCompletion #if display private #end class __ASSET__assets_data_tiles12x12_tsx extends haxe.io.Bytes {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("/home/will/haxelib/flixel/4,6,3/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/home/will/haxelib/flixel/4,6,3/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/home/will/haxelib/flixel/4,6,3/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("/home/will/haxelib/flixel/4,6,3/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/home/will/haxelib/flixel/4,6,3/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/home/will/haxelib/flixel/4,6,3/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
