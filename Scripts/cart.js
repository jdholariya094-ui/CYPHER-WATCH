/* ============================================================
   CYPHER — cart.js
   ============================================================ */
(function () {
  'use strict';

  // ── Update Cart Badge ──────────────────────────────────────
  function updateCartBadge(count) {
    var badges = document.querySelectorAll('.cart-badge');
    badges.forEach(function (b) {
      b.textContent = count;
      b.style.display = count > 0 ? 'flex' : 'none';
    });
  }

  // ── Cart Quantity Change (Cart page) ───────────────────────
  document.addEventListener('change', function (e) {
    var input = e.target;
    if (!input.classList.contains('cart-qty-input')) return;

    var cartId = input.getAttribute('data-cartid');
    var qty    = parseInt(input.value, 10);
    if (!cartId || isNaN(qty)) return;

    // Post to server via hidden form
    var form   = document.getElementById('cartUpdateForm');
    var hidId  = document.getElementById('hdnCartID');
    var hidQty = document.getElementById('hdnQty');

    if (form && hidId && hidQty) {
      hidId.value  = cartId;
      hidQty.value = qty;
      form.submit();
    }
  });

  // ── Remove Item ────────────────────────────────────────────
  document.addEventListener('click', function (e) {
    var btn = e.target.closest('.cart-remove-btn');
    if (!btn) return;

    if (!confirm('Remove this item from your cart?')) return;

    var cartId = btn.getAttribute('data-cartid');
    var form   = document.getElementById('cartUpdateForm');
    var hidId  = document.getElementById('hdnCartID');
    var hidQty = document.getElementById('hdnQty');

    if (form && hidId && hidQty) {
      hidId.value  = cartId;
      hidQty.value = '0';
      form.submit();
    }
  });

  // ── Coupon Toggle ──────────────────────────────────────────
  var couponToggle = document.getElementById('couponToggle');
  var couponBox    = document.getElementById('couponBox');
  if (couponToggle && couponBox) {
    couponToggle.addEventListener('click', function () {
      var open = couponBox.style.display !== 'none';
      couponBox.style.display = open ? 'none' : 'block';
      couponToggle.textContent = open ? '+ Apply Coupon' : '- Hide Coupon';
    });
  }

  // ── Checkout Payment Method Toggle ─────────────────────────
  var payRadios = document.querySelectorAll('input[name="PaymentMethod"]');
  payRadios.forEach(function (radio) {
    radio.addEventListener('change', function () {
      document.querySelectorAll('.payment-detail-panel').forEach(function (p) {
        p.style.display = 'none';
      });
      var panel = document.getElementById('panel_' + this.value);
      if (panel) panel.style.display = 'block';
    });
  });

  // ── Order Summary Live Update ──────────────────────────────
  window.recalcOrderSummary = function (subtotal, discount, gstRate, shipping) {
    var gst   = (subtotal - discount) * gstRate / 100;
    var grand = subtotal - discount + gst + shipping;

    var elSub   = document.getElementById('sumSubtotal');
    var elDisc  = document.getElementById('sumDiscount');
    var elGst   = document.getElementById('sumGST');
    var elShip  = document.getElementById('sumShipping');
    var elGrand = document.getElementById('sumGrandTotal');

    if (elSub)   elSub.textContent   = '₹' + subtotal.toFixed(2);
    if (elDisc)  elDisc.textContent  = '-₹' + discount.toFixed(2);
    if (elGst)   elGst.textContent   = '₹' + gst.toFixed(2);
    if (elShip)  elShip.textContent  = shipping === 0 ? 'FREE' : '₹' + shipping.toFixed(2);
    if (elGrand) elGrand.textContent = '₹' + grand.toFixed(2);
  };

  // Expose badge updater globally
  window.updateCartBadge = updateCartBadge;

})();
