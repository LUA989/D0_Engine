
// Движок посвящён надежде на выход Half-Life 3 18-19 ноября 2025

import java.io.File;
import java.util.Comparator;

float dt = 0, time = 0;

Map currentMap;
Camera viewportCamera;

PImage[] cachedImages;

void setup() {
  size(600, 400, P2D);
  surface.setResizable(true);
  frameRate(1000);
  background(0);
  textAlign(LEFT, TOP);
  
  text("Loading...", 5, 5);
  
  pressedKeys = new ArrayList<>();
  
  precacheTextures(sketchPath() + "\\assets\\textures");
  
  loadMap();
  
  viewportCamera = currentMap.player.camera;
}

void draw() {
  dt = currentMap.w_timeSpeed / frameRate;
  time += dt;
  
  if(currentMap.w_updateEntities) updateEntities();
  
  if(r_drawSky) drawSky();
  renderViewport(viewportCamera);
  
  if(r_drawCrosshair) drawCrosshair(r_crosshairRadius);
  if(r_drawMinimap) drawMinimap(50, 100, r_minimapScale);
  
  if(r_debugText) text("D0 Engine v5\nFPS: " + frameRate +
                       "\nPlayer Position: " + currentMap.player.origin +
                       "\nPlayer Rotation: " + degrees(currentMap.player.direction) + "°" +
                       "\nTime: " + time,
                       5, 5);
}



void loadMap() {
  println("Loading Map...");
  currentMap = new Map();
  currentMap.walls = (Wall[])append(currentMap.walls, new Wall(new PVector(8.75,  5, 2), new PVector(10,  -2.5, 0.0), cachedImages[1]));
  currentMap.walls = (Wall[])append(currentMap.walls, new Wall(new PVector(8.75,  5, 2), new PVector(7.5, -5,   0.0), cachedImages[0]));
  println("Done!\n");
}

void precacheTextures(String path) {
  println("Loading Images...");
  cachedImages = new PImage[]{};
  
  File[] availableFiles = new File(path).listFiles();
  
  println("Available files:");
  printArray(availableFiles);
  println();
  
  for(File f : availableFiles) {
    println("Found file " + f.getAbsolutePath());
    try {
      cachedImages = (PImage[])append(cachedImages, loadImage(f.getAbsolutePath()));
      println("Loaded image " + f.getAbsolutePath());
    } catch(Exception e) {
      println("File " + f.getAbsolutePath() + " is not an image or is corrupted, ignoring...");
    }
  }
  
  println("Done!\n");
  
  println("Cashing Images...");
  for(int i = 0; i < cachedImages.length; i++) {
    cachedImages[i].loadPixels();
  }
  
  println("Done!\n");
}



void updateEntities() {
  for(Entity e : currentMap.entities) {
    e.update();
  }
  
  currentMap.player.update();
  currentMap.player.proceedCollision(currentMap.walls);
}

void drawSky() {
  strokeWeight(1);
  
  for(int i = 0; i < height / 2; i++) { // Небо
    float a = pow((float)i / (height / 2), 3);
    stroke(0, map(a, 0, 1, 16, 200), 255);
    line(0, i, width, i);
  }
  
  for(int i = 0; i < height / 2; i++) { // Земля (с травой)
    float a = pow((float)i / (height / 2), 2);
    stroke(0, 160 - map(a, 0, 1, 95, 31), 0);
    line(0, height / 2 + i, width, height / 2 + i);
  }
}

void renderViewport(Camera viewport) { 
  strokeWeight(1);
  
  for(int i = 0; i < width; i++) {
    float uv = (float)i / width - 0.5;
    
    uv *= tan(radians(cam_fov) / 2);
    
    PVector rd = new PVector(1, uv);
    rd.rotate(viewport.direction);
    rd.normalize();
    
    Ray r = new Ray(viewport.origin, rd);
    
    ArrayList<RayHit> hits = r.cast(currentMap.walls);
    
    for(RayHit hit : hits) {
      hit.dist *= cos(rd.heading() - viewport.direction); // Удаляем фишай
      float drawDist = 1.0 / hit.dist;
      
      int x = round(hit.uv * (hit.texture.width - 1));
      
      float wallTop    = max(hit.wallZStart, hit.wallZEnd);
      float wallBottom = min(hit.wallZStart, hit.wallZEnd);
        
      float wallHeight = wallTop - wallBottom;
      
      float fogLength = r_renderDist - r_fogStartDist;
      float fogAmount = 0;
      
      if(fogLength >= 0 && hit.dist >= r_fogStartDist) fogAmount = map(hit.dist, r_fogStartDist, r_renderDist, 0, 1);
      
      if(r_drawTextures) {
        for(int y = 0; y < hit.texture.height; y++) { // Для каждого пикселя в столбике...
          color imgPix = hit.texture.pixels[y * hit.texture.width + x];
          color pix = color(lerp(red  (imgPix), red  (r_fogColor), fogAmount),
                            lerp(green(imgPix), green(r_fogColor), fogAmount),
                            lerp(blue (imgPix), blue (r_fogColor), fogAmount),
                            lerp(alpha(imgPix), alpha(r_fogColor), fogAmount));
          
          stroke(pix);
          
          float pixYStart = (float)y / hit.texture.height;
          float pixYEnd =   (float)(y + 1) / hit.texture.height;
          
          line(i, map(wallTop - wallHeight * pixYStart - currentMap.player.camera.origin.z, -0.5, 0.5, (0.5 + drawDist) * height, (0.5 - drawDist) * height),
               i, map(wallTop - wallHeight * pixYEnd   - currentMap.player.camera.origin.z, -0.5, 0.5, (0.5 + drawDist) * height, (0.5 - drawDist) * height));
        }
      } else {
        color pix = color(lerp(red  (r_noTextureColor), red  (r_fogColor), fogAmount),
                          lerp(green(r_noTextureColor), green(r_fogColor), fogAmount),
                          lerp(blue (r_noTextureColor), blue (r_fogColor), fogAmount),
                          lerp(alpha(r_noTextureColor), alpha(r_fogColor), fogAmount));
        
        stroke(pix);
        
        line(i, map(wallTop    - currentMap.player.camera.origin.z, -0.5, 0.5, (0.5 + drawDist) * height, (0.5 - drawDist) * height),
             i, map(wallBottom - currentMap.player.camera.origin.z, -0.5, 0.5, (0.5 + drawDist) * height, (0.5 - drawDist) * height));
      }
    }
  }
}

void drawCrosshair(float radius) {
  stroke(255);
  
  line(width / 2 - radius, height / 2, width / 2 + radius, height / 2);
  line(width / 2, height / 2 - radius, width / 2, height / 2 + radius);
}

void drawMinimap(float x, float y, float scale) {
  stroke(255);
  for(Wall w : currentMap.walls) {
    line(w.p1.x * scale + x, w.p1.y * scale + y, w.p2.x * scale + x, w.p2.y * scale + y);
  }
  
  circle(currentMap.player.origin.x * scale + x, currentMap.player.origin.y * scale + y, currentMap.player.radius * 2 * scale);
  line(currentMap.player.origin.x * scale + x,
       currentMap.player.origin.y * scale + y,
       (currentMap.player.origin.x + cos(currentMap.player.direction)) * scale + x,
       (currentMap.player.origin.y + sin(currentMap.player.direction)) * scale + y);
}
