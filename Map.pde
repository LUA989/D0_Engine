
class Map {
  Entity[] entities;
  Wall[] walls;
  Player player;
  PVector startPos = new PVector(0, 0, 0);
  float   w_gravity = 0.15;
  float   w_timeSpeed = 1.0;
  boolean w_updateEntities = true;
  
  Map() {
    entities = new Entity[]{};
    walls = new Wall[]{};
    player = new Player(startPos);
  }
  
  Map(Entity[] _entities) {
    entities = _entities;
    walls = new Wall[]{};
    player = new Player(startPos);
  }
  
  Map(Entity[] _entities, Wall[] _walls) {
    entities = _entities;
    walls = _walls;
    player = new Player(startPos);
  }
}
