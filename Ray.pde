
class Ray {
  PVector o; // Точка начала луча
  PVector u; // Вектор направления луча (должен быть нормализован!)
  
  Ray() {
    o = null;
    u = null;
  }
  
  Ray(PVector _o, PVector _u) {
    o = _o;
    u = _u;
  }
  
  float[] intersect(Wall wall) {
    
    // tu - sv = C - A | Уравнение пересечения с двумя неизвестными (s и t)
    
    PVector v = PVector.sub(wall.p2, wall.p1); // D - C
    PVector w = PVector.sub(wall.p1, o); // C - A
    
    // t ux - s vx = Cx - Ax = wx | Система уравнений для решения
    // t uy - s vy = Cy - Ay = wy
    
    // Решение по правилу Крамера
    
    // [ ux, -vx ]
    // [ uy, -vy ]
    
    float det = cross(u, v);
    
    if(abs(det) < epsilon) return null; // Если стена и луч параллельны
    
    float detT = cross(w, v);
    float detS = cross(w, u);
    
    float t = detT / det;
    float s = detS / det;
    
    if(t < 0)            return null; // Точка за камерой
    if(t > r_renderDist) return null; // Если расстояние больше заданного
    if(s < 0 || s > 1)   return null; // Точка за пределами стены
    
    return new float[]{t, s};
  }
  
  ArrayList<RayHit> cast(Wall[] walls) {
    ArrayList<RayHit> output = new ArrayList<>();
    
    for(Wall w : walls) {
      float[] rayPos = intersect(w);
      
      if(rayPos == null) continue; // Пропускаем неудачные столкновения
      
      output.add(new RayHit(rayPos[0], rayPos[1], w.p1.z, w.p2.z, w.texture));
    }
    
    output.sort( // Сортируем по расстоянию
      new Comparator<RayHit>() {
        int compare(RayHit h1, RayHit h2) {
          if(h1.dist > h2.dist) return -1; else // Так-то должно быть наоборот (как в самом методе compare() класса RayHit), но переворачивать список - лишняя работа, поэтому сразу зададим обратный порядок
          if(h1.dist < h2.dist) return 1;  else
                                return 0;
        }
      }
    );
    
    return output;
  }
}

class RayHit implements Comparator<RayHit> {
  float dist, uv, wallZStart, wallZEnd;
  PImage texture;
  
  RayHit() {
    dist = -1;
    uv = -1;
    
    texture = null;
  }
  
  RayHit(float _dist, float _uv, float _wallZStart, float _wallZEnd, PImage _texture) {
    dist = _dist;
    uv = _uv;
    wallZStart = _wallZStart;
    wallZEnd = _wallZEnd;
    
    texture = _texture;
  }
  
  int compare(RayHit h1, RayHit h2) { // Истиный порядок, но сортировка работает по-другому, по этому не используем этот метод
    if(h1.dist > h2.dist) return 1;  else
    if(h1.dist < h2.dist) return -1; else
                          return 0;
  }
}
