// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'tailwindcss/tailwind.css'

  document.querySelectorAll('input[type="number"]').forEach(input => {
    input.addEventListener('input', function () {
      let symbol = this.id.split('-')[1];
      let price = parseFloat(document.getElementById('stock-price-' + symbol).textContent);
      let quantity = parseInt(this.value) || 0;
      document.getElementById('total-' + symbol).textContent = (price * quantity).toFixed(2);
    });
  });
  
// Cash in modal 

document.addEventListener("DOMContentLoaded", function() {
  const cashInButton = document.querySelector(".cash-in-btn"); // Select the button

  if (cashInButton) {
    cashInButton.addEventListener("click", function() {
      const cashInModal = document.getElementById("cash-in-modal");
      cashInModal.classList.remove("hidden"); // Remove hidden class to show modal
    });
  }
});
  