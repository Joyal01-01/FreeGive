/**
 * FreeGive - Main Application JavaScript
 * Client-side functionality for the application
 */

document.addEventListener("DOMContentLoaded", function () {
  initializeApp();
});

/**
 * Initialize the application
 */
function initializeApp() {
  setupNavigation();
  setupForms();
  setupSearch();
  setupInteractive();
  setupAccessibility();
}

/**
 * Navigation Setup
 */
function setupNavigation() {
  const navToggle = document.getElementById("nav-toggle");
  const navLinks = document.querySelector(".nav-links");

  if (navToggle && navLinks) {
    navToggle.addEventListener("change", function () {
      if (!this.checked) {
        document.querySelectorAll(".nav-links a").forEach((link) => {
          link.addEventListener("click", function () {
            navToggle.checked = false;
          });
        });
      }
    });

    // Close menu on window resize if open
    window.addEventListener("resize", function () {
      if (window.innerWidth > 768 && navToggle.checked) {
        navToggle.checked = false;
      }
    });
  }

  // Active link highlighting
  highlightActiveNavLink();
}

/**
 * Highlight the active navigation link based on current URL
 */
function highlightActiveNavLink() {
  const currentPath = window.location.pathname;
  const navLinks = document.querySelectorAll(".nav-links a");

  navLinks.forEach((link) => {
    const href = link.getAttribute("href");
    if (href && currentPath.includes(href)) {
      link.classList.add("active");
    }
  });
}

/**
 * Form Setup and Validation
 */
function setupForms() {
  setupFileInput();
  setupTagInput();
  setupFormValidation();
}

/**
 * Setup custom file input display
 */
function setupFileInput() {
  const fileInputs = document.querySelectorAll(".file-input");

  fileInputs.forEach((fileInput) => {
    fileInput.addEventListener("change", function () {
      const file = this.files[0];
      const preview = document.getElementById("photoPreview");

      if (file && preview) {
        const reader = new FileReader();
        reader.onload = function (e) {
          preview.innerHTML = `<img src="${e.target.result}" alt="Preview">`;
        };
        reader.readAsDataURL(file);
      }
    });
  });
}

/**
 * Setup tag input with live preview
 */
function setupTagInput() {
  const tagInput = document.getElementById("tags");
  const tagPreview = document.getElementById("tagPreview");

  if (tagInput && tagPreview) {
    tagInput.addEventListener("input", function () {
      const tags = this.value
        .split(",")
        .map((tag) => tag.trim())
        .filter((tag) => tag);
      tagPreview.innerHTML = "";

      if (tags.length > 0) {
        const tagElements = tags
          .map((tag) => `<span class="tag">${escapeHtml(tag)}</span>`)
          .join("");
        tagPreview.innerHTML = tagElements;
      }
    });

    // Trigger on load if there are existing tags
    tagInput.dispatchEvent(new Event("input"));
  }
}

/**
 * Setup basic form validation
 */
function setupFormValidation() {
  const forms = document.querySelectorAll("form");

  forms.forEach((form) => {
    form.addEventListener("submit", function (e) {
      if (!this.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
        this.classList.add("invalid");
      } else {
        this.classList.remove("invalid");
      }
    });
  });
}

/**
 * Search and Filter Setup
 */
function setupSearch() {
  setupLiveFilter();
  setupSearchForm();
}

/**
 * Setup live filtering of table results
 */
function setupLiveFilter() {
  const filterInput = document.getElementById("liveFilter");
  const table = document.getElementById("resultsTable");

  if (filterInput && table) {
    filterInput.addEventListener("keyup", function () {
      const filter = this.value.toLowerCase();
      const rows = table.querySelectorAll("tbody tr");

      rows.forEach((row) => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? "" : "none";
      });
    });
  }
}

/**
 * Setup search form handling
 */
function setupSearchForm() {
  const searchForm = document.getElementById("searchForm");

  if (searchForm) {
    // Clear button functionality
    const clearButtons = document.querySelectorAll('a[href$="/search"]');
    clearButtons.forEach((btn) => {
      if (btn.textContent.includes("Clear")) {
        btn.addEventListener("click", function (e) {
          e.preventDefault();
          window.location.href = this.href;
        });
      }
    });
  }
}

/**
 * Interactive Elements Setup
 */
function setupInteractive() {
  setupItemCards();
  setupAlerts();
  setupModals();
  setupConfirmations();
}

/**
 * Setup item card hover effects
 */
function setupItemCards() {
  const itemCards = document.querySelectorAll(".item-card");

  itemCards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-4px)";
    });

    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0)";
    });
  });
}

/**
 * Setup alert dismissal
 */
