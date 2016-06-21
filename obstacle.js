const far = 3000;
var isCanMove = true;
function Obstacles(scene,camera){
	this.scene = scene;
	this.camera = camera;
	this.array = new Array();
	this.unitArray = new Array();
	this.rodArray = new Array();
	this.lArray = new Array();
	this.tArray = new Array();
	this.crossArray = new Array();
	
}
Obstacles.prototype.newObstacle = function(type){
	var length = this.array.length;
	switch(type){
		case 'u':
			this.array[length] = new UnitObstacle(0,this.scene,this.camera);
			this.unitArray[this.unitArray.length] = this.array[length];
		break;
		case 'r':
			this.array[length] = new RodObstacle(0,this.scene,this.camera);
			this.rodArray[this.rodArray.length] = this.array[length];
		break;
		case 'l':
			this.array[length] = new LObstacle(0,this.scene,this.camera);
			this.lArray[this.lArray.length] = this.array[length];
		break;
		case 't':
			this.array[length] = new TObstacle(0,this.scene,this.camera);
			this.tArray[this.tArray.length] = this.array[length];
		break;
		case 'c':
			this.array[length] = new CrossObstacle(this.scene,this.camera);
			this.crossArray[this.crossArray.length] = this.array[length];
		break;
	}
}
Obstacles.prototype.moveAndCollision = function(){
	for(var i = 0 ; i< this.array.length;i++){
		this.array[i].move();
		this.array[i].collision();
	}
}
Obstacles.prototype.setPosition = function(type){
	switch(type){
		case 'u':
			for(var i=0;i<this.unitArray.length;i++){
				if(this.unitArray[i].position[2]>=0)continue;
				else{
					this.unitArray[i].setPosition(Math.floor(Math.random()*9));
					break;
				}
			}
		break;
		case 'r':
			for(var i=0;i<this.rodArray.length;i++){
				if(this.rodArray[i].position[2]>=0)continue;
				else{
					this.rodArray[i].setPosition(Math.floor(Math.random()*8));
					break;
				}
			}
		break;
		case 'l':
			for(var i=0;i<this.lArray.length;i++){
				if(this.lArray[i].position[2]>=0)continue;
				else{
					this.lArray[i].setPosition(Math.floor(Math.random()*4));
					break;
				}
			}
		break;
		case 't':
			for(var i=0;i<this.tArray.length;i++){
				if(this.tArray[i].position[2]>=0)continue;
				else{
					this.tArray[i].setPosition(Math.floor(Math.random()*4));
					break;
				}
			}
		break;
		case 'c':
			for(var i=0;i<this.crossArray.length;i++){
				if(this.crossArray[i].position[2]>=0)continue;
				else{this.crossArray[i].setPosition();break;}
			}
		break;
	}
}
Obstacles.prototype.setSpeed = function(num){
	for(var i = 0 ; i< this.array.length;i++){
		this.array[i].speed = num;
	}
}

function Obstacle(scene,camera){
	this.height = 30; //物體高度
	this.speed = 60; //物體速度
	this.dir = [0,0,-1];
	this.scene = scene;
	this.cam = camera;
	this.position = [0,0,0];
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
	if(this.cam.position.x <= -20 && this.cam.position.y >= 20 && this.block[0]){
		this.effect();
	}else if(this.cam.position.x <= 20 &&this.cam.position.x >= -20 && this.cam.position.y >= 20 && this.block[1]){
		this.effect();
	}else if(this.cam.position.x >= 20 && this.cam.position.y >= 20 && this.block[2]){
		this.effect();
	}else if(this.cam.position.x <= -20 && this.cam.position.y <= 20&& this.cam.position.y >= -20 && this.block[3]){
		this.effect();
	}else if(this.cam.position.x <= 20 &&this.cam.position.x >= -20  && this.cam.position.y <= 20&& this.cam.position.y >= -20  && this.block[4]){
		this.effect();
	}else if(this.cam.position.x >= 20 && this.cam.position.y <= 20&& this.cam.position.y >= -20&& this.block[5]){
		this.effect();
	}else if(this.cam.position.x <= -20 && this.cam.position.y <= -20 && this.block[6]){
		this.effect();
	}else if(this.cam.position.x <= 20 &&this.cam.position.x >= -20 && this.cam.position.y <= -20 && this.block[7]){
		this.effect();
	}else if(this.cam.position.x >= 20 && this.cam.position.y <= -20 && this.block[8]){
		this.effect();
	}else{
		this.passSound.play();
	}
	
}
//碰撞之後的效果
Obstacle.prototype.effect = function(){
	console.log(this);
	this.collisionSound.play();
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
	this.passSound = new BABYLON.Sound("pass", "sounds/pass.wav", this.scene, null, { loop: false, autoplay: false });
	this.collisionSound = new BABYLON.Sound("collision", "sounds/collision2.wav", this.scene, null, { loop: false, autoplay: false });
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
			this.position = [40,-40,far];
		break;
	}
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
}
//畫出Mesh
UnitObstacle.prototype.draw = function(){
	var materialBox = new BABYLON.StandardMaterial("box", this.scene);
	materialBox.diffuseColor = new BABYLON.Color3(1.0, 1.0, 1.0);//Green
	materialBox.specularColor = new BABYLON.Color3(0.3, 0.3, 0.3);// 0
	materialBox.alpha = 0.4;
	this.mesh = new BABYLON.Mesh.CreateBox("box",40,this.scene);
	this.mesh.material = materialBox;
	this.mesh.scaling =  new BABYLON.Vector3(1, 1, 0.95);
	this.mesh.position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	
	
}

