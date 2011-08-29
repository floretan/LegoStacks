

class LegoCollection {
  ArrayList pieces;

  LegoCollection() {
    this.pieces = new ArrayList();
  }

  void pick(int x, int y) {
    this.pieces.add(new LegoPiece(get(x, y)));
  }

  void draw() {
    int correctPieces = 0;

    for (int i = 0; i < this.pieces.size(); i++) {
      LegoPiece p = (LegoPiece)this.pieces.get(i);
      p.draw();
    }

    for (int i = 0; i < this.pieces.size(); i++) {
      LegoPiece p = (LegoPiece)this.pieces.get(i);
      if (p.position.mag() == 0) {
        continue;
      }
      boolean orderIsCorrect = true;
      for (int j = i + 1; j < this.pieces.size(); j++) {
        LegoPiece p2 = (LegoPiece)this.pieces.get(j);
        if (p2.position.y > p.position.y) {
          orderIsCorrect = false;
        }
      }

      if (orderIsCorrect) {
        correctPieces++;
      }
    }

    int indicatorBottom = h/2 + this.pieces.size() * 30 / 2;
    for (int i = 0; i < this.pieces.size(); i++) {
      stroke(0);
      noFill();
      rect(w - 30 + 1, indicatorBottom - (i+1)*30 + 1, 20, 20);

      if (i >= correctPieces) {
        noFill();
      }
      else {
        fill(255, 255, 255, 128);
      }
      stroke(255);
      rect(w - 30, indicatorBottom - (i+1)*30, 20, 20);
    }

    if (correctPieces == this.pieces.size() && correctPieces > 0) {
      if (displayMode == DISPLAY_PLAY) {
        gameOver();
      }
    }
  }

  void clear() {
    this.pieces.clear();
  }

  int size() {
    return this.pieces.size();
  }

  void save() {
    if (collection.size() == 0) {
      return;
    }
    PGraphics pg = createGraphics(1, collection.size(), P2D);

    for (int i = 0; i < this.pieces.size(); i++) {
      LegoPiece p = (LegoPiece)this.pieces.get(i);
      pg.set(0, i, p.c);
    }
    pg.save("LegoPieces.png");
  }

  boolean load() {
    this.clear();
    try {
      PImage imageFile = loadImage("LegoPieces.png");    
      for (int i = 0; i < imageFile.height; i++) {
        this.pieces.add(new LegoPiece(imageFile.get(0, i)));
      }
      return true;
    }
    catch (Exception e) {
      return false;
    }
  }
}

