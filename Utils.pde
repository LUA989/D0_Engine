
float cross(PVector v1, PVector v2) {
  return v1.x * v2.y - v2.x * v1.y;
}

float clamp(float x, float min, float max) {
  return max(min, min(x, max));
}

PVector flat(PVector v) {
  return new PVector(v.x, v.y, 0);
}
