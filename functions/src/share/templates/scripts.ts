export default `
(function() {
  const frame = document.querySelector('.card-frame');
  const playButton = document.querySelector('.play-button');
  const closeButton = document.querySelector('.close-button');
  const videoPopUp = document.querySelector('.video-pop-up');
  const videoPlayer = document.querySelector('.video-pop-up video');
  const timeCounter = document.querySelector('.time-counter');
  const progressBar = document.querySelector('.video-progress-bar > div');

  frame.addEventListener('click', function() {
    videoPopUp.style.display = 'flex';
    videoPlayer.play();
  });

  playButton.addEventListener('click', function() {
    videoPlayer.play();
  });

  closeButton.addEventListener('click', function() {
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
})();
`;
