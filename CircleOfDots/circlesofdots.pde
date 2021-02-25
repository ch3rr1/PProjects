void setup() {
  size(400, 400, P2D);
  frameRate(30);
  smooth(8);
  strokeWeight(4);
  noFill();
}

void draw() {
  background(#191030);
  blendMode(SCREEN);
  translate(width / 2, height / 2);

  for (float a = 0; a < TAU - 0.001; a += TAU / 72) {
    float time1 = Ease.hermite5(1 - timeBounce(120, a / TAU * 120), 2);
    float time2 = Ease.hermite5(1 - timeBounce(120, a / TAU * 120 + 60), 1);
    float in = time1 * 10 + 80;
    float out = time2 * 70 + 90;

    stroke(#ff3351);
    drawDots(cos(a) * in, sin(a) * in, cos(a) * out, sin(a) * out);
    stroke(#33e2ff);
    drawDots(cos(a + tau(0.333)) * in, sin(a + tau(0.333)) * in, cos(a + tau(0.333)) * out, sin(a + tau(0.333)) * out);
    stroke(#5e33ff);
    drawDots(cos(a + tau(0.666)) * in, sin(a + tau(0.666)) * in, cos(a + tau(0.666)) * out, sin(a + tau(0.666)) * out);
  }
}

void drawDots(float x1, float y1, float x2, float y2) {
  strokeCap(ROUND);
  for (float i = 0; i < 1; i += 0.2) {
    float xp1 = lerp(x1, x2, i);
    float yp1 = lerp(y1, y2, i);
    float weight = Ease.hermite5(Ease.tri(gradientSpiral(xp1 + width / 2, yp1 + height / 2, timeLoop(120), 1)), 2);

    strokeWeight(weight * 8 + 2);
    point(xp1, yp1);
  }
}

// Time, gradient and other helper junk.

float timeLoop(float totalframes, float offset) {
  return (frameCount + offset) % totalframes / totalframes;
}

float timeLoop(float totalframes) {
  return timeLoop(totalframes, 0);
}

float timeBounce(float totalframes, float offset) {
  return Ease.tri(timeLoop(totalframes, offset));
}

float gradientSpiral(float x, float y, float offset, float frequency) {
  float xc = width / 2;
  float yc = height / 2;
  float normalisedRadius = length(x - xc, y - yc) / max(xc, yc);
  float plotAngle = atan2(y - yc, x - xc);
  float waveAngle = normalisedRadius * TAU * frequency;
  return wrap(radWrap(plotAngle + waveAngle) / TAU, 1 - offset);
}

float radWrap(float rad) {
  float r = rad % TAU;
  return r < 0 ? r + TAU : r;
}

float wrap(float value, float offset) {
  return (value + offset) % 1;
}

float length(float x, float y) {
  return sqrt(x * x + y * y);
}

float tau(float fraction) {
  return TAU * fraction;
}

static class Ease {

  // Hermite5 interpolation.

  static public float hermite5(float t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
  }

  static public float hermite5(float t, int repeat) {
    for (int i = 0; i < repeat; i++) {
      t = hermite5(t);
    }
    return t;
  }

  // Triangle interpolation.

  static public float tri(float t, float repeat) {
    return t * repeat * 2 % 2 <= 1 ? t * repeat * 2 % 2 : 2 - (t * repeat * 2 % 2);
  }

  static public float tri(float t) {
    return t < 0.5 ? t * 2 : 2 - (t * 2);
  }
}
