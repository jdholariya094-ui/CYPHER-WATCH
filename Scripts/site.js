/* ============================================================
   CYPHER — site.js  (main JavaScript)
   ============================================================ */

(function () {
  'use strict';

  // ── Sticky Navbar ──────────────────────────────────────────
  var navbar = document.querySelector('.navbar-cypher');
  if (navbar) {
    window.addEventListener('scroll', function () {
      if (window.scrollY > 60) navbar.classList.add('scrolled');
      else navbar.classList.remove('scrolled');
    });
  }

  // ── Back To Top ────────────────────────────────────────────
  var backToTop = document.getElementById('backToTop');
  if (backToTop) {
    window.addEventListener('scroll', function () {
      if (window.scrollY > 400) backToTop.classList.add('show');
      else backToTop.classList.remove('show');
    });
    backToTop.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  // ── Scroll Reveal ──────────────────────────────────────────
  function initScrollReveal() {
    var elements = document.querySelectorAll('.reveal');
    if (!elements.length) return;

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });

    elements.forEach(function (el) { observer.observe(el); });
  }

  // ── Toast Notification ─────────────────────────────────────
  window.showToast = function (message, icon, duration) {
    icon = icon || 'fa-check-circle';
    duration = duration || 3000;

    var existing = document.querySelector('.toast-cypher');
    if (existing) existing.remove();

    var toast = document.createElement('div');
    toast.className = 'toast-cypher';
    toast.innerHTML = '<i class="fa ' + icon + ' toast-icon"></i>' + message;
    document.body.appendChild(toast);

    setTimeout(function () { toast.classList.add('show'); }, 20);
    setTimeout(function () {
      toast.classList.remove('show');
      setTimeout(function () { if (toast.parentNode) toast.remove(); }, 400);
    }, duration);
  };

  // ── Counter Animation ──────────────────────────────────────
  function animateCounters() {
    var counters = document.querySelectorAll('[data-count]');
    counters.forEach(function (el) {
      var target = parseInt(el.getAttribute('data-count'), 10);
      var duration = 1800;
      var start = 0;
      var step = target / (duration / 16);
      var timer = setInterval(function () {
        start += step;
        if (start >= target) { start = target; clearInterval(timer); }
        el.textContent = Math.floor(start).toLocaleString();
      }, 16);
    });
  }

  // Trigger counters when section comes into view
  var statsSection = document.querySelector('.stats-section');
  if (statsSection) {
    var counterTriggered = false;
    var statsObserver = new IntersectionObserver(function (entries) {
      if (entries[0].isIntersecting && !counterTriggered) {
        counterTriggered = true;
        animateCounters();
      }
    }, { threshold: 0.3 });
    statsObserver.observe(statsSection);
  }

  // ── Search Suggestions ─────────────────────────────────────
  var searchInput = document.getElementById('navSearchInput');
  var searchDropdown = document.getElementById('searchDropdown');

  if (searchInput && searchDropdown) {
    var searchTimer;
    searchInput.addEventListener('input', function () {
      clearTimeout(searchTimer);
      var term = searchInput.value.trim();
      if (term.length < 2) { searchDropdown.style.display = 'none'; return; }

      searchTimer = setTimeout(function () {
        // AJAX call to search handler
        fetch('~/Pages/Watches.aspx?q=' + encodeURIComponent(term) + '&ajax=1')
          .then(function (r) { return r.text(); })
          .catch(function () { /* ignore */ });
      }, 350);
    });

    document.addEventListener('click', function (e) {
      if (!searchInput.contains(e.target)) searchDropdown.style.display = 'none';
    });
  }

  // ── Wishlist Toggle (UI only, form posts handle DB) ────────
  document.addEventListener('click', function (e) {
    var btn = e.target.closest('.wishlist-toggle');
    if (!btn) return;
    btn.querySelector('i').classList.toggle('fa-heart');
    btn.querySelector('i').classList.toggle('fa-heart-o');
  });

  // ── Quick View Modal ───────────────────────────────────────
  document.addEventListener('click', function (e) {
    var btn = e.target.closest('.quick-view-btn');
    if (!btn) return;
    var pid = btn.getAttribute('data-pid');
    var modal = document.getElementById('quickViewModal');
    if (!modal || !pid) return;

    var frame = modal.querySelector('#quickViewContent');
    if (frame) {
      frame.innerHTML = '<div class="text-center py-5"><div class="spinner-gold mx-auto"></div></div>';
    }

    var bootstrapModal = bootstrap.Modal.getOrCreateInstance(modal);
    bootstrapModal.show();

    // Load product detail into modal via AJAX
    fetch('~/Pages/ProductDetail.aspx?id=' + pid + '&modal=1')
      .then(function (r) { return r.text(); })
      .then(function (html) { if (frame) frame.innerHTML = html; })
      .catch(function () { if (frame) frame.innerHTML = '<p class="text-center text-muted py-4">Could not load preview.</p>'; });
  });

  // ── Smooth Scroll for anchor links ─────────────────────────
  document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
    anchor.addEventListener('click', function (e) {
      var target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  // ── Newsletter Form ────────────────────────────────────────
  var newsletterForm = document.getElementById('newsletterForm');
  if (newsletterForm) {
    newsletterForm.addEventListener('submit', function (e) {
      e.preventDefault();
      var email = newsletterForm.querySelector('input[type=email]').value.trim();
      if (!email) return;
      // Handled via ASP.NET postback — this is for AJAX version
      showToast('Thank you for subscribing!', 'fa-envelope');
    });
  }

  // ── Image Zoom (product detail) ────────────────────────────
  window.switchMainImage = function (src, thumb) {
    var mainImg = document.getElementById('mainProductImage');
    if (mainImg) {
      mainImg.style.opacity = '0';
      setTimeout(function () { mainImg.src = src; mainImg.style.opacity = '1'; }, 200);
    }
    document.querySelectorAll('.thumb-img').forEach(function (t) { t.classList.remove('active'); });
    if (thumb) thumb.classList.add('active');
  };

  // ── Quantity Selector ──────────────────────────────────────
  document.addEventListener('click', function (e) {
    var btn = e.target.closest('.qty-btn');
    if (!btn) return;
    var input = btn.closest('.qty-selector').querySelector('.qty-input');
    var val = parseInt(input.value, 10) || 1;
    if (btn.classList.contains('qty-minus')) val = Math.max(1, val - 1);
    if (btn.classList.contains('qty-plus'))  val = Math.min(99, val + 1);
    input.value = val;
  });

  // ── Price Range Display ────────────────────────────────────
  var priceRange = document.getElementById('priceRange');
  var priceDisplay = document.getElementById('priceRangeVal');
  if (priceRange && priceDisplay) {
    priceRange.addEventListener('input', function () {
      priceDisplay.textContent = '₹' + parseInt(priceRange.value).toLocaleString();
    });
  }

  // ── Mobile Sidebar Toggle (Admin) ──────────────────────────
  var sidebarToggle = document.getElementById('sidebarToggle');
  var adminSidebar  = document.querySelector('.admin-sidebar');
  if (sidebarToggle && adminSidebar) {
    sidebarToggle.addEventListener('click', function () {
      adminSidebar.classList.toggle('open');
    });
  }

  // ── Init ───────────────────────────────────────────────────
  document.addEventListener('DOMContentLoaded', function () {
    initScrollReveal();
  });

  if (document.readyState !== 'loading') initScrollReveal();

})();
