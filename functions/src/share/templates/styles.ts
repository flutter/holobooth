export default `
html, body {
  margin: 0;
  padding: 0;
  height: 100vh;
}

body {
  font-family: "Google Sans", sans-serif;
  font-size: 12px;
  background-color: #ddd;
  display: flex;
  flex-direction: column;
  position: relative;
}

*, ::before, ::after {
  box-sizing: border-box;
}

.backdrop {
  position: fixed;
  left: 0;
  top: 0;
  z-index: -1;
  height: 100%;
  width: 100%;
  background-image: url("{{{assetUrls.bg}}}");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}

main {
  display: flex;
  flex: 1;
  flex-direction: row;
}

.share-video {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.info {
  flex: 1;
  display: flex;
  align-items: center;
}

.info-content {
  width: 524px;
  display: inline-block;
}

.flutter-forward-logo {
  margin-top: 104px;
  width: 330.13px;
  height: 48px;
}

h1 {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 64px;
  line-height: 80px;
  background: linear-gradient(90deg, #F8BBD0 0%, #9E81EF 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-fill-color: transparent;
}

h2 {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 400;
  font-size: 18px;
  line-height: 24px;
  color: #FFFFFF;
}

.btn {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 500;
  font-size: 18px;
  line-height: 28px;
  text-align: center;
  color: #FFFFFF;
  padding: 12px 40px 12px 20px;
  width: 167px;
  height: 52px;
  text-decoration: none;
  border-radius: 50px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.btn img {
  width: 24px;
  height: 24px;
  margin-right: 16px;
}

.elevated-btn {
  background: linear-gradient(91.87deg, #4100E0 0.1%, #F8BBD0 120.1%);
}

.try-now-btn {
  margin-right: 24px;
}

.outline-btn {
  border: 1px solid #676AB6;
}

.disclaimer {
  margin-top: 48px;
  font-family: 'Google Sans';
  font-style: italic;
  font-weight: 400;
  font-size: 12px;
  line-height: 20px;
  color: #C0C0C0;
}

.holocard {
  width: 708px;
  height: 716px;
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translate(-50%, 0);
}

footer {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  height: 80px;
  padding-right: 16px;
  padding-bottom: 16px;
  background-image: url({{{assetUrls.bgFooter}}});
}

footer ul {
  display: inline;
}

footer ul li {
  list-style: none;
  display: inline;
}

footer ul li img.flutter-icon {
  width: 19px;
  height: 22px;
}

footer ul li img.firebase-icon {
  width: 24px;
  height: 24px;
}

footer ul li img.tensorflow-icon {
  width: 22px;
  height: 24px;
}

footer ul li img.mediapipe-icon {
  width: 24px;
  height: 24px;
}

footer .left a {
  margin-right: 16px;
}

footer .right a {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 400;
  font-size: 14px;
  color: #FFFFFF;
  line-height: 20px;
  text-align: center;
  margin-right: 24px;
  text-decoration: none;
}

.video-pop-up-backdrop {
  position: fixed;
  left: 0;
  top: 0;
  height: 100%;
  width: 100%;
  background: rgba(28, 32, 64, 0.8);
  backdrop-filter: blur(8px);
  display: none;
}

.video-pop-up {
  position: fixed;
  left: 50%;
  top: 50%;
  width: 80%;
  transform: translate(-50%, -50%);
  display: none;
  background: rgba(2, 3, 32, 0.95);
  backdrop-filter: blur(7.5px);
  border-radius: 38px;
  border: 1px solid #9E81EF;
  flex-direction: column;
  align-items: center;
  padding: 16px;
}

.video-pop-up.fullscreen {
  width: 100%;
  height: 100%;
  border: none;
  border-radius: 0;
}

.video-pop-up-screen {
  position: relative;
  flex: 1;
  align-items: center;
  display: flex;
}

.video-pop-up-screen video {
  border-radius: 10px;
  width: 100%;
}

.video-pop-up .close-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 54px;
  height: 54px;
  border-radius: 27.5px;
  background: rgba(4, 5, 34, 0.56);
  top: 8px;
  position: absolute;
  right: 8px;
}

.video-pop-up .close-button img {
  width: 34px;
  height: 34px;
}

.video-pop-up .video-progress-bar {
  background: #1E1E1E;
  border-radius: 10px;
  height: 8px;
  width: 100%;
  margin-top: 12px;
}

.video-pop-up .video-progress-bar > div {
  background: #27F5DD;
  border-radius: 10px;
  height: 8px;
  width: 0%;
}

.video-pop-up .player-btn {
  text-decoration: none;
}

.video-pop-up-controls {
  padding: 12px 0px;
  display: flex;
  justify-content: space-between;
  width: 100%;
  align-items: center;
}

.video-pop-up-controls > div {
  display: flex;
  align-items: center;
}

.video-pop-up .play-button,.video-pop-up .pause-button {
  margin-right: 16px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.video-pop-up .play-button img {
  width: 18px;
  height: 22px;
}

.video-pop-up .pause-button img {
  width: 32px;
  height: 32px;
}

.video-pop-up .pause-button {
  display: none;
}

.video-pop-up .time-counter {
  font-family: 'Google Sans';
  font-style: normal;
  font-weight: 500;
  font-size: 16px;
  line-height: 20px;
  color: #FFFFFF;
}

.right-side-controls .flutter-icon {
  width: 18px;
  height: 20px;
  margin-right: 6px;
}

.right-side-controls .firebase-icon {
  width: 22px;
  height: 22px;
  margin-right: 6px;
}

.right-side-controls .tensorflow-icon {
  width: 20px;
  height: 22px;
  margin-right: 6px;
}

.right-side-controls .mediapipe-icon {
  width: 20px;
  height: 20px;
  margin-right: 18px;
}

.right-side-controls .fullscreen-button img {
  width: 30px;
  height: 30px;
}

.not-found-backdrop {
  z-index: -1;
  position: fixed;
  top: 0px;
  left: 0px;
  right: 0px;
  bottom: 0px;
  background-image: url("{{{assetUrls.bg}}}");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}

.not-found-panel {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.not-found-panel h1 {
  font-size: 54px;
  line-height: 64px;
  margin-bottom: 24px;
}

.not-found-panel h2 {
  margin-top: 0px;
  margin-bottom: 40px;
}

.relaunch-btn {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  padding: 10px 48px;
  gap: 8px;

  width: 286px;
  height: 48px;
}

@media (max-width: 860px) {
  body {
    display: block;
  }

  body.not-found-page {
    display: flex;
  }

  .not-found-backdrop {
    background-image: url("{{{assetUrls.notFoundMobileBg}}}");
  }

  .not-found-panel {
    padding: 24px 0;
  }

  .not-found-panel h1 {
    font-size: 34px;
    line-height: 44px;
    text-align: center;
  }

  .not-found-panel h2 {
    font-size: 16px;
    line-height: 24px;
    text-align: center;
  }

  main {
    display: block;
  }

  .share-video {
    margin-top: 32px;
    height: 464px;
  }

  .holocard {
    width: 608px;
    height: 616px;
  }

  .info {
    padding: 0px 24px;
  }

  .info .info-content {
    width: auto;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .info .flutter-forward-logo {
    margin-top: 0px;
  }

  .info h1 {
    font-size: 34px;
    line-height: 44px;
    text-align: center;
  }

  .info h2 {
    font-size: 16px;
    text-align: center;
    margin-bottom: 40px;
  }

  .try-now-btn {
    margin-right: 0px;
    margin-bottom: 24px;
  }

  .disclaimer {
    margin-bottom: 86px;
  }

  footer {
    justify-content: center;
  }

  footer .right {
    display: none;
  }
}
`;
