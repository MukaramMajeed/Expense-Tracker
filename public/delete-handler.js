// Simple delete handler for transaction delete buttons
document.addEventListener('DOMContentLoaded', function() {
  // Find all delete buttons/forms with a data-confirm attribute
  document.addEventListener('click', function(event) {
    var target = event.target;
    
    // If clicked on an SVG or path within a delete button, find the button
    if (target.tagName === 'svg' || target.tagName === 'path') {
      target = target.closest('button');
    }
    
    // If it's not a button or doesn't have data-confirm, ignore
    if (!target || target.tagName !== 'BUTTON' || !target.hasAttribute('data-confirm')) {
      return;
    }
    
    // Check if it's a delete button (based on class or parent form)
    var isDeleteBtn = false;
    if (target.classList.contains('delete-btn') || 
        target.classList.contains('text-red-500') || 
        (target.form && target.form.method === 'post' && target.form.className.includes('delete-form'))) {
      isDeleteBtn = true;
    }
    
    if (!isDeleteBtn) return;
    
    // Show confirmation and prevent submission if user cancels
    var message = target.getAttribute('data-confirm');
    if (message && !confirm(message)) {
      event.preventDefault();
      event.stopPropagation();
    }
  });
}); 