<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="ntou.cs.WBSE.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

        <title>啊啊啊掉下去了</title>
        <!-- Babylon.js -->
        <script src="http://www.babylonjs.com/hand.minified-1.2.js"></script>
        <script src="http://www.babylonjs.com/cannon.js"></script>
        <script src="http://www.babylonjs.com/oimo.js"></script>
        <script src="http://www.babylonjs.com/babylon.js"></script>
		<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
		<script src="obstacle.js"></script>
        <style>
			@font-face{
				font-family: myFont1;
				src: url(Rise.otf)
			}
            html, body {
                overflow: hidden;
                width: 100%;
                height: 100%;
                margin: 0;
                padding: 0;
            }

            #renderCanvas {
                width: 100%;
                height: 100%;
                touch-action: none;
            }
			.health {
				display: block;
				width: 210px;
				height: 64px;	
				position: absolute;
				left: 5%;
				top: 5%;
			}
			.health img {
				float: left;
				margin: 3px;
			}
			.endPage {
				display: none;
				background-image: url('lose.png');
				background-repeat:no-repeat;
				width: 724px;
				height: 100%;
				position: absolute;
				left: 50%;
				top: 15%;
				margin-left: -362px;
				margin-top: -98.5px;				
			}
			.score{
				background-image: url('endPage.png');
				background-repeat:no-repeat;
				font-family: myFont1, 微軟正黑體;
				font-size: 240px;
				color: black;	
				align: center;	
				letter-spacing: 30px;	
				padding-left:20px;
				text-align: center;
				line-height: 290px;
				position: absolute;
				width: 550px;
				height: 450px;
				left: 50%;
				top: 30%;
				margin-left: -275px;				
			}
			.homePageButton {
				position: absolute;
				left: 20%;
				top: 65%;
				margin-left: -32px;
				margin-top: -32px;				
			}
			.restartButton {
				position: absolute;
				left: 80%;
				top: 65%;
				margin-left: -32px;
				margin-top: -32px;				
			}
        </style>
    </head>
