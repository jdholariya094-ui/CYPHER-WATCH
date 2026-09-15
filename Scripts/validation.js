/* ============================================================
   CYPHER — validation.js
   ============================================================ */
(function () {
  'use strict';

  // ── Helpers ────────────────────────────────────────────────
  function isEmail(v)  { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v); }
  function isPhone(v)  { return /^[6-9]\d{9}$/.test(v.replace(/\s/g,'')); }
  function isStrong(v) { return v.length >= 8 && /[A-Z]/.test(v) && /[0-9]/.test(v); }

  function setError(input, msg) {
    var fb = input.closest('.mb-3, .form-group').querySelector('.invalid-feedback')
          || document.createElement('div');
    fb.className = 'invalid-feedback d-block';
    fb.textContent = msg;
    input.classList.add('is-invalid');
    if (!input.closest('.mb-3, .form-group').querySelector('.invalid-feedback'))
      input.parentNode.appendChild(fb);
  }

  function clearError(input) {
    var wrap = input.closest('.mb-3, .form-group');
    if (!wrap) return;
    input.classList.remove('is-invalid');
    input.classList.add('is-valid');
    var fb = wrap.querySelector('.invalid-feedback');
    if (fb) fb.remove();
  }

  function validateField(input) {
    var val  = input.value.trim();
    var type = input.getAttribute('data-validate');
    if (!type) return true;

    if (type === 'required' && !val)       { setError(input,'This field is required.'); return false; }
    if (type === 'email' && !isEmail(val)) { setError(input,'Enter a valid email address.'); return false; }
    if (type === 'phone' && !isPhone(val)) { setError(input,'Enter a valid 10-digit mobile number.'); return false; }
    if (type === 'password' && !isStrong(val)) {
      setError(input,'Password must be 8+ chars with uppercase and a number.'); return false;
    }
    if (type === 'confirm') {
      var orig = document.querySelector('[data-validate="password"]');
      if (orig && val !== orig.value) { setError(input,'Passwords do not match.'); return false; }
    }
    if (type === 'minlen') {
      var min = parseInt(input.getAttribute('data-min') || '3', 10);
      if (val.length < min) { setError(input,'Minimum ' + min + ' characters required.'); return false; }
    }

    clearError(input);
    return true;
  }

  // ── Live Validation ─────────────────────────────────────────
  document.addEventListener('blur', function (e) {
    if (e.target.getAttribute('data-validate')) validateField(e.target);
  }, true);

  // ── Form Submit Validation ──────────────────────────────────
  document.addEventListener('submit', function (e) {
    var form = e.target;
    if (!form.hasAttribute('data-cypher-validate')) return;

    var inputs  = form.querySelectorAll('[data-validate]');
    var isValid = true;

    inputs.forEach(function (inp) {
      if (!validateField(inp)) isValid = false;
    });

    if (!isValid) {
      e.preventDefault();
      var firstErr = form.querySelector('.is-invalid');
      if (firstErr) firstErr.scrollIntoView({ behavior: 'smooth', block: 'center' });
      if (window.showToast) showToast('Please fix the errors below.', 'fa-exclamation-circle');
    }
  });

  // ── Password Strength Meter ─────────────────────────────────
  var pwdInput = document.querySelector('[data-validate="password"]');
  var meter    = document.getElementById('passwordStrengthBar');

  if (pwdInput && meter) {
    pwdInput.addEventListener('input', function () {
      var v = pwdInput.value;
      var strength = 0;
      if (v.length >= 8)          strength++;
      if (/[A-Z]/.test(v))        strength++;
      if (/[0-9]/.test(v))        strength++;
      if (/[^A-Za-z0-9]/.test(v)) strength++;

      var pct   = (strength / 4) * 100;
      var color = strength <= 1 ? '#e74c3c' : strength === 2 ? '#f1c40f' : strength === 3 ? '#3498db' : '#2ecc71';
      meter.style.width      = pct + '%';
      meter.style.background = color;
    });
  }

  // ── Card Number Formatting (Checkout) ──────────────────────
  var cardInput = document.getElementById('cardNumber');
  if (cardInput) {
    cardInput.addEventListener('input', function () {
      var v = cardInput.value.replace(/\D/g,'').substring(0,16);
      cardInput.value = v.replace(/(.{4})/g,'$1 ').trim();
    });
  }

  // ── Expiry Formatting ───────────────────────────────────────
  var expiryInput = document.getElementById('cardExpiry');
  if (expiryInput) {
    expiryInput.addEventListener('input', function () {
      var v = expiryInput.value.replace(/\D/g,'').substring(0,4);
      if (v.length > 2) v = v.substring(0,2) + '/' + v.substring(2);
      expiryInput.value = v;
    });
  }

})();
