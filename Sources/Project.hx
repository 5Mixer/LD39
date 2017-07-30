package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import NationGrid.Tile;

class Project {
	var playerGrid:NationGrid;
	var enemyGrid:NationGrid;
	var input:Input;
	public var inBattle = false;
	public var camera:Camera;
	var tilePlaceIndex = 0;
	public var citizens = new Array<Citizen>();
	public var particles = new Array<Particle>();
	public var projectiles = new Array<Projectile>();
	public var decorations = new Array<Decoration>();
	public var nationGrids = new Array<NationGrid>();
	var frame = 0;
	var day = 0;
	var currentLevel = 0;
	var tileDescriptions = [
		Tile.Empty => "Clear a tile.",
		Tile.Soldier => "Fight with melee combat.",
		Tile.Blacksmith => "Craft weapons for soldiers.",
		Tile.Farmer => "Create food for all.",
		Tile.Archer => "Fight with ranged combat.",
		Tile.Market => "Generates gold from taxes.",
		Tile.Fletcher => "Craft arrows for archers."
	];
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);

		input = new Input(this);
		camera = new Camera();

		playerGrid = new NationGrid(true);
		playerGrid.worldpos = new kha.math.Vector2(20,160);
		playerGrid.name = "human";
		nationGrids.push(playerGrid);

		enemyGrid = new NationGrid();
		enemyGrid.worldpos = new kha.math.Vector2(20,-15);
		enemyGrid.name = "cpu";
		nationGrids.push(enemyGrid);


		var decorationsn = 5+Math.floor(Math.random()*10);
		for (i in 0...decorationsn){
			// decorations.push(new Decoration(Math.floor(Math.random()*600)-300,Math.floor(Math.random()*600)-300));
		}
	}

	public function startBattle(){
		inBattle = true;


		Main.tune.volume = .4;

		day++;

		for (grid in nationGrids){
			grid.endOfDay();

			var pop = 0;
			var i = 0;
			for (tile in grid.tiles){
				var tx = i % grid.size.width;
				var ty = Math.floor(i/grid.size.width);

				var citizen:Citizen = null;
				if (tile == NationGrid.Tile.Soldier)
					citizen = new Soldier(this);
				if (tile == NationGrid.Tile.Archer)
					citizen = new Archer(this);
				if (tile == NationGrid.Tile.Blacksmith)
					citizen = new Blacksmith(this);
				if (tile == NationGrid.Tile.Farmer)
					citizen = new Farmer(this);
				if (tile == NationGrid.Tile.Market)
					citizen = new Market(this);
				if (tile == NationGrid.Tile.Fletcher)
					citizen = new Fletcher(this);
				
				if (citizen != null){
					pop++;
					citizen.pos.x = (grid.worldpos.x) + (tx*16); 
					citizen.pos.y = (grid.worldpos.y) + (ty*16);
					citizen.returnToLocation = citizen.pos.mult(1);
					citizen.returnToTile = new kha.math.Vector2i(tx,ty);
					citizen.nation = grid;
					citizen.fromNation = grid.name;
					citizens.push(citizen);
					grid.setTile(tx,ty,NationGrid.Tile.Empty);
				}

				i++;
			}
			grid.startOfBattlePopulation = pop;
		}
		
	}

	function update(): Void {
		frame++;
		// trac e(citizens.length);
		
		var camPanSpeed = 3;
		if (input.keys.get(kha.input.KeyCode.Up))
			camera.pos.y -= camPanSpeed;
		
		if (input.keys.get(kha.input.KeyCode.Down))
			camera.pos.y += camPanSpeed;

		if (input.keys.get(kha.input.KeyCode.Left))
			camera.pos.x -= camPanSpeed;
		
		if (input.keys.get(kha.input.KeyCode.Right))
			camera.pos.x += camPanSpeed;
		
		input.worldMousePos = camera.screenToWorld(input.mousePos);

		for (particle in particles){
			particle.update();
			if (particle.life < 1){
				particles.remove(particle);
			}
		}
		for (projectile in projectiles){
			projectile.update();
			if (projectile.life < 1){
				projectiles.remove(projectile);
				continue;
			}
			for (citizen in citizens){
				if (citizen.fromNation == projectile.fromNation) continue;
				if(Util.aabbCheck(projectile.pos.x+3,projectile.pos.y+3,10,10,citizen.pos.x,citizen.pos.y,16,16)){
					projectiles.remove(projectile);
					//citizens.remove(citizen);
					citizen.health -= 25;
					var sound = Math.random();
					if (sound < .33){
						kha.audio1.Audio.play(kha.Assets.sounds.Hit1);
					}else if (sound < .66){
						kha.audio1.Audio.play(kha.Assets.sounds.Hit2);
					}else{
						kha.audio1.Audio.play(kha.Assets.sounds.Hit3);
					}
					for (i in 0...5)
						particles.push(new BloodParticle(new kha.math.Vector2(4+Math.random()*Camera.zoom+(projectile.pos.x+citizen.pos.x)/2,4+Math.random()*Camera.zoom+(projectile.pos.y+citizen.pos.y)/2)));
				}
			}
		}

		if (inBattle){
			
			for (citizen in citizens){
				citizen.update();
				if (citizen.health < 1){
					citizens.remove(citizen);
				}
				
			}

			// for (citizen in citizens){
			// 	if (citizen.returned && citizen.health > 0){
			// 		citizen.nation.setTile(Math.floor(citizen.returnToTile.x),Math.floor(citizen.returnToTile.y),citizen.tileType);
			// 		citizens.remove(citizen);
			// 	}
			// }

			// if (citizens.length == 0)
			// 	inBattle = false;
			
			
			var finished = true;
			for (citizen in citizens){
				if (!citizen.returned){
					finished = false;
					break;
				}
			}
			if (finished){
				Main.tune.volume = 1;
				for (citizen in citizens){
					citizen.nation.setTile(citizen.returnToTile.x,citizen.returnToTile.y,citizen.tileType);
					if (!citizens.remove(citizen)){
						// trace("Unable to remove citizen of type "+citizen.tileType + " from "+citizen.returnToTile.x+", "+citizen.returnToTile.y+". Returned "+citizen.returned);
					}
					
				}
				for (citizen in citizens){
					citizen.nation.setTile(citizen.returnToTile.x,citizen.returnToTile.y,citizen.tileType);
					// trace("Unremoved citizen of type "+citizen.tileType + " from "+citizen.returnToTile.x+", "+citizen.returnToTile.y+". Returned "+citizen.returned);
				}
				if (citizens.length > 0){
					throw("Error, not all citizens were removed.");
				}
				citizens = [];
				inBattle = false;
			}
		}else{
			tilePlaceIndex += input.mouseScroll;
			if (tilePlaceIndex < 0) tilePlaceIndex = NationGrid.Tile.createAll().length-1;
			if (tilePlaceIndex > NationGrid.Tile.createAll().length-1) tilePlaceIndex = 0;

			if (input.mouseButtonDown){
				if (Util.aabbPointCheck(playerGrid.worldpos.x,playerGrid.worldpos.y,playerGrid.size.width*16,playerGrid.size.height*16,input.worldMousePos.x,input.worldMousePos.y)){
					var tileMousex = Math.floor((input.worldMousePos.x - playerGrid.worldpos.x)/16);	
					var tileMousey = Math.floor((input.worldMousePos.y - playerGrid.worldpos.y)/16);
					if (playerGrid.getTile(tileMousex,tileMousey) != NationGrid.Tile.createByIndex(tilePlaceIndex)){
						playerGrid.setTile(tileMousex,tileMousey,NationGrid.Tile.createByIndex(tilePlaceIndex));
						kha.audio1.Audio.play(kha.Assets.sounds.PlaceTile);
					}
				}
			}

			for (grid in nationGrids){
				if (grid.respect < 1 || grid.gold < 1){
					if (grid.humanControlled){
						//YOU LOSE()
					}else{
						currentLevel++;
						nationGrids.remove(grid);
						enemyGrid = new NationGrid(false,currentLevel);
						enemyGrid.worldpos = new kha.math.Vector2(20,-15);
						enemyGrid.name = "cpu";
						nationGrids.push(enemyGrid);
					}
				}
			}
		}
		input.mouseScroll = 0;
	}

	function render(framebuffer: Framebuffer): Void {
		

		var g = framebuffer.g2;
		g.begin(true,inBattle ? kha.Color.fromBytes(145,190,100) : kha.Color.fromBytes(37,68,64));
		camera.transform(g);
		for (grid in nationGrids){
			grid.render(g);
		}
		for (decoration in decorations)
			decoration.render(g);
		
		for (citizen in citizens){
			citizen.render(g);
		}

		for (projectile in projectiles)
			projectile.render(g);
		for (particle in particles)
			particle.render(g);

		var i = 0;
		for (tile in NationGrid.Tile.createAll()){
			var p = new kha.math.Vector2(playerGrid.worldpos.x - 32,playerGrid.worldpos.y + i*16);

			if (Util.aabbPointCheck(p.x,p.y,16,16,input.worldMousePos.x,input.worldMousePos.y)){

				g.pushTransformation(g.transformation);
				g.transformation._00 = g.transformation._11 = 1;
				g.font = kha.Assets.fonts.mini;
				g.fontSize = 10*Camera.zoom;

				g.color = kha.Color.fromBytes(27,38,50);
				g.fillRect(p.x - 140*Camera.zoom,p.y*Camera.zoom,120*Camera.zoom,32*Camera.zoom);

				g.color = kha.Color.White;

				g.drawString(tile+"",p.x - 138*Camera.zoom,p.y*Camera.zoom);
				g.drawString(tileDescriptions.get(tile),p.x - 138*Camera.zoom,(p.y+10)*Camera.zoom);

				g.transformation._00 = g.transformation._11 = Camera.zoom;
				g.popTransformation();

				if (input.mouseButtonDown)
					tilePlaceIndex = i;
			}
			
			g.color = kha.Color.fromBytes(27,38,50);
			g.drawRect(p.x,p.y,16,16);
			if (i == tilePlaceIndex)
				g.fillRect(p.x,p.y,16,16);
			g.color = kha.Color.White;
			g.drawSubImage(kha.Assets.images.Spritesheet,p.x,p.y,16*i,0,16,16);
			i++;
		}
		g.pushTransformation(g.transformation);
		g.transformation._00 = g.transformation._11 = 1;
		g.font = kha.Assets.fonts.mini;
		g.fontSize = 20*Camera.zoom;

		var topLeft = camera.screenToWorld(new kha.math.Vector2());
		g.color = kha.Color.fromBytes(27,38,50);
		g.fillRect(topLeft.x*Camera.zoom,topLeft.y*Camera.zoom,Camera.zoom*framebuffer.width,Camera.zoom*18);
		g.color = kha.Color.White;

		g.drawString("Day "+day, Camera.zoom * (topLeft.x+1),Camera.zoom*(topLeft.y-1));
		
		g.fontSize = 10*Camera.zoom;
		g.drawString("Add to your forces.", Camera.zoom* (playerGrid.worldpos.x - 32) - g.font.width(g.fontSize,"Add to your forces."),Camera.zoom *playerGrid.worldpos.y);
		g.transformation._00 = g.transformation._11 = Camera.zoom;
		g.popTransformation();

		// g.drawImage(kha.Assets.images.Spritesheet,input.worldMousePos.x,input.worldMousePos.y);
		
		kha.input.Mouse.get().hideSystemCursor();
		g.drawSubImage(kha.Assets.images.Spritesheet,input.worldMousePos.x,input.worldMousePos.y,16,16,16,16);
		if (Util.aabbPointCheck(playerGrid.worldpos.x,playerGrid.worldpos.y,playerGrid.size.width*16,playerGrid.size.height*16,input.worldMousePos.x,input.worldMousePos.y)){		
			g.drawSubImage(kha.Assets.images.Spritesheet,input.worldMousePos.x+8+1,input.worldMousePos.y,16*tilePlaceIndex,0,16,16);
		}
		camera.restore(g);

		g.end();
	}
}