// Get all star elements
const stars = document.querySelectorAll('.star');
console.log(stars);

// Add event listeners
stars.forEach((star, index) => {
  star.addEventListener('click', () => {
    // Set the rating based on the clicked star
    setRating(index + 1);
  });

  star.addEventListener('mouseover', () => {
    // Highlight stars up to the hovered star
    highlightStars(index);
  });

  // star.addEventListener('mouseout', () => {
  //   // Remove highlight from all stars
  //   resetStars();
  // });
});

// Functions to handle rating changes
function setRating(rating) {
  // Remove previous rating classes
  stars.forEach(star => star.classList.remove('active'));

  // Add active class to stars up to the selected rating
  for (let i = 0; i < rating; i++) {
    stars[i].classList.add('active');
  }

  // You can perform additional actions here, such as submitting the rating to a server
}

function highlightStars(index) {
  // Add highlight class to stars up to the hovered star
  for (let i = 0; i <= index; i++) {
    stars[i].classList.add('active');
  }
}

function resetStars() {
  // Remove highlight from all stars
  stars.forEach(star => star.classList.remove('active'));
};
