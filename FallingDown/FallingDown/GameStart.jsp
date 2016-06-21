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
		var isCanMove = true;
		var moveTime = 0;
		const
		step = 40;
		const
		move_fps = 10;

		var createScene = function() {
			var scene = new BABYLON.Scene(engine);
			scene.clearColor = new BABYLON.Color3(0.005, 0.005, 0.005);
			var light = new BABYLON.PointLight("Omni", new BABYLON.Vector3(0,
					0, 150), scene);
			var camera = new BABYLON.FreeCamera("FreeCamera",
					new BABYLON.Vector3(0, 0, 0), scene);
			//	camera.attachControl(canvas, true);
			/*
			camera.keysUp    = [87]; // W
			camera.keysDown  = [83]; // S
			camera.keysLeft  = [65]; // A
			camera.keysRight = [68]; // D			
			 */

			window.addEventListener("keydown", function(evt) {
				// Press W key to go up
				if (evt.keyCode === 87 && isCanMove) {
					move('w', scene);
					isCanMove = false;
				}
			});
			window.addEventListener("keydown", function(evt) {
				// Press A key to go left
				if (evt.keyCode === 65 && isCanMove) {
					move('a', scene);
					isCanMove = false;
				}
			});
			window.addEventListener("keydown", function(evt) {
				// Press S key to go down
				if (evt.keyCode === 83 && isCanMove) {
					move('s', scene);
					isCanMove = false;
				}
			});
			window.addEventListener("keydown", function(evt) {
				// Press D key to go right
				if (evt.keyCode === 68 && isCanMove) {
					move('d', scene);
					isCanMove = false;
				}
			});
			function move(act, scene) {
				var cam = scene.cameras[0];
				cam.animations = [];
				var easingFunction = new BABYLON.CircleEase();
				easingFunction
						.setEasingMode(BABYLON.EasingFunction.EASINGMODE_EASEINOUT);
				switch (act) {
				case 'w':
					var w = new BABYLON.Animation("w", "position.y", 60,
							BABYLON.Animation.ANIMATIONTYPE_FLOAT,
							BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
					var keys = [];
					keys.push({
						frame : 0,
						value : cam.position.y
					});
					keys.push({
						frame : move_fps,
						value : cam.position.y += step
					});
					w.setKeys(keys);
					w.setEasingFunction(easingFunction);
					cam.animations.push(w);
					scene.beginAnimation(cam, 0, move_fps, false, 1,
							function() {
								isCanMove = true;
							});
					break;
				case 'a':
					var a = new BABYLON.Animation("s", "position.x", 60,
							BABYLON.Animation.ANIMATIONTYPE_FLOAT,
							BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
					var keys = [];
					keys.push({
						frame : 0,
						value : cam.position.x
					});
					keys.push({
						frame : move_fps,
						value : cam.position.x -= step
					});
					a.setKeys(keys);
					a.setEasingFunction(easingFunction);
					cam.animations.push(a);
					scene.beginAnimation(cam, 0, move_fps, false, 1,
							function() {
								isCanMove = true;
							});
					break;
				case 's':
					var s = new BABYLON.Animation("s", "position.y", 60,
							BABYLON.Animation.ANIMATIONTYPE_FLOAT,
							BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
					var keys = [];
					keys.push({
						frame : 0,
						value : cam.position.y
					});
					keys.push({
						frame : move_fps,
						value : cam.position.y -= step
					});
					s.setKeys(keys);
					s.setEasingFunction(easingFunction);
					cam.animations.push(s);
					scene.beginAnimation(cam, 0, move_fps, false, 1,
							function() {
								isCanMove = true;
							});
					break;
				case 'd':
					var d = new BABYLON.Animation("d", "position.x", 60,
							BABYLON.Animation.ANIMATIONTYPE_FLOAT,
							BABYLON.Animation.ANIMATIONLOOPMODE_CYCLE);
					var keys = [];
					keys.push({
						frame : 0,
						value : cam.position.x
					});
					keys.push({
						frame : move_fps,
						value : cam.position.x += step
					});
					d.setKeys(keys);
					d.setEasingFunction(easingFunction);
					cam.animations.push(d);
					scene.beginAnimation(cam, 0, move_fps, false, 1,
							function() {
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
			plane1.material.diffuseTexture = new BABYLON.Texture(
					"textures/brick1.jpg", scene);
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
			plane2.material.diffuseTexture = new BABYLON.Texture(
					"textures/brick1.jpg", scene);
			plane2.material.diffuseTexture.uScale = 50.0;
			plane2.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
			plane2.material.backFaceCulling = false;
			plane2.position = new BABYLON.Vector3(-60, 0, 2000);
			plane2.rotation = new BABYLON.Vector3(0, -Math.PI / 2, 0);

			//+Y plane
			var plane3 = BABYLON.Mesh.CreatePlane("plane3", 120.0, scene);
			plane3.scaling.x = 50;
			plane3.material = new BABYLON.StandardMaterial("plane3", scene);
			plane3.material.diffuseColor = new BABYLON.Color3(1, 1, 1);
			plane3.material.diffuseTexture = new BABYLON.Texture(
					"textures/brick1.jpg", scene);
			plane3.material.diffuseTexture.uScale = 50.0;
			plane3.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
			plane3.material.backFaceCulling = false;
			plane3.position = new BABYLON.Vector3(0, 60, 2000);
			plane3.rotation = new BABYLON.Vector3(-Math.PI / 2, Math.PI / 2, 0);

			//-Y plane
			var plane4 = BABYLON.Mesh.CreatePlane("plane4", 120.0, scene);
			plane4.scaling.x = 50;
			plane4.material = new BABYLON.StandardMaterial("plane4", scene);
			plane4.material.diffuseColor = new BABYLON.Color3(1, 1, 1);
			plane4.material.diffuseTexture = new BABYLON.Texture(
					"textures/brick1.jpg", scene);
			plane4.material.diffuseTexture.uScale = 50.0;
			plane4.material.specularColor = new BABYLON.Color3(0.00, 0.00, 0.00);
			plane4.material.backFaceCulling = false;
			plane4.position = new BABYLON.Vector3(0, -60, 2000);
			plane4.rotation = new BABYLON.Vector3(Math.PI / 2, Math.PI / 2, 0);

			// Enable Collisions
			scene.collisionsEnabled = true;

			//finally, say which mesh will be collisionable
			plane1.checkCollisions = true;
			var box1 = new UnitObstacle(Math.floor(Math.random() * 9), scene,
					camera);
			scene.registerBeforeRender(function() {
				time += 1;
				box1.move();
				box1.collision();
				if (time % 100 == 0)
					box1.setPosition(Math.floor(Math.random() * 9));

				plane1.material.diffuseTexture.uOffset -= speed;
				plane2.material.diffuseTexture.uOffset += speed;
				plane3.material.diffuseTexture.uOffset -= speed;
				plane4.material.diffuseTexture.uOffset -= speed;
				if (speed < 0.05) {
					speed += 0.001;
				}
				if (camera.position.x >= step)
					camera.position.x = step;
				if (camera.position.x <= -step)
					camera.position.x = -step;
				if (camera.position.y >= step)
					camera.position.y = step;
				if (camera.position.y <= -step)
					camera.position.y = -step;

			});

			return scene;
		}

		var scene = createScene();

		engine.runRenderLoop(function() {
			scene.render();
		});

		// Resize
		window.addEventListener("resize", function() {
			engine.resize();
		});
	</script>
</body>
</html>