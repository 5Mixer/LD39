package ;

class Archer extends Citizen {
	var closest:Citizen = null;
	var dist = Math.POSITIVE_INFINITY;
	var attacking:Citizen;
	var damage = .25;
	var firerate = 30;
	var arrows = 5;
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Archer;
		speed = .5+(Math.random()*.75);
		firerate = Math.floor(30+Math.random()*40);//30-50 frames between shots
		arrows = 4+Math.floor(Math.random()*4);
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,4*16,0,16,16);
		damage = .7+Math.random();

	}
	function firing (){
		dist = Math.POSITIVE_INFINITY;
		closest = null;
		for (citizen in project.citizens){
			if (citizen != this && citizen.fromNation != fromNation){
				var d = Math.sqrt(Math.pow(citizen.pos.x - pos.x,2) + Math.pow(citizen.pos.y - pos.y,2));
				if (d < dist){
					closest = citizen;
					dist = d;
				}
			}
		}

		if (frame%firerate==0 && closest != null){
			var arrow = new Arrow(pos.mult(1));
			var angle = Math.atan2(closest.pos.y - pos.y,closest.pos.x - pos.x);
			arrow.fromNation = fromNation;
			arrow.angle = angle;
			arrow.setVelocityFromAngle(angle,3);
			project.projectiles.push(arrow);
			kha.audio1.Audio.play(kha.Assets.sounds.BowShoot3);
			arrows--;
			nation.arrows--;
		}
		
		distBasedBehaviour();
	}
	function gettingCloser (){
		dist = Math.POSITIVE_INFINITY;
		closest = null;
		for (citizen in project.citizens){
			if (citizen != this && citizen.fromNation != fromNation){
				var d = Math.sqrt(Math.pow(citizen.pos.x - pos.x,2) + Math.pow(citizen.pos.y - pos.y,2));
				if (d < dist){
					closest = citizen;
					dist = d;
				}
			}
		}

		if (closest != null){
			var angle = Math.atan2(closest.pos.y - pos.y,closest.pos.x - pos.x);
			velocity.x = Math.cos(angle)*speed;
			velocity.y = Math.sin(angle)*speed;
		}
		distBasedBehaviour();
	}
	override function idle () {
		dist = Math.POSITIVE_INFINITY;
		closest = null;
		for (citizen in project.citizens){
			if (citizen != this && citizen.fromNation != fromNation){
				var d = Math.sqrt(Math.pow(citizen.pos.x - pos.x,2) + Math.pow(citizen.pos.y - pos.y,2));
				if (d < dist){
					closest = citizen;
					dist = d;
				}
			}
		}

		distBasedBehaviour();
	}
	function distBasedBehaviour(){
		if (arrows < 1 || nation.arrows < 1){
			activity = returning;
		}else{
			if (dist < 20){
				activity = returning;
			}else if (dist < 100){
				activity = firing;
			}else if (dist < 400){
				activity = gettingCloser;
			}else{
				activity = returning;
			}
		}
	}
}