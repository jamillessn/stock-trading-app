document.addEventListener('DOMContentLoaded', () => {
  const showToast = (message, type) => {
    const toast = document.createElement('div');
    toast.classList.add('toast', 'fixed', 'top-0', 'left-50%', 'translate-x--50%', 'z-999', 'text-white', 'rounded', 'shadow-lg', 'flex', 'items-center', 'justify-center', 'p-4');
    if (type === 'error') {
      toast.classList.add('bg-red-600');
    } else if (type === 'success') {
      toast.classList.add('bg-green-600');
    }

    toast.innerHTML = `<span>${message}</span><div class="loader"></div>`;
    toast.style.top = '-100px'; // Start off-screen
    // Adjusted animation timings for total 4-second duration
    toast.style.animation = 'slide-in 0.5s forwards, stay-visible 2.5s, fade-out 1s 3s';

    toast.addEventListener('animationend', (event) => {
      if (event.animationName === 'fade-out') {
        toast.remove();
      }
    });
    
    document.body.appendChild(toast);
  };

  const noticeElement = document.querySelector('.notice');
  const alertElement = document.querySelector('.alert');
  if (noticeElement && noticeElement.textContent.trim() !== '') {
    showToast(noticeElement.textContent, 'success');
  }
  if (alertElement && alertElement.textContent.trim() !== '') {
    showToast(alertElement.textContent, 'error');
  }
});
