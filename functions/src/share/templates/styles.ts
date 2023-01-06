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
  background-image: url("{{{assetUrls.bgMobile}}}");
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
  position: relative;
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

.card-frame {
  width: 368px;
  height: 467px;
  position: absolute;
  bottom: 206px;
  left: 50%;
  transform: translate(-50%, 0);
  cursor: pointer;
}

.card-frame img {
  width: 100%;
  position: absolute;
}

.card-frame .video-clip {
  height: 318px;
  width: 286px;
  top: 48px;
  left: 50%;
  position: absolute;
  transform: translate(-50%, 0);
  clip-path: inset(0);
}

.card-frame .video-clip video {
  height: 318px;
  position: absolute;
  left: 50%;
  transform: translate(-50%, 0);
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
  padding-right: 16px;
  padding-bottom: 16px;
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

.video-pop-up {
  position: fixed;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  display: none;
  background: rgba(2, 3, 32, 0.95);
  backdrop-filter: blur(7.5px);
  border-radius: 38px;
  border: 1px solid #9E81EF;
  flex-direction: column;
  align-items: center;
}

.video-pop-up video {
  margin: 24px;
}

.video-pop-up .play-button {
  margin-bottom: 16px;
}

.video-pop-up .close-button {
  margin-bottom: 24px;
}

.not-found-backdrop {
  z-index: -1;
  position: fixed;
  top: 0px;
  left: 0px;
  right: 0px;
  bottom: 0px;
  background-image: url("{{{assetUrls.notFoundBg}}}");
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

  .card-frame {
    width: 218px;
    height: 217px;
    position: absolute;
    bottom: 256px;
  }
  
  .card-frame .video-clip {
    height: 218px;
    width: 186px;
    top: 14px;
  }
  
  .card-frame .video-clip video {
    height: 318px;
    position: absolute;
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
