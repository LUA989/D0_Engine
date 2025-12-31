
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
