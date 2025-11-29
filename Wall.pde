
class Wall {
  PVector p1, p2;
  PImage texture;
  
  Wall() {
    p1 = null;
    p2 = null;
  }
  
  Wall(PVector _p1, PVector _p2) {
    p1 = _p1;
    p2 = _p2;
  }
  
  Wall(PVector _p1, PVector _p2, PImage _texture) {
    p1 = _p1;
    p2 = _p2;
    
    texture = _texture;
  }
  
  Wall(PImage _texture) {
    texture = _texture;
  }
}
