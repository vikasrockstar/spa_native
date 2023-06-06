const stars = document.querySelectorAll('.star');
const ratings = document.getElementById('payment_rating')

stars.forEach((star, index) => {
  star.addEventListener('click', () => {
    setRating(index + 1);
  });
});

function setRating(rating) {
  stars.forEach(star => star.classList.remove('active'));

  for (let i = 0; i < rating; i++) {
    stars[i].classList.add('active');
  }
  ratings.value = rating
}

function highlightStars(index) {
  for (let i = 0; i <= index; i++) {
    stars[i].classList.add('active');
  }
}

function resetStars() {
  stars.forEach(star => star.classList.remove('active'));
};
