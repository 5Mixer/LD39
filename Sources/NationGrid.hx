package ;

enum Tile {
	Empty;
	Soldier;
	Blacksmith;
	Farmer;
	Archer;
	Market;
	Fletcher;
}
typedef GridSize = {
	var width:Int;
	var height:Int;
}
typedef TileMap = {
	var tiles:String;
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
	public var arrows:Int;

	public var startOfBattlePopulation:Int = 0;

	public var reports:Array<String> = [];

	var maps:Array<TileMap> = [];

	public function new (humanControlled=false,level=4){
		// for (y in 0...size.height){
		// 	for (x in 0...size.width){
		// 		tiles.push(Math.random() > .9999999999 ? Tile.Empty : Tile.Soldier);
		// 	}
		// }
		this.humanControlled = humanControlled;
		gold = 10000;
		respect = 20;
		food = 400;
		weapons = 10;
		arrows = 100;

		maps.push({
			tiles:"
			ssss
			faea
			feeb
			femb",
			width:4,
			height:4
		});

		maps.push({
			tiles:"
			sssss
			eaeae
			eeeee
			fmmbb
			ffeeF",
			width:5,
			height:5
		});

		maps.push({
			tiles:"
			sasssas
			smsssss
			sfsfsfs
			ffffbbb",
			width:7,
			height:4
		});

		maps.push({
			tiles:"
			aaaaaaaaaa
			ssessesses
			ffeeeembbb
			ffeeeeeebb
			ffFFFFFFee",
			width:10,
			height:5
		});
		
		maps.push({
			tiles:"
			sasasasasasasas
			esasasasasasase
			efeeeeeeefffmfe
			eefbfbffbfeefeF
			eeefebeebbbfeFF
			eeemebebbbeeeee",
			width:15,
			height:6
		});

		// m = 
		// "
		// sssssssssssssss
		// eeeeeeeeeeeeeee
		// eeeeeeeeeeeeeee
		// eeeeeeeeeeeeeee
		// eeeeeeeeeeeeeee
		// eeeeeeeeeeeeeee";

		var map = maps[level];
		size.width = map.width;
		size.height = map.height;
		var m = map.tiles;

		if (!humanControlled){
			var ma = m.split("\n");
			ma.reverse();
			m = ma.join("");
		}
		var valid = "semaFfb".split("");
		tiles = [];
		for (tile in m.split("")){
			
			if (valid.indexOf(tile) == -1) continue;
			tiles.push(switch(tile){
				case "s":Tile.Soldier;
				case "f":Tile.Farmer;
				case "a":Tile.Archer;
				case "b":Tile.Blacksmith;
				case "m":Tile.Market;
				case "e":Tile.Empty;
				case "F":Tile.Fletcher;
				case _:Tile.Empty;
			});
		}

		worldpos = new kha.math.Vector2(0,0);
	}
	public function render(g:kha.graphics2.Graphics){
		g.pushTranslation(worldpos.x*Camera.zoom,worldpos.y*Camera.zoom);
		g.color = kha.Color.fromBytes(27,38,50);
		g.fillRect(0,0,size.width*16,size.height*16);
		g.color = kha.Color.White;
		
		for (y in 0...size.height){
			for (x in 0...size.width){
				var tile = tiles[y*size.width + x];
				if (tile == null)
					throw "Null tile";
				
				// g.color = kha.Color.Green;
				g.drawSubImage(kha.Assets.images.Spritesheet,x*16,y*16,32,16,16,16);
				g.drawSubImage(kha.Assets.images.Spritesheet,x*16,y*16,16*(tile.getIndex()),0,16,16);
			}
		}
		
		g.color = kha.Color.fromBytes(27,38,50);
		g.fillRect(8+size.width*16,0,64,32*Camera.zoom);
		g.color = kha.Color.White;
		g.font = kha.Assets.fonts.mini;
		g.fontSize = 10*Camera.zoom;
		g.transformation._00 = g.transformation._11 = 1;
		g.drawString(gold+" g",28+size.width*16 *Camera.zoom,0);
		g.drawString(respect+" respect",28+size.width*16 *Camera.zoom,12*Camera.zoom);
		g.drawString(food+" food",28+size.width*16 *Camera.zoom,12*Camera.zoom*2);
		g.drawString(weapons+" weapons",28+size.width*16 *Camera.zoom,12*Camera.zoom*3);
		g.drawString(arrows+" arrows",28+size.width*16 *Camera.zoom,12*Camera.zoom*4);

		
		// g.color = kha.Color.Black;
		// g.fillRect(10+(64*4)+(size.width*16)*4,0,1000,16*4*4);
		// g.color = kha.Color.White;
		// var y = 0;
		// for (report in reports){
		// 	g.drawString(report,270+size.width*16 *4,y);
		// 	y+=12*4;
		// }

		g.popTransformation();
		
	}
	public function setTile(x:Int,y:Int,tile:Tile){
		tiles[(y*size.width)+x] = tile;
	}
	public function getTile(x:Int,y:Int){
		return tiles[(y*size.width)+x];
	}
	public function endOfDay() {
		var population = 0;
		var totalSoldiers = 0;
		var totalArchers = 0;
		var totalMarkets = 0;
		var totalBlacksmiths = 0;
		reports = [];
		for (tile in tiles){
			if (tile != Tile.Empty)
				population++;
			if (tile == Tile.Farmer){
				food+=1;
				gold-=10;
			}
			if (tile == Tile.Blacksmith){
				weapons +=1;
				food -= 1;
				gold -= 10;
				totalBlacksmiths++;
			}
			if (tile == Tile.Fletcher){
				arrows += 3;
				food -= 1;
				gold -= 10;
			}
			if (tile == Tile.Soldier){
				totalSoldiers++;
				gold -= 15;
				food -= 2;
			}
			if (tile == Tile.Archer){
				gold -= 20;
				food -= 2;
				totalArchers++;
			}
			if (tile == Tile.Market){
				gold += 25;
				food -= 2;
				totalMarkets++;
			}
		}

		if (weapons < totalSoldiers){
			reports.push("There were not enough weapons for every soldier, -1 respect.");
			respect--;
		}else{
			reports.push("There were enough weapons for every soldier, +1 respect.");
			respect++;
		}
		if (population > food){
			reports.push("There was not enough food for every citizen, -1 respect.");
			respect--;
		}
		if (arrows < 1 && totalArchers > 1){
			reports.push("There were no arrows for the archers to fire, -1 respect.");
			respect--;
		}
		if (totalMarkets < 1){
			reports.push("There was no market to exchange goods at, -1 respect.");
			respect--;
		}
		if (totalMarkets > 4){
			reports.push("Plenty of markets has caused profitable trade, +1 respect.");
			respect++;
		}
		if (totalSoldiers == 0 || totalArchers == 0){
			reports.push("To win a war, both archers and soldiers should be used. -1 respect.");
			respect--;
		}

		if (totalSoldiers+totalArchers == 0){
			reports.push("An army with no members... outrageous! -5 respect!");
			respect -= 5;
		}else if (totalSoldiers+totalArchers < 5){
			reports.push("An army with a mere handful of soldiers is no army at all, -3 respect!");
			respect -= 3;
		}
		if (totalSoldiers+totalArchers < totalMarkets){
			reports.push("More markets that civilians fighting in the war? -3 respect!");
			respect -= 3;
		}
		if (totalBlacksmiths > totalSoldiers+5 && weapons > totalSoldiers+30){
			reports.push("The blacksmith's think too many weapons are being made. -2 respect.");
			respect -= 2;
		}
		if (gold < 2000){
			reports.push("With less than 2000g, there is little faith in your leadership. -1 respect.");
			respect--;
		}
	}
}