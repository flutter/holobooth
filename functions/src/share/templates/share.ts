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
    <meta property="og:image" content="{{{shareImageUrl}}}">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.desc}}">
    <meta name="twitter:image" content="{{{shareImageUrl}}}">
    <meta name="twitter:site" content="@flutterdev">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    
    <style>{{{styles}}}</style>
  </head>
  <body>
    <div class="backdrop"></div>
    <main>
      <div class="share-video">
        <div class="video-frame">
          <video src="{{{shareVideoUrl}}}">
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
        <a class="btn elevated-btn try-now-btn" href="/">
          <img src={{assetUrls.playArrowIcon}} />
          Try now
        </a>
        <a class="btn outline-btn" href="/">
          <img src={{assetUrls.shareIcon}} />
          Share
        </a>
        <p class="disclaimer">
        Your photo will be available at that URL for 30 days and then automatically deleted. To request early deletion of your photo, please contact flutter-photo-booth@google.com and be sure to include your unique URL in your request.
        </p>
      </div>
      </div>
    </main>
    {{{footer}}}
  </body>
</html>
`;
