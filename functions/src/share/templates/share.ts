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
    <meta property="og:image" content="{{{thumbImageUrl}}}">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.desc}}">
    <meta name="twitter:image" content="{{{thumbImageUrl}}}">
    <meta name="twitter:site" content="@flutterdev">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">

    <style>{{{styles}}}</style>
  </head>
  <body>
    <div class="backdrop"></div>
    <main>
      <div class="share-video">
        <img class="holocard" src={{assetUrls.holocard}} />
        <div class="card-frame">
          <div class="video-clip">
            <video src="{{{shareVideoUrl}}}"></video>
          </div>
          <img src={{assetUrls.videoFrame}} />
        </div>
      </div>
      <div class="info">
        <div class="info-content">
          <img class="flutter-forward-logo" src={{assetUrls.flutterForwardLogo}} />
          <h1>Check it out my Flutter holocard!</h1>
          <h2>
            This video has been created with Flutter web app.
            Create your unique video in a few steps:
          </h2>
          <a class="btn elevated-btn try-now-btn" href="http://holobooth.flutter.dev/">
            <img src={{assetUrls.playArrowIcon}} />
            Try now
          </a>
          <p class="disclaimer">
          Your photo will be available at that URL for 30 days and then automatically deleted.
          To request early deletion of your photo, please contact flutter-photo-booth@google.com and
          be sure to include your unique URL in your request.
          </p>
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
          <a href="https://www.tensorflow.org/" class="player-btn">
            <img class="tensorflow-icon" src={{assetUrls.tensorflowIcon}} />
          </a>
          <a href="#" class="player-btn fullscreen-button">
            <img class="tensorflow-icon" src={{assetUrls.playerFullscreen}} />
          </a>
        </div>
      </div>
    </div>
  </body>
  <script type="text/javascript">
  {{{scripts}}}
  </script>
</html>
`;
