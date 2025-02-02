package;

import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCatagory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Catagory";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}

class AndroidControls extends Option
{
	public function new()
	{
		super();
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new android.AndroidControlsMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Android Controls";
	}
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
		
		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.dfjk ? "DFJK" : "WASD";
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
	}
}

class Judgement extends Option
{
	

	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	public override function press():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		return "Safe Frames";
	}

	override function left():Bool {

		if (Conductor.safeFrames == 1)
			return false;

		Conductor.safeFrames -= 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();

		OptionsMenu.versionShit.text = "Current Safe Frames: " + Conductor.safeFrames + " - Description - " + description + 
		" - SIK: " + OptionsMenu.truncateFloat(45 * Conductor.timeScale, 0) +
		"ms GD: " + OptionsMenu.truncateFloat(90 * Conductor.timeScale, 0) +
		"ms BD: " + OptionsMenu.truncateFloat(135 * Conductor.timeScale, 0) + 
		"ms SHT: " + OptionsMenu.truncateFloat(155 * Conductor.timeScale, 0) +
		"ms TOTAL: " + OptionsMenu.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
		return true;
	}

	override function right():Bool {

		if (Conductor.safeFrames == 20)
			return false;

		Conductor.safeFrames += 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();

		OptionsMenu.versionShit.text = "Current Safe Frames: " + Conductor.safeFrames + " - Description - " + description + 
		" - SIK: " + OptionsMenu.truncateFloat(45 * Conductor.timeScale, 0) +
		"ms GD: " + OptionsMenu.truncateFloat(90 * Conductor.timeScale, 0) +
		"ms BD: " + OptionsMenu.truncateFloat(135 * Conductor.timeScale, 0) + 
		"ms SHT: " + OptionsMenu.truncateFloat(155 * Conductor.timeScale, 0) +
		"ms TOTAL: " + OptionsMenu.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
		return true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap";
	}
	
	override function right():Bool {
		if (FlxG.save.data.fpsCap > 290)
			return false;
		FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		OptionsMenu.versionShit.text = "Current FPS Cap: " + FlxG.save.data.fpsCap + " - Description - " + description;

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.fpsCap < 60)
			return false;
		FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		OptionsMenu.versionShit.text = "Current FPS Cap: " + FlxG.save.data.fpsCap + " - Description - " + description;

		return true;
	}
}


class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "Scroll Speed";
	}

	override function right():Bool {
		FlxG.save.data.scrollSpeed += 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 10)
			FlxG.save.data.scrollSpeed = 10;

		OptionsMenu.versionShit.text = "Current Scroll Speed: " + OptionsMenu.truncateFloat(FlxG.save.data.scrollSpeed,1) + " - Description - " + description;
		return true;
	}

	override function left():Bool {
		FlxG.save.data.scrollSpeed -= 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 10)
			FlxG.save.data.scrollSpeed = 10;


		OptionsMenu.versionShit.text = "Current Scroll Speed: " + OptionsMenu.truncateFloat(FlxG.save.data.scrollSpeed,1) + " - Description - " + description;
		return true;
	}
}


class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Rainbow " + (!FlxG.save.data.fpsRain ? "off" : "on");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NPS Display " + (!FlxG.save.data.npsDisplay ? "off" : "on");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Load replays";
	}
}

class AccuracyDOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod == 1 ? 0 : 1;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy Mode: " + (FlxG.save.data.accuracyMod == 0 ? "Accurate" : "Complex");
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Customize Gameplay";
	}
}

class WatermarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		Main.watermarks = !Main.watermarks;
		FlxG.save.data.watermark = Main.watermarks;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Watermarks " + (Main.watermarks ? "on" : "off");
	}
}

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		var poop:String = Highscore.formatSong("Tutorial", 1);

		PlayState.SONG = Song.loadFromJson(poop, "Tutorial");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}

class ArrowColors extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.arrowColorCustom = !FlxG.save.data.arrowColorCustom;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Arrow Colors " + (!FlxG.save.data.arrowColorCustom ? "Vanilla" : "Custom");
	}
}

class ResetButton extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "R To Reset " + (!FlxG.save.data.resetButton ? "Off" : "On");
	}
}

class LangoEnglish extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.langoEnglish = true;
		FlxG.save.data.langoSpanish = false;
		FlxG.save.data.langoRussian = false;
		display = updateDisplay();
		return true;
		FlxG.switchState(new MainMenuState());
	}

	private override function updateDisplay():String
	{
		return "English " + (!FlxG.save.data.langoEnglish ? " " : "Current");
	}
}

class LangoSpanish extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.langoEnglish = false;
		FlxG.save.data.langoSpanish = true;
		FlxG.save.data.langoRussian = false;
		display = updateDisplay();
		return true;
		FlxG.switchState(new MainMenuState());
	}

	private override function updateDisplay():String
	{
		return "Spanish " + (!FlxG.save.data.langoSpanish ? " " : "Current");
	}
}

class LangoRussian extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.langoEnglish = false;
		FlxG.save.data.langoSpanish = false;
		FlxG.save.data.langoRussian = true;
		display = updateDisplay();
		return true;
		FlxG.switchState(new MainMenuState());
	}

	private override function updateDisplay():String
	{
		return "Russian " + (!FlxG.save.data.langoRussian ? " " : "Current");
	}
}

class FlashingLights extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.flashingLights = !FlxG.save.data.flashingLights;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Flashing Lights " + (!FlxG.save.data.flashingLights ? "Off" : "On");
	}
}

class UseShaders extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.useShaders = !FlxG.save.data.useShaders;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Shaders " + (!FlxG.save.data.useShaders ? "Off" : "On");
	}
}

class GhostTapping extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.ghostTapping = !FlxG.save.data.ghostTapping;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping " + (!FlxG.save.data.ghostTapping ? "Off" : "On");
	}
}

class CopyrightMusic extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.copyrightedMusic = !FlxG.save.data.copyrightedMusic;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Use Copyrighted Music " + (!FlxG.save.data.copyrightedMusic ? "Off" : "On");
	}
}

class HitSound extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.hitSound = !FlxG.save.data.hitSound;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Hit Sound " + (!FlxG.save.data.hitSound ? "Off" : "On");
	}
}

class NoteSplash extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.noteSplash = !FlxG.save.data.noteSplash;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Splash " + (!FlxG.save.data.noteSplash ? "Off" : "On");
	}
}

class CpuStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.cpuStrums = !FlxG.save.data.cpuStrums;

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.cpuStrums ? "Light CPU Strums" : "CPU Strums stay static";
	}

}

class ReducedMotion extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.reducedMotion = !FlxG.save.data.reducedMotion;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reduced Motion " + (!FlxG.save.data.reducedMotion ? "Off" : "On");
	}
}

class DisclaimerScreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.spoilerStartScreen = !FlxG.save.data.spoilerStartScreen;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Disclaimer Screen " + (!FlxG.save.data.spoilerStartScreen ? "Off" : "On");
	}
}