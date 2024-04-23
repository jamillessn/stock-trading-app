// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'tailwindcss/tailwind.css'


document.addEventListener("DOMContentLoaded", function() {
  var toastContainer = document.getElementById("toast-container");
  var closeButtons = document.querySelector(".close-btn");

  function removeToastContainer() {
    toastContainer.remove();
  }

  closeButtons.addEventListener("click", removeToastContainer)

  setTimeout(removeToastContainer, 2500);
});
  