package;

import kha.System;

class Main {
	public static var tune:kha.audio1.AudioChannel;
	public static function main() {
		System.init({title: "LD39", width: 1024, height: 768}, function () {
			kha.Assets.loadEverything(function (){
				Main.tune = kha.audio1.Audio.play(kha.Assets.sounds.Tune,true);
				Main.tune.stop();
				new Project();
			});
		});
	}
}
