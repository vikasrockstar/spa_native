document.addEventListener("DOMContentLoaded", function () {
    const togglePassword = document.getElementById("togglePassword");
    const password = document.getElementById("password");
    const form = document.getElementById('form');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
  
    function containsOnlySpaces(str) {
        return str.trim() === '';
    }

    form.addEventListener('submit', function (event) {
        let isValid = true;
    
        if (containsOnlySpaces(emailInput.value)) {
          alert('Please enter valid email');
          isValid = false;
        }
    
        if (containsOnlySpaces(passwordInput.value)) {
          alert('please enter valid password');
          isValid = false;
        }
    
        if (!isValid) {
          event.preventDefault();
        }
      });
    
    
    togglePassword.addEventListener("click", function () {
        const type = password.getAttribute("type") === "password" ? "text" : "password";
        togglePassword.classList.toggle("fa-eye-slash", type === "password");
        togglePassword.classList.toggle("fa-eye", type === "text");
        password.setAttribute("type", type);
    });
})


function remember() {
    var email = document.getElementById("email").value;
    var password = document.getElementById("password").value;
    localStorage.setItem("user-email", email);
    localStorage.setItem("user-password", password);
}


