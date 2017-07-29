package ;

enum Tile {
	Empty;
	Soldier;
	Blacksmith;
	Farmer;
	Archer;
}
typedef GridSize = {
	var width:Int;
	var height:Int;
}

class NationGrid {
	public var tiles:Array<Tile> = [];
	public var size:GridSize = {width: 15, height: 6};
	public var worldpos:kha.math.Vector2;
	public var humanControlled = false;
	public var name:String;

	public var respect:Int;
	public var gold:Int;
	public var food:Int;
	public var weapons:Int;

	public function new (humanControlled=false){
		// for (y in 0...size.height){
		// 	for (x in 0...size.width){
		// 		tiles.push(Math.random() > .9999999999 ? Tile.Empty : Tile.Soldier);
		// 	}
		// }
		this.humanControlled = humanControlled;
		gold = 50000;
		respect = 20;
		food = 500;
		weapons = 10;
		
		var m = 
		"
		sssssaaaaasssss
		ssssfffffffssss
		eeeefffffffeeee
		eeeefffffffeeee
		eeeeebbbbbeeeee
		eeeeeebbbeeeeee";
		if (!humanControlled){
			var ma = m.split("\n");
			ma.reverse();
			m = ma.join("");
		}
		var valid = "seafb".split("");
		tiles = [];
		for (tile in m.split("")){
			
			if (valid.indexOf(tile) == -1) continue;
			tiles.push(switch(tile){
				case "s":Tile.Soldier;
				case "f":Tile.Farmer;
				case "a":Tile.Archer;
				case "b":Tile.Blacksmith;
				case "e":Tile.Empty;
				case _:Tile.Empty;
			});
		}

		worldpos = new kha.math.Vector2(0,0);
	}
	public function render(g:kha.graphics2.Graphics){
		g.pushTranslation(worldpos.x*4,worldpos.y*4);
		g.color = kha.Color.Black;
		g.fillRect(0,0,size.width*16,size.height*16);
		g.color = kha.Color.fromBytes(145,190,100);
		g.drawRect(0,0,size.width*16,size.height*16);
		g.color = kha.Color.White;
		
		for (y in 0...size.height){
			for (x in 0...size.width){
				var tile = tiles[y*size.width + x];
				if (tile == null){
					throw "Null tile";
				}
				// g.color = switch tile{
				// 	case Tile.Empty: kha.Color.Black ;
				// 	case Tile.Blacksmith:kha.Color.Blue;
				// 	case Tile.Farmer: kha.Color.Yellow;
				// 	case Tile.Soldier: kha.Color.White; 
				// }
				g.drawSubImage(kha.Assets.images.Spritesheet,x*16,y*16,16*(tile.getIndex()),0,16,16);
			}
		}
		g.popTransformation();
	}
	public function setTile(x:Int,y:Int,tile:Tile){
		tiles[(y*size.width)+x] = tile;
	}
	public function endOfDay() {
		var population = 0;
		var totalSoldiers = 0;
		var reports = [];
		for (tile in tiles){
			if (tile != Tile.Empty)
				population++;
			if (tile == Tile.Farmer)
				food+=2;
			if (tile == Tile.Blacksmith)
				weapons +=1;
			if (tile == Tile.Soldier)
				totalSoldiers++;
		}

		if (weapons < totalSoldiers){
			reports.push("There were not enough weapons for every soldier, -1 respect.");
		}else{
			reports.push("There were enough weapons for every soldier, +1 respect.");
		}
		if (population > food){
			reports.push("There was not enough food for every citizen, -1 respect.");
		}else{
			reports.push("There was enough food for every citizen, +1 respect.");
		}
	}
}