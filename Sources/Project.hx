package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Project {
	var playerGrid:NationGrid;
	var enemyGrid:NationGrid;
	var input:Input;
	var inBattle = false;
	public var camera:Camera;
	var tilePlaceIndex = 0;
	public var citizens = new Array<Citizen>();
	public var particles = new Array<Particle>();
	public var projectiles = new Array<Projectile>();
	var nationGrids = new Array<NationGrid>();
	var frame = 0;
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

	}

	public function startBattle(){
		inBattle = true;

		for (grid in nationGrids){
			grid.endOfDay();

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
				
				if (citizen != null){
					citizen.pos.x = (grid.worldpos.x) + (tx*16); 
					citizen.pos.y = (grid.worldpos.y) + (ty*16);
					citizen.returnToLocation = citizen.pos.mult(1);
					citizen.returnToTile = new kha.math.Vector2(tx,ty);
					citizen.nation = grid;
					citizen.fromNation = grid.name;
					citizens.push(citizen);
					grid.setTile(tx,ty,NationGrid.Tile.Empty);
				}

				i++;
			}
		}
		
	}

	function update(): Void {
		frame++;
		
		if (input.keys.get(kha.Key.UP))
			camera.pos.y -= 1;
		
		if (input.keys.get(kha.Key.DOWN))
			camera.pos.y += 1;

		if (input.keys.get(kha.Key.LEFT))
			camera.pos.x -= 1;
		
		if (input.keys.get(kha.Key.RIGHT))
			camera.pos.x += 1;
		
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
						particles.push(new BloodParticle(new kha.math.Vector2(4+Math.random()*4+(projectile.pos.x+citizen.pos.x)/2,4+Math.random()*4+(projectile.pos.y+citizen.pos.y)/2)));
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
			
			var finished = true;
			for (citizen in citizens){
				if (!citizen.returned){
					finished = false;
					break;
				}
			}
			if (finished){
				for (citizen in citizens){
					if (citizen.returned){
						citizen.nation.setTile(Math.floor(citizen.returnToTile.x),Math.floor(citizen.returnToTile.y),citizen.tileType);
					}
					citizens.remove(citizen);
				}
				inBattle = false;
			}
		}else{
			tilePlaceIndex += input.mouseScroll;
			if (tilePlaceIndex < 0) tilePlaceIndex = 4;
			if (tilePlaceIndex > 4) tilePlaceIndex = 0;

			if (input.mouseButtonDown){
				if (Util.aabbPointCheck(playerGrid.worldpos.x,playerGrid.worldpos.y,playerGrid.size.width*16,playerGrid.size.height*16,input.worldMousePos.x,input.worldMousePos.y)){
					var tileMousex = Math.floor((input.worldMousePos.x - playerGrid.worldpos.x)/16);	
					var tileMousey = Math.floor((input.worldMousePos.y - playerGrid.worldpos.y)/16);
					playerGrid.setTile(tileMousex,tileMousey,NationGrid.Tile.createByIndex(tilePlaceIndex));
				}
			}
		}
		input.mouseScroll = 0;
	}

	function render(framebuffer: Framebuffer): Void {
		var g = framebuffer.g2;
		g.begin(true,kha.Color.fromBytes(145,190,100));
		camera.transform(g);
		for (grid in nationGrids){
			grid.render(g);
		}
		for (citizen in citizens){
			citizen.render(g);
		}

		for (projectile in projectiles)
			projectile.render(g);
		for (particle in particles)
			particle.render(g);
		
		// g.drawImage(kha.Assets.images.Spritesheet,input.worldMousePos.x,input.worldMousePos.y);
		
		g.drawSubImage(kha.Assets.images.Spritesheet,input.worldMousePos.x,input.worldMousePos.y,16*tilePlaceIndex,0,16,16);
		camera.restore(g);
		g.end();
	}
}