function setupAlerts() {
  const alerts = document.querySelectorAll(".alert");

  alerts.forEach((alert) => {
    // Auto-dismiss success alerts after 5 seconds
    if (alert.classList.contains("alert-success")) {
      setTimeout(() => {
        fadeOut(alert);
      }, 5000);
    }

    // Add close button functionality
    const closeBtn = document.createElement("button");
    closeBtn.type = "button";
    closeBtn.className = "alert-close";
    closeBtn.innerHTML = "×";
    closeBtn.setAttribute("aria-label", "Close alert");

    closeBtn.addEventListener("click", function () {
      fadeOut(alert);
    });

    alert.appendChild(closeBtn);
  });
}

/**
 * Fade out and remove element
 */
function fadeOut(element) {
  element.style.opacity = "0";
  element.style.transition = "opacity 0.3s ease";
  setTimeout(() => {
    element.remove();
  }, 300);
}

/**
 * Setup modal functionality
 */
function setupModals() {
  // Add modal functionality here if needed
}

/**
 * Setup confirmation dialogs
 */
function setupConfirmations() {
  const deleteButtons = document.querySelectorAll(
    'button[type="submit"][onclick*="confirm"]',
  );

  deleteButtons.forEach((button) => {
    button.addEventListener("click", function (e) {
      const message =
        this.getAttribute("onclick").match(/confirm\('([^']+)'\)/);
      if (message && !confirm(message[1])) {
        e.preventDefault();
      }
    });
  });
}

/**
 * Accessibility Setup
 */
function setupAccessibility() {
  // Add skip to main content link
//   addSkipLink();

  // Improve focus management
  setupKeyboardNavigation();

  // Add ARIA labels where needed
  addAriaLabels();
}

/**
 * Add skip to main content link
 */
function addSkipLink() {
  if (!document.querySelector(".skip-link")) {
    const skipLink = document.createElement("a");
    skipLink.href = "#main";
    skipLink.className = "skip-link";
    skipLink.textContent = "Skip to main content";
    document.body.insertBefore(skipLink, document.body.firstChild);
  }
}

/**
 * Setup keyboard navigation
 */
function setupKeyboardNavigation() {
  document.addEventListener("keydown", function (e) {
    // Escape key to close modals/menus
    if (e.key === "Escape") {
      const navToggle = document.getElementById("nav-toggle");
      if (navToggle && navToggle.checked) {
        navToggle.checked = false;
      }
    }
  });
}

/**
 * Add ARIA labels to interactive elements
 */
function addAriaLabels() {
  const buttons = document.querySelectorAll("button[title]");
  buttons.forEach((button) => {
    if (!button.getAttribute("aria-label")) {
      button.setAttribute("aria-label", button.getAttribute("title"));
    }
  });

  const links = document.querySelectorAll("a[title]");
  links.forEach((link) => {
    if (!link.getAttribute("aria-label")) {
      link.setAttribute("aria-label", link.getAttribute("title"));
    }
  });
}

/**
 * Utility Functions
 */

/**
 * Escape HTML special characters
 */
function escapeHtml(text) {
  const map = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#039;",
  };
  return text.replace(/[&<>"']/g, (m) => map[m]);
}

/**
 * Format date to readable string
 */
function formatDate(date) {
  const options = { year: "numeric", month: "short", day: "numeric" };
  return new Date(date).toLocaleDateString("en-US", options);
}

/**
 * Validate email format
 */
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Validate phone number format
 */
function isValidPhone(phone) {
  const phoneRegex = /^\d{10,}$/;
  return phoneRegex.test(phone.replace(/\D/g, ""));
}

/**
 * Validate zipcode format
 */
function isValidZipcode(zipcode) {
  const zipcodeRegex = /^\d{4,10}$/;
  return zipcodeRegex.test(zipcode);
}

/**
 * Show loading state
 */
function showLoading(element) {
  if (element) {
    element.disabled = true;
    element.style.opacity = "0.6";
    element.setAttribute("aria-busy", "true");
  }
}

/**
 * Hide loading state
 */
function hideLoading(element) {
  if (element) {
    element.disabled = false;
    element.style.opacity = "1";
    element.setAttribute("aria-busy", "false");
  }
}

/**
 * Create and display toast notification
 */
function showToast(message, type = "success") {
  const toast = document.createElement("div");
  toast.className = `toast toast-${type}`;
  toast.textContent = message;
  toast.role = "alert";
  toast.setAttribute("aria-live", "polite");

  document.body.appendChild(toast);

  setTimeout(() => fadeOut(toast), 4000);
}

/**
 * Debounce function for event handlers
 */
function debounce(func, delay) {
  let timeoutId;
  return function (...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func.apply(this, args), delay);
  };
}

/**
 * Throttle function for event handlers
 */
function throttle(func, limit) {
  let inThrottle;
  return function (...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
    }
  };
}

// Export utility functions for use in other modules
if (typeof module !== "undefined" && module.exports) {
  module.exports = {
    escapeHtml,
    formatDate,
    isValidEmail,
    isValidPhone,
    isValidZipcode,
    showLoading,
    hideLoading,
    showToast,
    debounce,
    throttle,
  };
}
