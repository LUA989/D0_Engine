
abstract class Entity {
  abstract void update();
}

abstract class StaticEntity extends Entity {
}

class Camera extends StaticEntity {
  PVector origin;
  float direction;
  
  Camera() {
    origin = new PVector();
    direction = 0;
  }
  
  Camera(PVector _origin, float _direction) {
    origin = _origin;
    direction = _direction;
  }
  
  Camera(PVector _origin) {
    origin = _origin;
    direction = 0;
  }
  
  Camera(float _direction) {
    origin = new PVector();
    direction = _direction;
  }
  
  void update() {}
}

abstract class DynamicEntity extends Entity {
  abstract void proceedPhysics(float dt);
}

class Player extends DynamicEntity {
  PVector origin, velocity;
  float direction;
  
  final PVector camPos = new PVector(0, 0, 1.875);
  
  final float radius = 0.25, height = 2, speed = 5;
  float pl_friction = 0.05;
  
  Camera camera;
  
  Player() {
    origin = new PVector();
    velocity = new PVector();
    direction = 0;
    camera = new Camera();
  }
  
  Player(PVector _origin) {
    origin = _origin;
    velocity = new PVector();
    direction = 0;
    camera = new Camera();
  }
  
  Player(PVector _origin, float _direction) {
    origin = _origin;
    direction = _direction;
    camera = new Camera();
  }
  
  void update() {
    if(keyPressed) {
      
      if(isOnGround()) {
        switch(key) {
          case 'w':
          velocity = PVector.mult(PVector.fromAngle(direction), speed);
          break;
          
          case 'W':
          velocity = PVector.mult(PVector.fromAngle(direction), speed * 2.25);
          break;
          
          case 's':
          velocity = PVector.mult(PVector.fromAngle(direction + PI), speed);
          break;
          
          case 'a':
          velocity = PVector.mult(PVector.fromAngle(direction - HALF_PI), speed);
          break;
          
          case 'd':
          velocity = PVector.mult(PVector.fromAngle(direction + HALF_PI), speed);
          break;
          
          case ' ':
          velocity.z += 5;
          break;
        }
      }
      
      switch(key) {
        case 'q':
        direction -= PI / 2 * dt;
        break;
        
        case 'e':
        direction += PI / 2 * dt;
        break;
        
        case 'r':
        origin.z += 1 * dt;
        break;
        
        case 'f':
        origin.z -= 1 * dt;
        break;
      }
    }
    
    proceedPhysics(dt);
    
    currentMap.player.direction = (currentMap.player.direction + TWO_PI) % TWO_PI;
  }
  
  void proceedPhysics(float dt) {
    origin.add(PVector.mult(velocity, dt));
    
    if(isOnGround()) {
      velocity = flat(velocity).div(pl_friction + 1.0); // Чтобы при трении в 0 мы просто бесконечно скользили, а не улетали в бесконечность
      velocity.z *= -1;
    }
    
    velocity.z -= currentMap.w_gravity * dt;
    
    camera.origin = PVector.add(origin, camPos);
    camera.direction = direction;
  }
  
  float distSq(Wall w) {
    PVector u  = flat(PVector.sub(w.p2, w.p1));
    PVector ao = flat(PVector.sub(origin, w.p1));
    float proj = PVector.dot(u, ao) / u.magSq();
    
    proj = clamp(proj, 0, 1);
    
    PVector c = PVector.add(w.p1, PVector.mult(u, proj));
    
    float distSq = sq(origin.x - c.x) + sq(origin.y - c.y);
    
    return distSq;
  }
  
  boolean isColliding(Wall w) {
    if(origin.z > max(w.p1.z, w.p2.z))          return false; // Если игрок над стеной
    if(origin.z + height < min(w.p1.z, w.p2.z)) return false; // Если игрок под стеной
    
    float distSq = distSq(w);
    
    return distSq < radius * radius;
  }
  
  void proceedCollision(Wall w) { 
    if(origin.z > max(w.p1.z, w.p2.z))          return; // Если игрок над стеной
    if(origin.z + height < min(w.p1.z, w.p2.z)) return; // Если игрок под стеной
    
    float distSq = distSq(w);
    
    if(distSq >= radius * radius) return; // Расстояние от отрезка больше радиуса игрока
    
    float dist = sqrt(distSq);
    
    PVector u = flat(PVector.sub(w.p2, w.p1));
    
    PVector n = new PVector(-u.y, u.x);  // Первая нормаль (против часовой стрелки)
    PVector n2 = new PVector(u.y, -u.x); // Вторая нормаль (по часовой стрелке)
    
    PVector ao = flat(PVector.sub(origin, w.p1)); // Направление от стены к игроку
    
    if(n.dot(ao) < 0) n = n2; // Выбираем только ту нормаль, которая повёрнута к нам, чтобы сталкиваться с обеих сторон
    
    n.normalize();
    
    float penetration = radius - dist; // Проникновение в стену
    // float proj = PVector.dot(u, velocity) / u.magSq();
    
    origin.add(PVector.mult(n, penetration));
    // velocity.sub(PVector.mult(n1, proj));
  }
  
  boolean isOnGround() {
    if(origin.z < 0) origin.z = 0;
    return origin.z == 0;
  }
  
  void proceedCollision(Wall[] walls) {
    for(Wall w : walls) proceedCollision(w);
  }
}
