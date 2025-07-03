<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Rentals - Phoenix Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    .table-row { animation: fadeInUp 0.5s ease-out; }
    .btn-action { transition: all 0.3s ease; }
    .btn-action:hover { transform: scale(1.05); }
    .input-field, .select-field { transition: all 0.3s ease; }
    .input-field:focus, .select-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    .error-text { color: #ef4444; font-size: 0.875rem; display: none; }
    .success-text { color: #22c55e; font-size: 1rem; }
    .input-error { border-color: #ef4444; }
  </style>
  <script>
    function toggleCardNumberInput(selectElement) {
      const form = selectElement.closest('form');
      const cardNumberInput = form.querySelector('input[name="cardNumber"]');
      const cvnInput = form.querySelector('input[name="cvn"]');
      const isCard = selectElement.value === 'Card';
      cardNumberInput.style.display = isCard ? 'inline-block' : 'none';
      cvnInput.style.display = isCard ? 'inline-block' : 'none';
      cardNumberInput.required = isCard;
      cvnInput.required = isCard;
      cardNumberInput.classList.remove('input-error');
      cvnInput.classList.remove('input-error');
      form.querySelector('#cardNumberError').style.display = 'none';
      form.querySelector('#cvnError').style.display = 'none';
    }
    function validateCardNumber(input) {
      const errorSpan = input.closest('form').querySelector('#cardNumberError');
      const pattern = /^[0-9]{16}$/;
      if (input.value && !pattern.test(input.value)) {
        input.classList.add('input-error');
        errorSpan.style.display = 'block';
      } else {
        input.classList.remove('input-error');
        errorSpan.style.display = 'none';
      }
    }
    function validateCvn(input) {
      const errorSpan = input.closest('form').querySelector('#cvnError');
      const pattern = /^[0-9]{3,4}$/;
      if (input.value && !pattern.test(input.value)) {
        input.classList.add('input-error');
        errorSpan.style.display = 'block';
      } else {
        input.classList.remove('input-error');
        errorSpan.style.display = 'none';
      }
    }
    function validateForm(form) {
      let isValid = true;
      const paymentMethod = form.querySelector('select[name="paymentMethod"]').value;
      if (paymentMethod === 'Card') {
        const cardNumberInput = form.querySelector('input[name="cardNumber"]');
        const cvnInput = form.querySelector('input[name="cvn"]');
        validateCardNumber(cardNumberInput);
        validateCvn(cvnInput);
        if (cardNumberInput.classList.contains('input-error') || cvnInput.classList.contains('input-error')) {
          isValid = false;
        }
      }
      return isValid;
    }
  </script>
</head>
<body class="bg-gray-100 font-sans">
<nav class="bg-white shadow-lg p-4">
  <div class="container mx-auto flex justify-between items-center">
    <h1 class="text-2xl font-bold text-blue-700">Phoenix Vehicle Rental</h1>
    <div class="space-x-4">
      <a href="vehicles?action=list" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Vehicles</a>
      <c:if test="${sessionScope.isAdmin}">
        <a href="add-vehicle.jsp" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Add Vehicle</a>
        <a href="add-addon.jsp" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Add Add-on</a>
      </c:if>
      <a href="vehicles?action=rentals" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Rentals</a>
      <a href="vehicles?action=reviews" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Reviews</a>
      <a href="vehicles?action=logout" class="text-red-600 hover:text-red-800 transition-all duration-300">Log Out</a>
    </div>
  </div>
</nav>
<div class="container mx-auto p-6">
  <h1 class="text-3xl font-bold text-blue-700 mb-6">Rental Records</h1>
  <c:if test="${not empty error}">
    <p class="text-red-500 mb-4 text-center">${error}</p>
  </c:if>
  <c:if test="${not empty success}">
    <p class="success-text mb-4 text-center">${success}</p>
  </c:if>
  <form action="vehicles" method="post">
    <input type="hidden" name="action" value="deleteRentals">
    <div class="mb-4">
      <c:if test="${sessionScope.isAdmin}">
        <button type="submit" class="btn-action bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700">Delete Selected</button>
      </c:if>
    </div>
    <div class="bg-white shadow-lg rounded-lg overflow-hidden">
      <table class="w-full">
        <thead class="bg-blue-600 text-white">
        <tr>
          <c:if test="${sessionScope.isAdmin}">
            <th class="p-4 text-left"><input type="checkbox" onchange="document.querySelectorAll('input[name=selectedRentals]').forEach(cb => cb.checked = this.checked)"></th>
          </c:if>
          <th class="p-4 text-left">ID</th>
          <th class="p-4 text-left">Model</th>
          <th class="p-4 text-left">Price</th>
          <th class="p-4 text-left">Customer</th>
          <th class="p-4 text-left">ID Card Number</th>
          <th class="p-4 text-left">Rental Date</th>
          <th class="p-4 text-left">Return Date</th>
          <th class="p-4 text-left">Days</th>
          <th class="p-4 text-left">Total Cost</th>
          <th class="p-4 text-left">Payment Method</th>
          <th class="p-4 text-left">Add-ons</th>
          <th class="p-4 text-left">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rentals}" var="rental">
          <tr class="table-row border-b hover:bg-gray-50">
            <c:if test="${sessionScope.isAdmin}">
              <td class="p-4"><input type="checkbox" name="selectedRentals" value="${rental.id}_${rental.rentalDate}"></td>
            </c:if>
            <td class="p-4">${rental.id}</td>
            <td class="p-4">${rental.model}</td>
            <td class="p-4">$${rental.rentPrice}</td>
            <td class="p-4">${rental.customerName}</td>
            <td class="p-4">${rental.idCardNumber}</td>
            <td class="p-4">${rental.rentalDate}</td>
            <td class="p-4">${rental.returnDate != null ? rental.returnDate : 'Not Returned'}</td>
            <td class="p-4">${rental.days}</td>
            <td class="p-4">
              <c:if test="${rental.returned}">
                <c:set var="days" value="${java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.parse(rental.rentalDate), java.time.LocalDate.parse(rental.returnDate))}" />
                <c:out value="$${days * rental.rentPrice}" />
              </c:if>
              <c:if test="${!rental.returned}">
                <c:out value="$${rental.days * rental.rentPrice}" />
              </c:if>
            </td>
            <td class="p-4">${rental.payment != null ? rental.payment.method : 'None'}</td>
            <td class="p-4">${rental.addons != null ? rental.addons : 'None'}</td>
            <td class="p-4">
              <div class="flex items-center gap-2 flex-wrap">
                <c:if test="${!rental.returned && sessionScope.isAdmin}">
                  <form action="vehicles" method="post" class="inline">
                    <input type="hidden" name="action" value="return">
                    <input type="hidden" name="id" value="${rental.id}">
                    <input type="hidden" name="rentalDate" value="${rental.rentalDate}">
                    <button type="submit" class="btn-action bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">Return</button>
                  </form>
                </c:if>
                <c:if test="${!sessionScope.isAdmin}">
                  <form action="vehicles" method="post" class="inline" onsubmit="return validateForm(this)">
                    <input type="hidden" name="action" value="updatePayment">
                    <input type="hidden" name="id" value="${rental.id}">
                    <input type="hidden" name="rentalDate" value="${rental.rentalDate}">
                    <select name="paymentMethod" class="select-field p-2 border rounded-lg focus:outline-none" onchange="toggleCardNumberInput(this)" required>
                      <option value="Cash">Cash</option>
                      <option value="Card" ${rental.payment != null && rental.payment.method == 'Card' ? 'selected' : ''}>Card</option>
                    </select>
                    <input type="text" name="cardNumber" placeholder="Card Number (16 digits)" class="input-field p-2 border rounded-lg focus:outline-none" style="display: ${rental.payment != null && rental.payment.method == 'Card' ? 'inline-block' : 'none'};" oninput="validateCardNumber(this)">
                    <span id="cardNumberError" class="error-text">Please enter a valid 16-digit card number.</span>
                    <input type="text" name="cvn" placeholder="CVN (3-4 digits)" class="input-field p-2 border rounded-lg focus:outline-none" style="display: ${rental.payment != null && rental.payment.method == 'Card' ? 'inline-block' : 'none'};" oninput="validateCvn(this)">
                    <span id="cvnError" class="error-text">Please enter a valid CVN (3-4 digits).</span>
                    <button type="submit" class="btn-action bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700">Update Payment</button>
                  </form>
                  <form action="vehicles" method="post" class="inline">
                    <input type="hidden" name="action" value="deletePayment">
                    <input type="hidden" name="id" value="${rental.id}">
                    <input type="hidden" name="rentalDate" value="${rental.rentalDate}">
                    <button type="submit" class="btn-action bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700">Delete Payment</button>
                  </form>
                </c:if>
              </div>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </form>
</div>
</body>
</html>