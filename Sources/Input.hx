package ;

class Input {
	public var mouseButtonDown:Bool = false;
	public var mousePos = new kha.math.Vector2();
	public var worldMousePos = new kha.math.Vector2();
	public var mouseScroll = 0;
	public var keys = new Map<Int,Bool >();
	var panning = false;
	var project:Project;
	public function new(project:Project){
		kha.input.Mouse.get().notify(mouseDown,mouseUp,mouseMove,mouseWheel);
		kha.input.Keyboard.get().notify(keyDown,keyUp);
		this.project = project;
	}
	function keyDown (key:Int){
		
		keys.set(key,true);

		
		if (key == kha.input.KeyCode.R){
			var valid = "semaFfb".split("");
			for (grid in project.nationGrids){
				var m = 
					"
				sssssssssssssss
				eeeeeeeeeeeeeee
				eeeeeeeeeeeeeee
				eeeeeeeeeeeeeee
				eeeeeeeeeeeeeee
				eeeeeeeeeeeeeee";
				if (!grid.humanControlled){
					var ma = m.split("\n");
					ma.reverse();
					m = ma.join("");
				}
				grid.tiles = [];
				for (tile in m.split("")){
				
					if (valid.indexOf(tile) == -1) continue;
					grid.tiles.push(switch(tile){
						case "s":NationGrid.Tile.Soldier;
						case "f":NationGrid.Tile.Farmer;
						case "a":NationGrid.Tile.Archer;
						case "b":NationGrid.Tile.Blacksmith;
						case "m":NationGrid.Tile.Market;
						case "e":NationGrid.Tile.Empty;
						case "F":NationGrid.Tile.Fletcher;
						case _:NationGrid.Tile.Empty;
					});
				}
			}
		}
		
	}
	function keyUp (key:Int){
		if (key == kha.input.KeyCode.Space){
			if (!project.inBattle)
				project.startBattle();
		}
		
		keys.set(key,false);

	}
	function mouseDown(a,b,c){
		if (a == 0)
			mouseButtonDown = true;
		if (a == 2)
			panning = true;
	}
	function mouseUp(a,b,c){
		if (a == 0)
			mouseButtonDown = false;

		if (a == 2)
			panning = false;
	}
	function mouseMove(a,b,c,d){
		if (panning){
			project.camera.pos.x += mousePos.x-a;
			project.camera.pos.y += mousePos.y-b;
		}

		mousePos.x = a;
		mousePos.y = b;

		
		worldMousePos = project.camera.screenToWorld(mousePos);
	}
	function mouseWheel(scroll){
		mouseScroll += scroll;
	}
}