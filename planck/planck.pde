/*
 * Decompiled with CFR 0_115.
 */
import processing.core.PApplet;
import processing.core.PFont;

Particle[] particles;
int counter = 0;
int maxParticles = 5000;
int totalParticles = 0;

void setup() {
        size(800, 600, P3D);
        hint(0);
        background(255);
        ellipseMode(3);
        fill(250.0f, 0.0f, 0.0f);
        particles = new Particle[maxParticles];
        textAlign(39);
}

void keyPressed() {
}

void draw() {
      background(245);
      lights();
      fill(255);
      noStroke();
      sphereDetail(30);
      pushMatrix();
      translate(width / 2, height / 2, 0.0f);
      sphere(140.0f);
      popMatrix();
      noLights();
      sphereDetail(16);
      if (mousePressed && totalParticles < maxParticles - 1) {
          particles[totalParticles] = new Particle(mouseX, mouseY, 0, random(-8.0f, 8.0f), random(-8.0f, 8.0f), random(-50.0f, 50.0f), totalParticles);
          ++totalParticles;
      }
      int n = 0;
      while (n < totalParticles) {
          particles[n].gravity();
          particles[n].adjust(particles, totalParticles);
          particles[n].render();
          ++n;
      }
      fill(0);
}

public class Particle {
      public int index;
      public float x;
      public float y;
      public float z;
      public float px;
      public float py;
      public float pz;
      public float xv;
      public float yv;
      public float zv;
      public float Q;
      public Vector vec;
      public int r;
      public int g;
      public int b;
      public float damp;
      public boolean dead;

      public void adjust(Particle[] particles, int count) {
          float f = 1.0f;
          float f2 = 1.0f;
          boolean bl = false;
          int n = 0;
          while (n < count) {
              if (n != this.index) {
                  float f3 = dist(this.x, this.y, this.z, particles[n].x, particles[n].y, particles[n].z);
                  float f4 = particles[n].Q / (f3 * f3);
                  float f5 = abs(f) * abs(particles[n].Q) / pow(f3, 12.0f);
                  float f6 = f * f4 + f5;
                  float f7 = f6 / f2 * 2000.0f * norm(mouseX, 0.0f, width);
                  if (f3 > 0.01f) {
                      this.xv += f7 * (this.x - particles[n].x) / f3;
                      this.yv += f7 * (this.y - particles[n].y) / f3;
                      this.zv += f7 * (this.z - particles[n].z) / f3;
                  }
              }
              ++n;
          }
          this.xv *= this.damp;
          this.yv *= this.damp;
          this.zv *= this.damp;
      }

      public void jiggle() {
          this.xv += random(-2.0f, 2.0f);
          this.yv += random(-2.0f, 2.0f);
          this.zv += random(-2.0f, 2.0f);
      }

      public void gravity() {
          float f = width / 2;
          float f2 = height / 2;
          float f3 = 0.0f;
          float f4 = 0.9f;
          float f5 = dist(this.x, this.y, this.z, width / 2, height / 2, 0.0f);
          if (f5 > 0.1f) {
              float f6 = f4 * (f - this.x) / f5;
              float f7 = f4 * (f2 - this.y) / f5;
              float f8 = f4 * (f3 - this.z) / f5;
              this.xv += f6;
              this.yv += f7;
              this.zv += f8;
              this.xv *= 0.96f;
              this.yv *= 0.96f;
              this.zv *= 0.96f;
          }
      }
      
        public void render() {
            float f = dist(this.x, this.y, this.z, width / 2, height / 2, 0.0f);
            float f2 = dist(this.x + this.xv, this.y + this.yv, this.z + this.zv, width / 2, height / 2, 0.0f);
            if (f < 148.0f && f >= f2) {
                this.xv = 0.0f;
                this.yv = 0.0f;
                this.zv = 0.0f;
            }
            this.x += this.xv;
            this.y += this.yv;
            this.z += this.zv;
            stroke(0);
            lights();
            fill(240.0f, 40.0f, 40.0f);
            noStroke();
            pushMatrix();
            translate(this.x, this.y, this.z);
            sphere(8.0f);
            popMatrix();
            noLights();
            this.px = this.x;
            this.py = this.y;
            this.pz = this.z;
        }

        private final float findAngle(float f, float f2, float f3, float f4) {
            float f5 = f - f3;
            float f6 = f2 - f4;
            float f7 = atan2(f6, f5);
            float f8 = 180.0f + (- 180.0f * f7) / 3.1415927f;
            return f8;
        }

        public void drawRing(int n, int n2, int n3, float f, float f2, int n4) {
            float f3 = 1.0f / (float)n4 * 6.2831855f;
            beginShape(128);
            int n5 = 0;
            while (n5 < n4) {
                vertex((float)n + f * cos((float)n5 * f3), (float)n2 + f * sin((float)n5 * f3), n3);
                vertex((float)n + f2 * cos((float)n5 * f3), (float)n2 + f2 * sin((float)n5 * f3), n3);
                vertex((float)n + f2 * cos((float)(n5 + 1) * f3), (float)n2 + f2 * sin((float)(n5 + 1) * f3), n3);
                vertex((float)n + f * cos((float)(n5 + 1) * f3), (float)n2 + f * sin((float)(n5 + 1) * f3), n3);
                ++n5;
            }
            endShape();
        }

        private final /* synthetic */ void cfr_renamed_1() {
            this.xv = 1.0f;
            this.yv = 1.0f;
            this.zv = 1.0f;
            this.Q = 1.0f;
            this.r = 0;
            this.g = 0;
            this.b = 0;
            this.damp = 0.96f;
            this.dead = false;
        }

        Particle(int n, int n2, int n3, float f, float f2, float f3, int n4) {
            this.cfr_renamed_1();
            this.x = n;
            this.y = n2;
            this.z = n3;
            this.px = this.x;
            this.py = this.y;
            this.pz = this.z;
            this.xv = 0.0f;
            this.yv = 0.0f;
            this.zv = f3;
            this.r = (int)random(255.0f);
            this.g = (int)random(255.0f);
            this.b = (int)random(255.0f);
            this.index = n4;
        }
        
      public class Vector {
      float X;
      float Y;
      float Z;

      public float dotProduct(Vector vector, Vector vector2) {
          return vector.X * vector2.X + vector.Y * vector2.Y + vector.Z * vector2.Z;
      }

      public float magnitude() {
          return (float)Math.sqrt(this.X * this.X + this.Y * this.Y + this.Z * this.Z);
      }

      public void normalize() {
          float f = this.magnitude();
          if (f != 0.0f) {
              this.X /= f;
              this.Y /= f;
              this.Z /= f;
          }
      }

      private Vector() {
      }
  }
 }