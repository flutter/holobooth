export default `
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/png" href="{{{assetUrls.favicon}}}">
    <meta name="viewport" content="width=device-width,initial-scale=1" />

    <title>{{meta.title}}</title>
    <meta name="descripton" content="{{meta.desc}}">

    {{{ga}}}

    <meta property="og:title" content="{{meta.title}}">
    <meta property="og:description" content="{{meta.desc}}">
    <meta property="og:url" content="{{{shareUrl}}}">
    <meta property="og:image" content="{{{assetUrls.metadataImage}}}">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.desc}}">
    <meta name="twitter:image" content="{{{assetUrls.metadataImage}}}">
    <meta name="twitter:site" content="@flutterdev">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">

    <style>{{{styles}}}</style>
  </head>
  <body>
    <div class="backdrop"></div>
    <main>
      <div class="share-video">
        <canvas id="portal-animation"></canvas>
        </div>
      </div>
      <div class="info">
        <div class="info-content">
          <img class="flutter-forward-logo" src={{assetUrls.flutterForwardLogo}} />
          <h1>Check out my Flutter holocard!</h1>
          <h2>
            This video has been created with Flutter on the web.
            Create your unique video:
          </h2>
          <a class="btn elevated-btn try-now-btn" href="https://holobooth.flutter.dev/" target="_blank">
            <img src={{assetUrls.playArrowIcon}} />
            Try now
          </a>
        </div>
      </div>
    </main>
    {{{footer}}}
    <div class="video-pop-up-backdrop">
    </div>
    <div class="video-pop-up">
      <div class="video-pop-up-screen">
        <video src="{{{shareVideoUrl}}}"></video>
        <a href="#" class="close-button">
          <img src={{assetUrls.close}} />
        </a>
      </div>
      <div class="video-progress-bar">
        <div></div>
      </div>
      <div class="video-pop-up-controls">
        <div class="left-side-controls">
          <a href="#" class="player-btn play-button">
            <img src={{assetUrls.playerPlay}} />
          </a>
          <a href="#" class="player-btn pause-button">
            <img src={{assetUrls.playerPause}} />
          </a>
          <span class="time-counter">
            0:02 / 0:05
          </span>
        </div>
        <div class="right-side-controls">
          <a href="https://flutter.dev/" class="player-btn">
            <img class="flutter-icon" src={{assetUrls.flutterIcon}} />
          </a>
          <a href="https://firebase.google.com/" class="player-btn">
            <img class="firebase-icon" src={{assetUrls.firebaseIcon}} />
          </a>
          <a href="https://www.tensorflow.org/js/" class="player-btn">
            <img class="tensorflow-icon" src={{assetUrls.tensorflowIcon}} />
          </a>
          <a href="https://developers.google.com/mediapipe" class="player-btn">
            <img class="mediapipe-icon" src={{assetUrls.mediapipeIcon}} />
          </a>
          <a href="#" class="player-btn fullscreen-button">
            <img class="tensorflow-icon" src={{assetUrls.playerFullscreen}} />
          </a>
        </div>
      </div>
    </div>
  </body>
  <script type="text/javascript">
  {{{videoPlayerController}}}
  {{{portalAnimationController}}}
  </script>
</html>
`;
