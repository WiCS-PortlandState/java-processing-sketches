float resolution;
float increment;
float offsetZ;
float colorNoise;
int columns;
int rows;
ArrayList<PVector> flowField = new ArrayList();
ArrayList<Particle> particles = new ArrayList();


void setup() {
  size(1500, 844);
  background(255);
  increment = 0.25;
  resolution = 10;
  offsetZ = 0;
  colorNoise = 0;
  columns = floor(width / resolution);
  rows = floor(height / resolution);
  for(int i = 0; i < columns * rows; i++) {
    flowField.add(new PVector());
  }
  for(int i = 0; i < height; i++) particles.add(new Particle(new PVector(0, i)));
  for(int i = 0; i < width; i++) particles.add(new Particle(new PVector(i, 0)));
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  float offsetY = 0;
  float offsetX = 0;
  for(int y = 0; y < rows; y++) {
    offsetX = 0;
    for(int x = 0; x < columns; x++) {
      int index = x + y * columns;
      float angle = noise(offsetX, offsetY, offsetZ) * TWO_PI * 4;
      PVector vector = PVector.fromAngle(angle);
      vector.setMag(0.8);
      flowField.set(index, vector);
      offsetX += increment;
    }
    offsetY += increment;
    offsetZ += increment * 0.005;
  }
  for(Particle particle : particles) particle.run(floor(noise(colorNoise) * 360));
  fill(360, 75);
  textFont(createFont("Futura-Bold", 200));
  text("WiCS", width/2-400, height/2+25);
  textFont(createFont("Futura-Bold", 50));
  text("perlin noise field", width/2-200, height/2+75);
  fill(360, 20);
  rect(0, 0, width, height);
  colorNoise += 0.05;
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
  }

  void run(int hsb) {
    update();
    display(hsb);
  }

  void update() {
    if(position.x > width) position.x = 0;
    if(position.x < 0) position.x = width;
    if(position.y > height) position.y = 0;
    if(position.y < 0) position.y = height;
    int x = floor(position.x/resolution);
    int y = floor(position.y/resolution);
    acceleration.set(flowField.get(x + y * rows));
    velocity.add(acceleration);
    velocity.limit(2);
    position.add(velocity);
  }

  void display(int hsb) {
    stroke(hsb, 100, 100, 50);
    fill(hsb, 100, 100, 50);
    ellipse(position.x, position.y, 1, 1);
  }
}