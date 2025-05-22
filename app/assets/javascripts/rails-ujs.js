/*
 * This is a simplified version of rails-ujs functionality for handling DELETE requests
 * If the main JavaScript setup doesn't work, this will provide basic DELETE functionality
 */

document.addEventListener('DOMContentLoaded', function() {
  // Handle data-method links (for delete buttons)
  document.addEventListener('click', function(event) {
    var element = event.target;
    
    // Find the closest link if we clicked on a child element (like an icon)
    if (!element.tagName || element.tagName.toLowerCase() !== 'a') {
      element = element.closest('a');
    }
    
    if (!element) return;
    
    // Check if this is a DELETE link
    var method = element.getAttribute('data-turbo-method') || element.getAttribute('data-method');
    
    if (method === 'delete') {
      event.preventDefault();
      
      // Get confirmation if needed
      var message = element.getAttribute('data-turbo-confirm') || element.getAttribute('data-confirm');
      if (message && !window.confirm(message)) {
        return;
      }
      
      // Create and submit a form to handle the DELETE request
      var form = document.createElement('form');
      form.method = 'POST';
      form.action = element.href;
      form.style.display = 'none';
      
      // Add CSRF token
      var csrfToken = document.querySelector('meta[name=csrf-token]');
      if (csrfToken) {
        var csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'authenticity_token';
        csrfInput.value = csrfToken.content;
        form.appendChild(csrfInput);
      }
      
      // Add _method input to tell Rails this is a DELETE
      var methodInput = document.createElement('input');
      methodInput.type = 'hidden';
      methodInput.name = '_method';
      methodInput.value = 'delete';
      form.appendChild(methodInput);
      
      // Submit the form
      document.body.appendChild(form);
      form.submit();
    }
  });
}); 