export default `
(function() {
  const frame = document.querySelector('.card-frame');
  const playButton = document.querySelector('.play-button');
  const closeButton = document.querySelector('.close-button');
  const videoPopUp = document.querySelector('.video-pop-up');
  const videoPlayer = document.querySelector('.video-pop-up video');

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
})();
`;
