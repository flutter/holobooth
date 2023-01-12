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
    <meta property="og:image" content="{{{assetUrls.notFoundPhoto}}}">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.desc}}">
    <meta name="twitter:image" content="{{{assetUrls.notFoundPhoto}}}">
    <meta name="twitter:site" content="@flutterdev">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    
    <style>{{{styles}}}</style>
  </head>
  <body class="not-found-page">
    <div class="not-found-backdrop"></div>
    <main class="not-found-panel">
      <h1>This page can’t be found</h1>
      <h2>Try going back or relaunch the app.</h2>
      <a class="btn elevated-btn relaunch-btn" href="/">Relaunch HoloBooth</a>
    </main>
    {{{footer}}}
  </body>
</html>
`;
