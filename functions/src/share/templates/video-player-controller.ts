export default `
(function() {
  const frame = document.querySelector('.card-frame');
  const playButton = document.querySelector('.play-button');
  const pauseButton = document.querySelector('.pause-button');
  const closeButton = document.querySelector('.close-button');
  const videoPopUp = document.querySelector('.video-pop-up');
  const backdrop = document.querySelector('.video-pop-up-backdrop');
  const videoPlayer = document.querySelector('.video-pop-up video');
  const timeCounter = document.querySelector('.time-counter');
  const progressBar = document.querySelector('.video-progress-bar > div');
  const fullscreenButton = document.querySelector('.fullscreen-button');

  frame.addEventListener('click', function() {
    backdrop.style.display = 'block';
    videoPopUp.classList.remove('fullscreen');
    videoPopUp.style.display = 'flex';
    videoPlayer.play();
  });

  playButton.addEventListener('click', function() {
    videoPlayer.play();
  });

  pauseButton.addEventListener('click', function() {
    videoPlayer.pause();
  });

  closeButton.addEventListener('click', function() {
    backdrop.style.display = 'none';
    videoPopUp.style.display = 'none';
  });

  videoPlayer.addEventListener('loadeddata', function() {
    timeCounter.innerText = ['0:00 / 0:0', videoPlayer.duration].join('');
  });

  videoPlayer.addEventListener('timeupdate', function(event) {
    timeCounter.innerText = [
      '0:0',
      Math.round(videoPlayer.currentTime),
      ' / 0:0',
      videoPlayer.duration,
    ].join('');

    const progress = videoPlayer.currentTime / videoPlayer.duration * 100;
    progressBar.style.width = progress + '%';
  });

  videoPlayer.addEventListener('play', function(event) {
    playButton.style.display = 'none';
    pauseButton.style.display = 'flex';
  });

  videoPlayer.addEventListener('pause', function(event) {
    playButton.style.display = 'flex';
    pauseButton.style.display = 'none';
  });

  fullscreenButton.addEventListener('click', function() {
    videoPopUp.classList.toggle('fullscreen');
  });
})();
`;
