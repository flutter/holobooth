export default `
(function() {

  function MiniGameLoop(canvas, container, animation, [frameReference]) {
    let lastUpdated;
    let canvasContext;
    let scale = 1;
    this.objects = [];
    const landscape = document.body.offsetWidth > document.body.offsetHeight;

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

        canvasContext.clearRect(0, 0, canvas.width, canvas.height);

        canvasContext.save();

        canvasContext.scale(scale, scale);

        this.render(canvasContext);

        canvasContext.restore();
      });
    }

    this.addObject = async function(obj) {
      await obj.load();
      this.objects.push(obj);
    }

    this.load = async function() {

      this.objects.push(animation);

      lastUpdated = Date.now();

      canvasContext = canvas.getContext("2d");

      await Promise.all(this.objects.map((o) => o.load(canvas)));

      const observer = new ResizeObserver((_) => {
        this.fixBounds();
      });
      observer.observe(container);

      this.update();
    }

    this.fixBounds = function() {
      const animationSize = animation.size();
      const [
        animationW,
        animationH,
      ] = animationSize;

      const aspect = animationW / animationH;
      let canvasW;
      let canvasH;

      if (landscape) {
        canvasW = container.offsetWidth * .75;
        canvasH = canvasW * aspect;
      } else {
        canvasH = container.offsetHeight * .75;
        canvasW = canvasH * aspect;
      }

      canvas.width = canvasW;
      canvas.height = canvasH;


      const scaleX = canvas.width / animationW;
      const scaleY = canvas.height / animationH;

      scale = Math.min(scaleX, scaleY);
    }
  }

  const portalMode = {
    portrait: {
      texturePath: '{{{assetUrls.mobilePortalSpritesheet}}}',
      textureSize: [650, 850],
      thumbSize: [322, 378],
      thumbOffset: [168, 104],
    },
    landscape: {
      texturePath: '{{{assetUrls.desktopPortalSpritesheet}}}',
      textureSize: [710, 750],
      thumbSize: [498, 280],
      thumbOffset: [100, 96],
    },
  };

  function ThumbSprite({
    spritePath,
    playIconPath,
    position = [0, 0],
    size,
  }) {
    let image;
    let playIconImage;
    let loaded = false;
    let playIconLoaded = false;

    let x = position[0]; y = position[1];

    let renderOffset, renderSize;

    this.load = function(canvas) {
      const thumbPromise = new Promise((resolve, reject) => {
        if (image && loaded) {
          resolve();
        } else {
          image = new Image();
          image.src = spritePath;
          image.onload = function() {
            const [thumbWidth, thumbHeight] = size;
            const rateX = thumbWidth / image.width;
            const rateY = thumbHeight / image.height;

            const rate = Math.max(rateX, rateY);

            renderSize = [image.width * rate, image.height * rate];
            const [renderWidth, renderHeight] = renderSize;

            renderOffset = [
              (thumbWidth / 2) - renderWidth / 2,
              (thumbHeight / 2) - renderHeight / 2,
            ];

            resolve();
          }
        }
      });

      const playIconPromise = new Promise((resolve, reject) => {
        if (playIconImage && playIconLoaded) {
          resolve();
        } else {
          playIconImage = new Image();
          playIconImage.src = playIconPath;
          playIconImage.onload = function() {
            resolve();
          }
        }
      });
      return Promise.all([thumbPromise, playIconPromise]);
    };

    this.update = function(_) {}

    this.render = function(canvas) {
      const [thumbWidth, thumbHeight] = size;
      const [renderWidth,renderHeight] = renderSize;
      const [offsetX, offsetY] = renderOffset;

      canvas.save();

      canvas.clip(canvas.rect(x, y, thumbWidth, thumbHeight));
      canvas.drawImage(
        image,
        0, // sX
        0, // sY
        image.width, // sWidth
        image.height, // sHeight
        x + offsetX, // dX
        y + offsetY, // dY
        renderWidth, // dWidth
        renderHeight, // dHeight
      );

      canvas.drawImage(
        playIconImage,
        x + thumbWidth / 2 - 75,
        y + thumbHeight / 2 - 75,
        140,
        140,
      );

      canvas.restore();
    }
  }

  function SpriteAnimation({
    texturePath,
    textureSize,
    stepTime,
    onComplete,
  }) {
    let image;
    const frames = [];
    let currentFrame;

    let currentTime = 0;
    let completed = false;

    let x = 0, y = 0;

    this.size = function() {
      return textureSize;
    }

    this.load = function(canvas) {
      return new Promise((resolve, reject) => {
        image = new Image();
        image.src = texturePath;
        image.onload = function() {
          const [textureWidth, textureHeight] = textureSize;

          const columns =  image.width / textureWidth;
          const rows = image.height / textureHeight;

          for (let y = 0; y < rows; y++) {
            for (let x = 0; x < columns; x++) {
              frames.push({
                y: y * textureHeight,
                x: x * textureWidth,
                textureWidth,
                textureHeight,
              });
            }
          }

          currentFrame = frames[0];

          resolve();
        }
      });
    };

    this.render = function(canvas) {
      if (currentFrame) {
        canvas.drawImage(
          image,
          currentFrame.x, // sx
          currentFrame.y, // sy
          currentFrame.textureWidth, // sWidth
          currentFrame.textureHeight, // sHeight
          x, // dx
          y, // dy
          currentFrame.textureWidth, // dWidth
          currentFrame.textureHeight, // dHeight
        );
      }
    };

    this.update = function(dt) {
      if (currentFrame && !completed) {
        currentTime += dt;
        if (currentTime >= stepTime) {
          currentTime -= stepTime;

          const i = frames.indexOf(currentFrame);
          if (i + 1 < frames.length) {
            currentFrame = frames[i + 1];
          } else {
            completed = true;
            onComplete();
          }
        }
      }
    };
  }

  const portalCanvas = document.getElementById('portal-animation');
  const container = document.querySelector('.share-video');

  const mode = document.body.offsetWidth > document.body.offsetHeight
    ? portalMode.landscape
    : portalMode.portrait;

  const animation = new SpriteAnimation({
    texturePath: mode.texturePath,
    textureSize: mode.textureSize,
    stepTime: 0.05,
    onComplete: onComplete,
  });

  const game = new MiniGameLoop(
    portalCanvas,
    container,
    animation,
    mode.textureSize,
  );

  const thumb = new ThumbSprite({
    spritePath: '{{{thumbImageUrl}}}',
    playIconPath: '{{{assetUrls.portalArrowIcon}}}',
    position: mode.thumbOffset,
    size: mode.thumbSize,
  });

  // Pre load the thumb
  thumb.load();

  function onComplete() {
   game.addObject(thumb);
  }

  game.load();

})();
`;
