// Notifications manager for ExpenseTracker
document.addEventListener('DOMContentLoaded', function() {
  // Load notifications from localStorage
  const loadStoredNotifications = function() {
    const notificationContainer = document.getElementById('notification-container');
    if (!notificationContainer) return;
    
    // Get stored notifications
    const storedNotifications = JSON.parse(localStorage.getItem('expenseTrackerNotifications') || '[]');
    
    // If we have current flash messages, don't display stored notifications
    const currentNotice = document.querySelector('.notice');
    const currentAlert = document.querySelector('.alert');
    const hasCurrentNotifications = 
      (currentNotice && currentNotice.textContent.trim()) || 
      (currentAlert && currentAlert.textContent.trim());
    
    // If no stored notifications and no current ones, show "no notifications" message
    if (storedNotifications.length === 0 && !hasCurrentNotifications) {
      return;
    }
    
    // If we don't have current notifications but have stored ones, display them
    if (!hasCurrentNotifications && storedNotifications.length > 0) {
      // Clear existing content if there are no active notifications
      const emptyStateElement = notificationContainer.querySelector('.text-center');
      if (emptyStateElement) {
        notificationContainer.innerHTML = '';
      }
      
      // Add stored notifications
      storedNotifications.forEach(function(notification) {
        const date = new Date(notification.timestamp);
        const timeAgo = getTimeAgo(date);
        
        const iconColor = notification.type === 'success' ? 'text-green-500' : 'text-red-500';
        const iconPath = notification.type === 'success' 
          ? '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />'
          : '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />';
        
        const notificationHTML = `
          <div class="notification-item px-4 py-3 hover:bg-gray-700 rounded-md">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <svg class="h-6 w-6 ${iconColor}" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  ${iconPath}
                </svg>
              </div>
              <div class="ml-3">
                <p class="text-sm text-gray-200">${notification.message}</p>
                <p class="text-xs text-gray-400 mt-1">${timeAgo}</p>
              </div>
            </div>
          </div>
        `;
        
        // Add to the notification container
        notificationContainer.innerHTML += notificationHTML;
      });
      
      // Add indicator to notification bell if we have notifications
      const notificationButton = document.getElementById('notification-button');
      if (notificationButton && !notificationButton.querySelector('.notification-indicator')) {
        const indicator = document.createElement('span');
        indicator.className = 'absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-500 notification-indicator';
        notificationButton.appendChild(indicator);
      }
    }
  };
  
  // Helper function to format time ago
  const getTimeAgo = function(date) {
    const now = new Date();
    const seconds = Math.floor((now - date) / 1000);
    
    if (seconds < 60) return 'Just now';
    
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) return `${minutes} minute${minutes !== 1 ? 's' : ''} ago`;
    
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours} hour${hours !== 1 ? 's' : ''} ago`;
    
    const days = Math.floor(hours / 24);
    if (days < 7) return `${days} day${days !== 1 ? 's' : ''} ago`;
    
    return date.toLocaleDateString();
  };
  
  // Handle the "Clear all notifications" button
  const setupClearButton = function() {
    const clearButton = document.querySelector('#notification-dropdown a');
    if (clearButton) {
      clearButton.addEventListener('click', function(e) {
        e.preventDefault();
        
        // Clear localStorage
        localStorage.removeItem('expenseTrackerNotifications');
        
        // Clear the notification container
        const notificationContainer = document.getElementById('notification-container');
        if (notificationContainer) {
          notificationContainer.innerHTML = `
            <div class="text-center py-6 text-gray-400 text-sm">
              No new notifications
            </div>
          `;
        }
        
        // Remove the indicator
        const indicator = document.querySelector('.notification-indicator');
        if (indicator) {
          indicator.remove();
        }
        
        // Close the dropdown
        const dropdown = document.getElementById('notification-dropdown');
        if (dropdown) {
          dropdown.classList.add('hidden');
        }
      });
    }
  };
  
  // Initialize
  loadStoredNotifications();
  setupClearButton();
}); 