//雲的碰撞效果
//碰撞的判斷
UnitObstacle.prototype.collision = function(){
	if(Math.abs(this.position[2] - this.cam.position.z)>this.height)return;
	if(this.cam.position.x <= -20 && this.cam.position.y >= 20 && this.block[0]){
		this.effect();
	}else if(this.cam.position.x <= 20 &&this.cam.position.x >= -20 && this.cam.position.y >= 20 && this.block[1]){
		this.effect();
	}else if(this.cam.position.x >= 20 && this.cam.position.y >= 20 && this.block[2]){
		this.effect();
	}else if(this.cam.position.x <= -20 && this.cam.position.y <= 20&& this.cam.position.y >= -20 && this.block[3]){
		this.effect();
	}else if(this.cam.position.x <= 20 &&this.cam.position.x >= -20  && this.cam.position.y <= 20&& this.cam.position.y >= -20  && this.block[4]){
		this.effect();
	}else if(this.cam.position.x >= 20 && this.cam.position.y <= 20&& this.cam.position.y >= -20&& this.block[5]){
		this.effect();
	}else if(this.cam.position.x <= -20 && this.cam.position.y <= -20 && this.block[6]){
		this.effect();
	}else if(this.cam.position.x <= 20 &&this.cam.position.x >= -20 && this.cam.position.y <= -20 && this.block[7]){
		this.effect();
	}else if(this.cam.position.x >= 20 && this.cam.position.y <= -20 && this.block[8]){
		this.effect();
	}else{
	}
	
}
//碰撞之後的效果
UnitObstacle.prototype.effect = function(){
	console.log(this);
	isCanMove = false;
	var yaw = new BABYLON.Animation("yaw", "rotation.y", 1, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
						var keys = [];
						keys.push({ frame: 0, value: Math.PI/64 });
						keys.push({ frame: 1, value: Math.PI/-64 });
						keys.push({ frame: 2, value: Math.PI/64 });
						keys.push({ frame: 3, value: Math.PI/-64 });
						keys.push({ frame: 4, value: Math.PI/64 });
						keys.push({ frame: 5, value: Math.PI/-64 });
						keys.push({ frame: 6, value: Math.PI/64 });
						keys.push({ frame: 7, value: Math.PI/-64 });
						keys.push({ frame: 8, value: Math.PI/64 });
						keys.push({ frame: 9, value: Math.PI/-64 });
						keys.push({ frame: 10,value: 0 });
						yaw.setKeys(keys);
						this.cam.animations.push(yaw);		
						this.scene.beginAnimation(this.cam, 0, 11 , false , 11, function(){isCanMove=true;});
	//this.collisionSound.play();
}
//棒狀障礙物
function RodObstacle(num,scene,camera){
	Obstacle.call(this,scene,camera);
	this.setBlock(num);
	this.draw(num);
	this.passSound = new BABYLON.Sound("pass", "sounds/pass.wav", this.scene, null, { loop: false, autoplay: false });
	this.collisionSound = new BABYLON.Sound("collision", "sounds/collision2.wav", this.scene, null, { loop: false, autoplay: false });
	//this.setPosition(num);
}
RodObstacle.prototype = new Obstacle(); //繼承
RodObstacle.prototype.constructor = RodObstacle; //確立建構者

RodObstacle.prototype.draw = function(num){
	var materialRod = new BABYLON.StandardMaterial("rod", this.scene);
	materialRod.diffuseColor = new BABYLON.Color3(0.1, 0.1, 0.9);//blue
	materialRod.specularColor = new BABYLON.Color3(0.0, 0.0, 0.0);// 0
	this.mesh = new BABYLON.Mesh.CreateBox("rod",40,this.scene);
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
		this.mesh.scaling = new BABYLON.Vector3(6,1,1);
	}else if(num<6){
		this.mesh.scaling = new BABYLON.Vector3(1,6,1);
	}else if(num==6){
		this.mesh.scaling = new BABYLON.Vector3(6,1,1);
		this.mesh.rotation.z = Math.PI/4*3;
	}else if(num==7){
		this.mesh.scaling = new BABYLON.Vector3(6,1,1);
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
//L型障礙物
function LObstacle(num,scene,camera){
	Obstacle.call(this,scene,camera);
	this.setBlock(num);
	this.mesh = new Array(2);
	this.passSound = new BABYLON.Sound("pass", "sounds/pass.wav", this.scene, null, { loop: false, autoplay: false });
	this.collisionSound = new BABYLON.Sound("collision", "sounds/collision2.wav", this.scene, null, { loop: false, autoplay: false });
	this.position=[-40,0,-50];
	this.position_=[0,40,-50];
	this.draw();
}

LObstacle.prototype = new Obstacle(); //繼承
LObstacle.prototype.constructor = LObstacle; //確立建構者

LObstacle.prototype.draw = function(){
	var materialL = new BABYLON.StandardMaterial("L", this.scene);
	materialL.diffuseColor = new BABYLON.Color3(0.1, 0.5, 0.5);//blue
	materialL.specularColor = new BABYLON.Color3(0.0, 0.0, 0.0);// 0
	this.mesh[0] = new BABYLON.Mesh.CreateBox("L",40,this.scene);
	this.mesh[1] = new BABYLON.Mesh.CreateBox("L",40,this.scene);
	this.mesh[0].material = materialL;
	this.mesh[1].material = materialL;
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.mesh[0].scaling = new BABYLON.Vector3(6,1,1);
	this.mesh[1].scaling = new BABYLON.Vector3(1,6,1);
}
LObstacle.prototype.move = function(){
	this.position[0] = this.position[0]+this.dir[0]*this.speed;
	this.position[1] = this.position[1]+this.dir[1]*this.speed;
	this.position[2] = this.position[2]+this.dir[2]*this.speed;
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.position_[0] += this.dir[0]*this.speed;
	this.position_[1] += this.dir[1]*this.speed;
	this.position_[2] += this.dir[2]*this.speed;
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
}
LObstacle.prototype.setPosition = function(num){
	this.setBlock(num);
		switch(num){
		case 0: //左上  先橫的再直的
			this.position_ = [0,40,far];
			this.position = [-40,0,far];
		break;
		case 1: //右上
			this.position_ = [0,40,far];
			this.position = [40,0,far];
		break;
		case 2: //左下
			this.position_ = [0,-40,far];
			this.position = [-40,0,far];
		break;
		case 3: //右下
			this.position_ = [0,-40,far];
			this.position = [40,0,far];
		break;
	}
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
}
LObstacle.prototype.setBlock = function(num){
	this.block = [false,false,false,false,false,false,false,false,false];
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
function TObstacle(num,scene,camera){
	Obstacle.call(this,scene,camera);
	this.setBlock(num);
	this.mesh = new Array(2);
	this.passSound = new BABYLON.Sound("pass", "sounds/pass.wav", this.scene, null, { loop: false, autoplay: false });
	this.collisionSound = new BABYLON.Sound("collision", "sounds/collision2.wav", this.scene, null, { loop: false, autoplay: false });
	this.position=[-40,0,-50];
	this.position_=[0,40,-50];
	this.draw();
}
TObstacle.prototype = new Obstacle(); //繼承
TObstacle.prototype.constructor = TObstacle; //確立建構者

TObstacle.prototype.draw = function(){
	var materialT = new BABYLON.StandardMaterial("T", this.scene);
	materialT.diffuseColor = new BABYLON.Color3(0.9, 0.0, 0.5);//purple
	materialT.specularColor = new BABYLON.Color3(0.0, 0.0, 0.0);// 0
	this.mesh[0] = new BABYLON.Mesh.CreateBox("T",40,this.scene);
	this.mesh[1] = new BABYLON.Mesh.CreateBox("T",40,this.scene);
	this.mesh[0].material = materialT;
	this.mesh[1].material = materialT;
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.mesh[0].scaling = new BABYLON.Vector3(6,1,1);
	this.mesh[1].scaling = new BABYLON.Vector3(1,6,1);
}
TObstacle.prototype.move = function(){
	this.position[0] = this.position[0]+this.dir[0]*this.speed;
	this.position[1] = this.position[1]+this.dir[1]*this.speed;
	this.position[2] = this.position[2]+this.dir[2]*this.speed;
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.position_[0] += this.dir[0]*this.speed;
	this.position_[1] += this.dir[1]*this.speed;
	this.position_[2] += this.dir[2]*this.speed;
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
}
TObstacle.prototype.setPosition = function(num){
	this.setBlock(num);
		switch(num){
		case 0: //下  先橫的再直的
			this.position_ = [0,40,far];
			this.position = [0,0,far];
		break;
		case 1: //右
			this.position_ = [0,0,far];
			this.position = [-40,0,far];
		break;
		case 2: //上
			this.position_ = [0,-40,far];
			this.position = [0,0,far];
		break;
		case 3: //左
			this.position_ = [0,0,far];
			this.position = [40,0,far];
		break;
	}
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
}
TObstacle.prototype.setBlock = function(num){
	this.block = [false,false,false,false,false,false,false,false,false];
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
function CrossObstacle(scene,camera){
	Obstacle.call(this,scene,camera);
	this.setBlock();
	this.mesh = new Array(2);
	this.passSound = new BABYLON.Sound("pass", "sounds/pass.wav", this.scene, null, { loop: false, autoplay: false });
	this.collisionSound = new BABYLON.Sound("collision", "sounds/collision2.wav", this.scene, null, { loop: false, autoplay: false });
	this.position=[0,0,-50];
	this.position_=[0,0,-50];
	this.draw();
}
CrossObstacle.prototype = new Obstacle(); //繼承
CrossObstacle.prototype.constructor = CrossObstacle; //確立建構者

CrossObstacle.prototype.draw = function(){
	var materialCross = new BABYLON.StandardMaterial("Cross", this.scene);
	materialCross.diffuseColor = new BABYLON.Color3(0.0, 0.9, 0.9);//purple
	materialCross.specularColor = new BABYLON.Color3(0.0, 0.0, 0.0);// 0
	this.mesh[0] = new BABYLON.Mesh.CreateBox("Cross",40,this.scene);
	this.mesh[1] = new BABYLON.Mesh.CreateBox("Cross",40,this.scene);
	this.mesh[0].material = materialCross;
	this.mesh[1].material = materialCross;
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.mesh[0].scaling = new BABYLON.Vector3(6,1,1);
	this.mesh[1].scaling = new BABYLON.Vector3(1,6,1);
}
CrossObstacle.prototype.move = function(){
	this.position[0] = this.position[0]+this.dir[0]*this.speed;
	this.position[1] = this.position[1]+this.dir[1]*this.speed;
	this.position[2] = this.position[2]+this.dir[2]*this.speed;
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.position_[0] += this.dir[0]*this.speed;
	this.position_[1] += this.dir[1]*this.speed;
	this.position_[2] += this.dir[2]*this.speed;
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
}
CrossObstacle.prototype.setPosition = function(){
	this.position=[0,0,far];
	this.position_=[0,0,far];
	this.mesh[1].position = new BABYLON.Vector3(this.position[0], this.position[1], this.position[2]);
	this.mesh[0].position = new BABYLON.Vector3(this.position_[0], this.position_[1], this.position_[2]);
}
CrossObstacle.prototype.setBlock = function(){
	this.block = [false,true,false,true,true,true,false,true,false];
}