<body>
    <canvas id="renderCanvas"></canvas>
    <script>
        var canvas = document.getElementById("renderCanvas");
        var engine = new BABYLON.Engine(canvas, true);
		var time = 0;
		var speed = 0; 
		var stage = ${answer};
		var background;
		var moveTime = 0;
		var isGameEnd = false;
		var isMusicPlay = false;
		var score = 0;
		const step = 40;
		const move_fps= 10;
		
		switch(stage){
			case 1:
				background = "brick1";
			break;				
			case 2:
				background = "metal";
			break;
			case 3:
				background = "dirt";
			break;
			
		}
        var createScene = function () {
            var scene = new BABYLON.Scene(engine);
			scene.clearColor = new BABYLON.Color3(0.09, 0.09, 0.09);
            var light0 = new BABYLON.PointLight("Omni", new BABYLON.Vector3(0, 0, 0), scene);     
			var light1 = new BABYLON.PointLight("Omni", new BABYLON.Vector3(0, 0, 100), scene);     
            var camera = new BABYLON.FreeCamera("FreeCamera", new BABYLON.Vector3(0, 0, 0), scene); 
		//	camera.attachControl(canvas, true);			
			camera.keysUp    = []; 
			camera.keysDown  = []; 
			camera.keysLeft  = []; 
			camera.keysRight = []; 		
			var music = new BABYLON.Sound("BGM", "sounds/BGM.wav", scene, function () {		
				if(!isMusicPlay){
					music.setVolume(0.5);
					music.play();	
					isMusicPlay = true;
				}											
			});			
			music.loop = true;	
			// Fog
			scene.fogMode = BABYLON.Scene.FOGMODE_EXP;
			//BABYLON.Scene.FOGMODE_NONE;
			//BABYLON.Scene.FOGMODE_EXP;
			//BABYLON.Scene.FOGMODE_EXP2;
			//BABYLON.Scene.FOGMODE_LINEAR;

			scene.fogColor = new BABYLON.Color3(0.1, 0.1, 0.1);
			scene.fogDensity = 0.0025;
		
			window.addEventListener("keydown", function (evt) {
				// Press W key to go up
				console.log(isCanMove);
				if (evt.keyCode === 87 && isCanMove) { 				
					move('w',scene);
				//	isCanMove = false;
				}
			});
			window.addEventListener("keydown", function (evt) {
				// Press A key to go left
				if (evt.keyCode === 65 && isCanMove) { 
					move('a',scene);
				//	isCanMove = false;
				}
			});
			window.addEventListener("keydown", function (evt) {
				// Press S key to go down
				if (evt.keyCode === 83 && isCanMove) { 
					move('s',scene);
				//	isCanMove = false;
				}
			});
			window.addEventListener("keydown", function (evt) {
				// Press D key to go right
				if (evt.keyCode === 68 && isCanMove) { 
					move('d',scene);
				//	isCanMove = false;
				}
			});
			function move(act,scene) {
				var cam = scene.cameras[0];
				cam.animations = [];
				var easingFunction = new BABYLON.CircleEase();
				easingFunction.setEasingMode(BABYLON.EasingFunction.EASINGMODE_EASEINOUT);
				switch(act){
					case 'w':
						var w = new BABYLON.Animation("w", "position.y",300, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
						var keys = [];
						keys.push({ frame: 0, value: cam.position.y });
						keys.push({ frame: move_fps, value: cam.position.y+=step});
						w.setKeys(keys);
						w.setEasingFunction(easingFunction);
						cam.animations.push(w);				
						scene.beginAnimation(cam, 0, move_fps, false, 1, function (){
							isCanMove = true;
						});			
					break;
					case 'a':
						var a = new BABYLON.Animation("s", "position.x", 300, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
						var keys = [];
						keys.push({ frame: 0, value: cam.position.x });
						keys.push({ frame: move_fps, value: cam.position.x-=step });
						a.setKeys(keys);
						a.setEasingFunction(easingFunction);
						cam.animations.push(a);		
						scene.beginAnimation(cam, 0, move_fps, false, 1, function (){
							isCanMove = true;
						});
					break;
					case 's':
						var s = new BABYLON.Animation("s", "position.y", 300, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
						var keys = [];
						keys.push({ frame: 0, value: cam.position.y });
						keys.push({ frame: move_fps, value: cam.position.y-=step });
						s.setKeys(keys);
						s.setEasingFunction(easingFunction);
						cam.animations.push(s);		
						scene.beginAnimation(cam, 0, move_fps, false, 1, function (){
							isCanMove = true;
						});
					break;
					case 'd':
						var d = new BABYLON.Animation("d", "position.x", 300, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
						var keys = [];
						keys.push({ frame: 0, value: cam.position.x });
						keys.push({ frame: move_fps, value: cam.position.x+=step });
						d.setKeys(keys);
						d.setEasingFunction(easingFunction);
						cam.animations.push(d);		
						scene.beginAnimation(cam, 0, move_fps, false, 1, function (){
							isCanMove = true;
						});
					break;
				}		
			}
		
			//+X plane
            var plane1 = BABYLON.Mesh.CreatePlane("plane1", 120, scene);
			plane1.scaling.x = 50;
            plane1.material = new BABYLON.StandardMaterial("plane1", scene);
            plane1.material.diffuseColor = new BABYLON.Color3(1, 1, 1);
			plane1.material.diffuseTexture = new BABYLON.Texture("textures/" + background + ".jpg", scene);		
			plane1.material.diffuseTexture.uScale = 50.0;
			plane1.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
            plane1.material.backFaceCulling = false;
			plane1.position = new BABYLON.Vector3(60, 0, 2000);
			plane1.rotation = new BABYLON.Vector3(0, Math.PI / 2, 0);	
			
			//-X plane			
            var plane2 = BABYLON.Mesh.CreatePlane("plane2", 120.0, scene);
			plane2.scaling.x = 50;
            plane2.material = new BABYLON.StandardMaterial("plane2", scene);
            plane2.material.diffuseColor = new BABYLON.Color3(1, 1, 1);
			plane2.material.diffuseTexture = new BABYLON.Texture("textures/" + background + ".jpg", scene);
			plane2.material.diffuseTexture.uScale = 50.0;
			plane2.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
            plane2.material.backFaceCulling = false;
            plane2.position = new BABYLON.Vector3(-60, 0, 2000);
            plane2.rotation = new BABYLON.Vector3(0, -Math.PI / 2, Math.PI);
			
			//+Y plane
            var plane3 = BABYLON.Mesh.CreatePlane("plane3", 120.0, scene);
			plane3.scaling.x = 50;
            plane3.material = new BABYLON.StandardMaterial("plane3", scene);
            plane3.material.diffuseColor = new BABYLON.Color3(1, 1, 1);
			plane3.material.diffuseTexture = new BABYLON.Texture("textures/" + background + ".jpg", scene);
			plane3.material.diffuseTexture.uScale = 50.0;
			plane3.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
            plane3.material.backFaceCulling = false;
            plane3.position = new BABYLON.Vector3(0, 60, 2000);     
			plane3.rotation = new BABYLON.Vector3(-Math.PI/2, Math.PI/2, 0); 			
			
			//-Y plane
            var plane4 = BABYLON.Mesh.CreatePlane("plane4", 120.0, scene);
			plane4.scaling.x = 50;
            plane4.material = new BABYLON.StandardMaterial("plane4", scene);
            plane4.material.diffuseColor = new BABYLON.Color3(1, 1, 1);
			plane4.material.diffuseTexture = new BABYLON.Texture("textures/" + background + ".jpg", scene);
			plane4.material.diffuseTexture.uScale = 50.0;
			plane4.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
            plane4.material.backFaceCulling = false;
            plane4.position = new BABYLON.Vector3(0, -60, 2000);   
			plane4.rotation = new BABYLON.Vector3(Math.PI/2, Math.PI/2, 0);  			
        
   

            // Enable Collisions
            scene.collisionsEnabled = true;
        
            //finally, say which mesh will be collisionable
            plane1.checkCollisions = true;
			block = new Obstacles(scene,camera,background);
			for(var i = 0; i < 2 ; i++){
				for(var j=0;j<8;j++){
					block.newObstacle('u');
				}
				block.newObstacle('r');
				block.newObstacle('l');
				block.newObstacle('t');
				block.newObstacle('c');
			}
			scene.registerBeforeRender(function () {
				if(!isGameEnd)time += 1;
			//	console.log(isGameEnd);
				if(time%2 && invincible > 0){
					invincible--;
				}
				if(heart == 2){
					$(".heart1").css("display", "none");
					plane1.material.diffuseTexture.uOffset -= speed; 
					plane2.material.diffuseTexture.uOffset -= speed; 
					plane3.material.diffuseTexture.uOffset -= speed; 
					plane4.material.diffuseTexture.uOffset -= speed; 
				}else if(heart == 1){
					$(".heart1").css("display", "none");
					$(".heart2").css("display", "none");
					plane1.material.diffuseTexture.uOffset -= speed; 
					plane2.material.diffuseTexture.uOffset -= speed; 
					plane3.material.diffuseTexture.uOffset -= speed; 
					plane4.material.diffuseTexture.uOffset -= speed; 
				}else if(heart == 0){
					$(".heart1").css("display", "none");
					$(".heart2").css("display", "none");
					$(".heart3").css("display", "none");
					isGameEnd = true;			
					isCanMove = false;					
			//		console.log(isGameEnd);
				}else{
					$(".heart1").css("display", "block");
					$(".heart2").css("display", "block");
					$(".heart3").css("display", "block");
					plane1.material.diffuseTexture.uOffset -= speed; 
					plane2.material.diffuseTexture.uOffset -= speed; 
					plane3.material.diffuseTexture.uOffset -= speed; 
					plane4.material.diffuseTexture.uOffset -= speed; 
				}
				block.moveAndCollision();
				if(time%60 == 0){					
					if(stage == 1){
						
						var whichObstacle = Math.floor(Math.random()*8);
						switch(whichObstacle){
							case 0:
								block.setPosition('r');
							break;					
							case 1:
								block.setPosition('r');
								block.setPosition('u');
								block.setPosition('u');
							break;
							case 2:
								block.setPosition('l');
							break;
							case 3:
								block.setPosition('t');
							break;
							case 4:
								block.setPosition('c');
							break;
							case 5:
								block.setPosition('l');
								block.setPosition('u');
							break;
							case 6:
								block.setPosition('u');
								block.setPosition('u');
								block.setPosition('u');
							break;
							case 7:
								block.setPosition('r');
								block.setPosition('r');
							break;
							
						}
					}
					else if(stage == 2){
						var whichObstacle = Math.floor(Math.random()*6);
						switch(whichObstacle){
							case 0:
								block.setPosition('u');
								block.setPosition('r');
							break;					
							case 1:
								block.setPosition('r');
								block.setPosition('t');					
							break;
							case 2:
								block.setPosition('r');
								block.setPosition('l');
							break;
							case 3:
								block.setPosition('r');
								block.setPosition('c');
							break;
							case 4:
								block.setPosition('u');
								block.setPosition('c');
								block.setPosition('u');
								block.setPosition('u');
							break;
							case 5:
								block.setPosition('u');
								block.setPosition('t');	
								block.setPosition('u');
								block.setPosition('u');
								block.setPosition('u');
							break;
						}
					}
					else if(stage == 3){
						var whichObstacle = Math.floor(Math.random()*7);
						switch(whichObstacle){
							case 0:
								block.setPosition('u');
								block.setPosition('u');
								block.setPosition('u');
								block.setPosition('r');
							break;					
							case 1:
								block.setPosition('r');
								block.setPosition('t');					
							break;
							case 2:
								block.setPosition('r');
								block.setPosition('l');
							break;
							case 3:
								block.setPosition('r');
								block.setPosition('c');
							break;
							case 4:
								block.setPosition('c');
								block.setPosition('u');
								block.setPosition('u');
							break;
							case 5:
								block.setPosition('l');
								block.setPosition('u');
								block.setPosition('u');
							break;
							case 6:
								block.setPosition('t');
								block.setPosition('u');
								block.setPosition('u');
							break;
						}
					}
				}
				if(stage == 3){
					if(time%(20+Math.floor(Math.random()*40))==0){
						for(var i=0;i<Math.floor(Math.random()*4);i++){
							block.setPosition('u');
						}
					}
				}				
				if(speed < 0.15){
						speed += 0.003;
				}				
				if(camera.position.x>=step)camera.position.x=step;
				if(camera.position.x<=-step)camera.position.x=-step;
				if(camera.position.y>=step)camera.position.y=step;
				if(camera.position.y<=-step)camera.position.y=-step;
				if(isGameEnd){
					showEnd();
				}				
			});		
		
            return scene;
        }
        
        var scene = createScene();

        engine.runRenderLoop(function () {
            scene.render();
        });
		function showEnd(){
			if(stage == 1){
				score = Math.floor(time/100);
			}else if(stage == 2){
				score = Math.floor(time/75);
			}else if(stage == 3){
				score = Math.floor(time/50);
			}
			
			$(".score").html(score);
			$(".endPage").css("display", "block");
			
			if('${sessionScope.user["ID"]}' != "QQ"){
				var site = "FallingRank?need=2&id=" + '${sessionScope.user["ID"]}' + "&name=" + '${sessionScope.user["name"]}' + "&score=" + score;
				$.getJSON(site, function(result) {
					console.log(result);
				});
			}
			
			
			
		}
		function goHomePage(){
			window.location = 'falling.html';			
		}
		function restart() {
			heart = 3;
			time = 0;
			score = 0;
			isCanMove = true;		
			isGameEnd = false;							
			$(".endPage").css("display", "none");	
			scene = createScene();
		}		
		function bigImg(x){
			x.width = 70;
			x.height = 70;
		}
		function normalImg(x){
			x.width = 64;
			x.height = 64;	
		}
        // Resize
        window.addEventListener("resize", function () {
            engine.resize();
        });
    </script>
	<div class = "health">
		<img class = "heart3" src = "heart.png">
		<img class = "heart2" src = "heart.png"> 
		<img class = "heart1" src = "heart.png">
	</div>
	<div class = "endPage" >
		<div class = "score"></div>
		<input id = "homePageButton" class = "homePageButton" type = "image" src="goHome.png" onclick = "goHomePage();" onmouseover = "bigImg(this)" onmouseout= "normalImg(this)"/>	
		<input id = "restartButton" class = "restartButton" type = "image" src="restart.png" onclick = "restart();" onmouseover = "bigImg(this)" onmouseout= "normalImg(this)" />	
	</div>
</body>
</html>
