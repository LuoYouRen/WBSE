<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
		<script src="obstacle.js"></script>
        <style>
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
		var isCanMove = true;
		var moveTime = 0;
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
			scene.clearColor = new BABYLON.Color3(0.1, 0.1, 0.1);
            var light0 = new BABYLON.PointLight("Omni", new BABYLON.Vector3(0, 0, 0), scene);     
			var light1 = new BABYLON.PointLight("Omni", new BABYLON.Vector3(0, 0, 100), scene);     
            var camera = new BABYLON.FreeCamera("FreeCamera", new BABYLON.Vector3(0, 0, 0), scene); 
		//	camera.attachControl(canvas, true);			
			camera.keysUp    = []; 
			camera.keysDown  = []; 
			camera.keysLeft  = []; 
			camera.keysRight = []; 		
			var music = new BABYLON.Sound("BGM", "sounds/BGM.wav", scene, function () {		
				music.setVolume(0.5);
				music.play();			
			});			
			music.loop = true;	
			// Fog
			scene.fogMode = BABYLON.Scene.FOGMODE_EXP;
			//BABYLON.Scene.FOGMODE_NONE;
			//BABYLON.Scene.FOGMODE_EXP;
			//BABYLON.Scene.FOGMODE_EXP2;
			//BABYLON.Scene.FOGMODE_LINEAR;

			scene.fogColor = new BABYLON.Color3(0.1, 0.1, 0.1);
			scene.fogDensity = 0.001;
		
			window.addEventListener("keydown", function (evt) {
				// Press W key to go up
				if (evt.keyCode === 87 && isCanMove) { 				
					move('w',scene);
					isCanMove = false;
				}
			});
			window.addEventListener("keydown", function (evt) {
				// Press A key to go left
				if (evt.keyCode === 65 && isCanMove) { 
					move('a',scene);
					isCanMove = false;
				}
			});
			window.addEventListener("keydown", function (evt) {
				// Press S key to go down
				if (evt.keyCode === 83 && isCanMove) { 
					move('s',scene);
					isCanMove = false;
				}
			});
			window.addEventListener("keydown", function (evt) {
				// Press D key to go right
				if (evt.keyCode === 68 && isCanMove) { 
					move('d',scene);
					isCanMove = false;
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
			var box1 = new UnitObstacle(Math.floor(Math.random()*9),scene,camera);
			var box2 = new UnitObstacle(Math.floor(Math.random()*9),scene,camera);
			var box3 = new UnitObstacle(Math.floor(Math.random()*9),scene,camera);
			var rod1 = new RodObstacle(Math.floor(Math.random()*8),scene,camera);
			var L1 = new LObstacle(Math.floor(Math.random()*4),scene,camera);
			var T1 = new TObstacle(Math.floor(Math.random()*4),scene,camera);
			var cross = new CrossObstacle(scene,camera);
			scene.registerBeforeRender(function () {
				time += 1;
				box1.move();
				box2.move();
				box3.move();
				rod1.move();
				L1.move();
				T1.move();
				cross.move();
				box1.collision();
				rod1.collision();
				L1.collision();
				T1.collision();
				cross.collision();
				if(time%60 == 0){					
					if(stage == 1){
						var whichObstacle = Math.floor(Math.random()*5);
						switch(whichObstacle){
							case 0:
								box1.setPosition(Math.floor(Math.random()*9));
								box2.setPosition(Math.floor(Math.random()*9));
								box3.setPosition(Math.floor(Math.random()*9));
							break;					
							case 1:
								rod1.setPosition(Math.floor(Math.random()*8));
							break;
							case 2:
								T1.setPosition(Math.floor(Math.random()*4));	
							break;
							case 3:
								L1.setPosition(Math.floor(Math.random()*4));
							break;
							case 4:
								cross.setPosition();
							break;
						}
					}
					else if(stage == 2){
						var whichObstacle = Math.floor(Math.random()*4);
						switch(whichObstacle){
							case 0:
								box1.setPosition(Math.floor(Math.random()*9));
								rod1.setPosition(Math.floor(Math.random()*8));
							break;					
							case 1:
								rod1.setPosition(Math.floor(Math.random()*8));
								T1.setPosition(Math.floor(Math.random()*4));							
							break;
							case 2:
								rod1.setPosition(Math.floor(Math.random()*8));
								L1.setPosition(Math.floor(Math.random()*4));
							break;
							case 3:
								rod1.setPosition(Math.floor(Math.random()*8));
								cross.setPosition();
							break;
						}
					}
					else if(stage == 3){
						var whichObstacle = Math.floor(Math.random()*4);
						switch(whichObstacle){
							case 0:
								box1.setPosition(Math.floor(Math.random()*9));
								rod1.setPosition(Math.floor(Math.random()*8));
							break;					
							case 1:
								rod1.setPosition(Math.floor(Math.random()*8));
								T1.setPosition(Math.floor(Math.random()*4));							
							break;
							case 2:
								rod1.setPosition(Math.floor(Math.random()*8));
								L1.setPosition(Math.floor(Math.random()*4));
							break;
							case 3:
								rod1.setPosition(Math.floor(Math.random()*8));
								cross.setPosition();
							break;
						}
					}
				}

				plane1.material.diffuseTexture.uOffset -= speed; 
				plane2.material.diffuseTexture.uOffset -= speed; 
				plane3.material.diffuseTexture.uOffset -= speed; 
				plane4.material.diffuseTexture.uOffset -= speed; 
				if(speed < 0.09){
						speed += 0.001;
				}				
				if(camera.position.x>=step)camera.position.x=step;
				if(camera.position.x<=-step)camera.position.x=-step;
				if(camera.position.y>=step)camera.position.y=step;
				if(camera.position.y<=-step)camera.position.y=-step;
			
				
			});
				
            return scene;
        }
        
        var scene = createScene();

        engine.runRenderLoop(function () {
            scene.render();
        });

        // Resize
        window.addEventListener("resize", function () {
            engine.resize();
        });
    </script>
</body>
</html>