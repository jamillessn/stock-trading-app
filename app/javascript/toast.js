const showToast = (message, type) => {
    const toast = document.createElement('div');
    toast.classList.add('fixed', 'top-0', 'right-0', 'p-4', 'm-4', 'rounded', 'shadow-lg', 'bg-gray-800', 'text-white');
    toast.textContent = message;
    toast.style.animation = 'fade-in 0.5s, fade-out 0.5s 2s';
    toast.style.transition = 'opacity 0.5s';
    toast.addEventListener('animationend', () => {
      document.body.removeChild(toast);
    });
    document.body.appendChild(toast);
  };
  
  document.addEventListener('DOMContentLoaded', () => {
    const notice = document.querySelector('.notice');
    const alert = document.querySelector('.alert');
    if (notice) {
      showToast(notice.textContent, 'success');
    }
    if (alert) {
      showToast(alert.textContent, 'error');
    }
  });
  