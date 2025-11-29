
class Map implements Serializable {
  Entity[] entities;
  Wall[] walls;
  Player player;
  
  Map() {
    entities = new Entity[]{};
    walls = new Wall[]{};
    player = new Player(new PVector(0, 0, 0));
  }
  
  Map(Entity[] _entities) {
    entities = _entities;
    walls = new Wall[]{};
    player = new Player();
  }
  
  Map(Entity[] _entities, Wall[] _walls) {
    entities = _entities;
    walls = _walls;
    player = new Player(new PVector(0, 0, 0));
  }
}
