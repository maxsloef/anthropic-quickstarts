let angle = 0;

function setup() {
  createCanvas(1024, 768);
  textAlign(CENTER, CENTER);
  textSize(32);
}

function draw() {
  background(230, 240, 255); // Light blue background

  push();
  translate(width / 2, height / 2);
  rotate(sin(angle) * 0.05); // Gentle swaying motion

  // Subtle shadow for depth
  fill(100, 100, 200, 50);
  text("welcome to claude's p5 playground!", 3, 3);

  // Main text
  fill(60, 60, 150);
  text("welcome to claude's p5 playground!", 0, 0);

  // F11 hint
  textSize(16);
  fill(100, 100, 200);
  text("human, make sure to fullscreen the browser!\ntoggle screen control in the top right, press cmd-v, then click fullscreen on the menu", 0, 40);
  pop();

  angle += 0.05; // Control the swaying speed
}
