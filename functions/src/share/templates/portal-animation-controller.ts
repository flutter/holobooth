export default `
(function() {

  function MiniGameLoop(canvas) {
    let lastUpdated;
    let canvasContext;
    this.objects = [];

    this.render = function() {
      this.objects.forEach(function(obj) {
        obj.render(canvasContext);
      });
    }

    this.update = function() {
      const now = Date.now();
      const delta = (now - lastUpdated) / 1000;
      lastUpdated = now;

      this.objects.forEach(function(obj) {
        obj.update(delta);
      });

      requestAnimationFrame(() => {
        this.update();
        console.log(canvas.width, canvas.height);
        canvasContext.clearRect(0, 0, canvas.width, canvas.height);
        this.render(canvasContext);
      });
    }

    this.load = function() {
      lastUpdated = Date.now();

      canvasContext = canvas.getContext("2d");

      this.update();
    }
  }

  function Square() {
    var x = 0; var y = 0;

    this.update = function(dt) {
      x += 100 * dt;
    }

    this.render = function(canvas) {
      canvas.fillStyle = "blue";
      canvas.fillRect(x, y, 20, 20);
    }
  }

  const portalCanvas = document.getElementById('portal-animation');
  const game = new MiniGameLoop(portalCanvas);

  game.objects.push(new Square());

  game.load();

})();
`;
