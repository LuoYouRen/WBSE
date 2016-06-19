const far = 2000;
function Obstacle(scene,camera){
	this.height = 30; //物體高度
	this.speed = 10; //物體速度
	this.dir = [0,0,-1];
	this.scene = scene;
	this.cam = camera;
	this.position = [0,0,-50];
	this.mesh;
	this.obj;
	this.block = [false,false,false,false,false,false,false,false,false];
}

//移動
Obstacle.prototype.move = function(){
	this.position[0] = this.position[0]+this.dir[0]*this.speed;
	this.position[1] = this.position[1]+this.dir[1]*this.speed;
	this.position[2] = this.position[2]+this.dir[2]*this.speed;
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
}

//碰撞的判斷
Obstacle.prototype.collision = function(){
	if(Math.abs(this.position[2] - this.cam.position.z)>this.height)return;
	if(this.cam.position.x == -40 && this.cam.position.y == 40 && this.block[0]){
		this.effect();
	}else if(this.cam.position.x == 0 && this.cam.position.y == 40 && this.block[1]){
		this.effect();
	}else if(this.cam.position.x == 40 && this.cam.position.y == 40 && this.block[2]){
		this.effect();
	}else if(this.cam.position.x == -40 && this.cam.position.y == 0 && this.block[3]){
		this.effect();
	}else if(this.cam.position.x == 0 && this.cam.position.y == 0 && this.block[4]){
		this.effect();
	}else if(this.cam.position.x == 40 && this.cam.position.y == 0 && this.block[5]){
		this.effect();
	}else if(this.cam.position.x == -40 && this.cam.position.y == -40 && this.block[6]){
		this.effect();
	}else if(this.cam.position.x == 0 && this.cam.position.y == -40 && this.block[7]){
		this.effect();
	}else if(this.cam.position.x == 40 && this.cam.position.y == -40 && this.block[8]){
		this.effect();
	}
	
}
//碰撞之後的效果
Obstacle.prototype.effect = function(){
	console.log(this.position);
}
//只佔一個格子的物件
function UnitObstacle(num,scene,camera){
	Obstacle.call(this,scene,camera);
	this.setBlock(num);
	this.draw();
	//this.setPosition(num);
}
UnitObstacle.prototype = new Obstacle(); //繼承
UnitObstacle.prototype.constructor = UnitObstacle; //確立建構者
UnitObstacle.prototype.setBlock = function(num){
	this.block = [false,false,false,false,false,false,false,false,false];
	this.block[num]=true;
}
//決定座標
UnitObstacle.prototype.setPosition = function(num){ 
	this.setBlock(num);
	switch(num){
		case 0:
			this.position = [-40,40,far];
		break;
		case 1:
			this.position = [0,40,far];
		break;
		case 2:
			this.position = [40,40,far];
		break;
		case 3:
			this.position = [-40,0,far];
		break;
		case 4:
			this.position = [0,0,far];
		break;
		case 5:
			this.position = [40,0,far];
		break;
		case 6:
			this.position = [-40,-40,far];
		break;
		case 7:
			this.position = [0,-40,far];
		break;
		case 8:
			this.position = [-40,-40,far];
		break;
	}
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
}
//畫出Mesh
UnitObstacle.prototype.draw = function(){
	var materialBox = new BABYLON.StandardMaterial("box", this.scene);
	materialBox.diffuseColor = new BABYLON.Color3(0.3, 0.9, 0.3);//Green
	materialBox.specularColor = new BABYLON.Color3(0.0, 0.0, 0.0);// 0
	this.mesh = new BABYLON.Mesh.CreateBox("box",30,this.scene);
	this.mesh.material = materialBox;
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	
}	
//棒狀障礙物
function RodObstacle(num,scene,camera){
	Obstacle.call(this,scene,camera);
	this.setBlock(num);
	this.draw(num);
	//this.setPosition(num);
}
RodObstacle.prototype = new Obstacle(); //繼承
RodObstacle.prototype.constructor = RodObstacle; //確立建構者

