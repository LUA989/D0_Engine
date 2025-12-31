
int k_forward = 'w';
int k_backward = 's';
int k_turnLeft = 'q';
int k_turnRight = 'e';
int k_slideLeft = 'a';
int k_slideRight = 'd';

Consumer<Event> playerController = event -> {
  if(event instanceof KeyPressedEvent) {
    if((int)event.data == k_forward)    currentMap.player.isWalkingForward  = true;
    if((int)event.data == k_backward)   currentMap.player.isWalkingBackward = true; 
    if((int)event.data == k_slideLeft)  currentMap.player.isWalkingLeft     = true; 
    if((int)event.data == k_slideRight) currentMap.player.isWalkingRight    = true; 
    if((int)event.data == k_turnLeft)   currentMap.player.isRotatingLeft    = true; 
    if((int)event.data == k_turnRight)  currentMap.player.isRotatingRight   = true; 
  }
  
  if(event instanceof KeyReleasedEvent) {
    if((int)event.data == k_forward)    currentMap.player.isWalkingForward  = false;
    if((int)event.data == k_backward)   currentMap.player.isWalkingBackward = false; 
    if((int)event.data == k_slideLeft)  currentMap.player.isWalkingLeft     = false; 
    if((int)event.data == k_slideRight) currentMap.player.isWalkingRight    = false; 
    if((int)event.data == k_turnLeft)   currentMap.player.isRotatingLeft    = false; 
    if((int)event.data == k_turnRight)  currentMap.player.isRotatingRight   = false; 
  }
};

class Player extends DynamicEntity {
  PVector origin, velocity;
  float direction;
  EventListener keyListener;
  
  final PVector camPos = new PVector(0, 0, 1.875);
  
  final float radius = 0.25, height = 2, speed = 5;
  float pl_friction = 0.05;
  
  boolean isWalkingForward  = false,
          isWalkingBackward = false,
          isWalkingLeft     = false,
          isWalkingRight    = false,
          isRotatingLeft    = false,
          isRotatingRight   = false,
          isJumping         = false;
  
  Camera camera;
  
  Player() {
    origin = new PVector();
    velocity = new PVector();
    direction = 0;
    camera = new Camera();
    keyListener = new EventListener(playerController);
  }
  
  Player(PVector _origin) {
    origin = _origin;
    velocity = new PVector();
    direction = 0;
    camera = new Camera();
    keyListener = new EventListener(playerController);
  }
  
  Player(PVector _origin, float _direction) {
    origin = _origin;
    direction = _direction;
    camera = new Camera();
    keyListener = new EventListener();
  }
  
  void update() {
    if(keyPressed) {
      
      if(isOnGround()) {
        PVector moveDir = new PVector();
        
        if(isWalkingForward)  moveDir.x += speed;
        if(isWalkingBackward) moveDir.x -= speed;
        if(isWalkingLeft)     moveDir.y -= speed;
        if(isWalkingRight)    moveDir.y += speed;
        
        moveDir.rotate(direction);
        
        velocity = moveDir;
      }
      
      if(isRotatingLeft)  direction -= PI / 2 * dt;
      if(isRotatingRight) direction += PI / 2 * dt;
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