RodObstacle.prototype.draw = function(num){
	var materialRod = new BABYLON.StandardMaterial("rod", this.scene);
	materialRod.diffuseColor = new BABYLON.Color3(0.1, 0.1, 0.9);//blue
	materialRod.specularColor = new BABYLON.Color3(0.0, 0.0, 0.0);// 0
	this.mesh = new BABYLON.Mesh.CreateBox("rod",30,this.scene);
	this.mesh.material = materialRod;
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	
}	
RodObstacle.prototype.setPosition = function(num){
	this.mesh.scaling = new BABYLON.Vector3(1,1,1);
	this.mesh.rotation.z = 0;
	this.setBlock(num);
	switch(num){
		case 0:
			this.position = [0,40,far];
		break;
		case 1:
		case 4:
		case 6:
		case 7:
			this.position = [0,0,far];
		break;
		case 2:
			this.position = [0,-40,far];
		break;
		case 3:
			this.position = [-40,0,far];
		break;
		case 5:
			this.position = [40,0,far];
		break;


	}
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	if(num<3){
		this.mesh.scaling = new BABYLON.Vector3(6,0.5,0.5);
	}else if(num<6){
		this.mesh.scaling = new BABYLON.Vector3(0.5,6,0.5);
	}else if(num==6){
		this.mesh.scaling = new BABYLON.Vector3(6,0.5,0.5);
		this.mesh.rotation.z = Math.PI/4*3;
	}else if(num==7){
		this.mesh.scaling = new BABYLON.Vector3(6,0.5,0.5);
		this.mesh.rotation.z = Math.PI/4;
	}
}
RodObstacle.prototype.setBlock = function(num){
	this.block = [false,false,false,false,false,false,false,false,false];
	switch(num){
		case 0: //上一
			this.block[0] = true;
			this.block[1] = true;
			this.block[2] = true;
		break;
		case 1: //中一
			this.block[3] = true;
			this.block[4] = true;
			this.block[5] = true;
		break;
		case 2: //下一
			this.block[6] = true;
			this.block[7] = true;
			this.block[8] = true;
		break;
		case 3: //左 |
			this.block[0] = true;
			this.block[3] = true;
			this.block[6] = true;
		break;
		case 4: //中 |
			this.block[1] = true;
			this.block[4] = true;
			this.block[7] = true;
		break;
		case 5: //右 |
			this.block[2] = true;
			this.block[5] = true;
			this.block[8] = true;
		break;
		case 6: //左上斜到右下
			this.block[0] = true;
			this.block[4] = true;
			this.block[8] = true;
		break;
		case 7: //右上到左下
			this.block[2] = true;
			this.block[4] = true;
			this.block[6] = true;
		break;	
	}
}
function LObstacle(num){
	Obstacle.call(this);
	this.setBlock(num);
}
LObstacle.prototype = new Obstacle(); //繼承
LObstacle.prototype.constructor = LObstacle; //確立建構者
LObstacle.prototype.setBlock = function(num){
	switch(num){
		case 0: //左上
			this.block[0] = true;
			this.block[1] = true;
			this.block[2] = true;
			this.block[3] = true;
			this.block[6] = true;
		break;
		case 1: //右上
			this.block[0] = true;
			this.block[1] = true;
			this.block[2] = true;
			this.block[5] = true;
			this.block[8] = true;
		break;
		case 2: //左下
			this.block[0] = true;
			this.block[3] = true;
			this.block[6] = true;
			this.block[7] = true;
			this.block[8] = true;
		break;
		case 3: //右下
			this.block[2] = true;
			this.block[5] = true;
			this.block[8] = true;
			this.block[7] = true;
			this.block[6] = true;
		break;
	}
}
function TObstacle(num){
	Obstacle.call(this);
	this.setBlock(num);
}
TObstacle.prototype = new Obstacle(); //繼承
TObstacle.prototype.constructor = TObstacle; //確立建構者
TObstacle.prototype.setBlock = function(num){
	switch(num){
		case 0: //下
			this.block[0] = true;
			this.block[1] = true;
			this.block[2] = true;
			this.block[4] = true;
			this.block[7] = true;
		break;
		case 1: //右
			this.block[0] = true;
			this.block[3] = true;
			this.block[6] = true;
			this.block[4] = true;
			this.block[5] = true;
		break;
		case 2: //上
			this.block[1] = true;
			this.block[4] = true;
			this.block[7] = true;
			this.block[6] = true;
			this.block[8] = true;
		break;
		case 3: //左
			this.block[2] = true;
			this.block[5] = true;
			this.block[8] = true;
			this.block[3] = true;
			this.block[4] = true;
		break;
	}
}
