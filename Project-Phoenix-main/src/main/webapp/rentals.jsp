<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rentals - Phoenix Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9fafb;
            color: #111827;
            scroll-behavior: smooth;
        }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideIn { from { transform: translateX(-20px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        .fade-in { animation: fadeIn 1s ease-in-out; }
        .slide-in { animation: slideIn 0.5s ease-out; }
        .table-row { animation: fadeInUp 0.5s ease-out; }
        .nav-link {
            transition: all 0.3s ease;
            position: relative;
        }
        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -3px;
            left: 0;
            background-color: #3b82f6;
            transition: width 0.3s ease;
        }
        .nav-link:hover::after {
            width: 100%;
        }
        .btn-action {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .btn-action:hover { transform: scale(1.05); }
        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transition: transform 0.6s;
            transform: skewX(-15deg);
        }
        .btn-action:hover::before {
            transform: translateX(100%) skewX(-15deg);
        }
        .input-field, .select-field { transition: all 0.3s ease; }
        .input-field:focus, .select-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .error-text { color: #ef4444; font-size: 0.875rem; display: none; }
        .success-text { color: #22c55e; font-size: 1rem; }
        .input-error { border-color: #ef4444; }
        .table-card {
            border-radius: 16px;
            animation: fadeIn 0.5s ease-in;
            transition: all 0.3s ease;
            overflow: hidden;
        }
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

        // Mobile navigation toggle
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuButton = document.querySelector('.md\\:hidden');
            const mobileMenu = document.querySelector('.md\\:flex');

            if (mobileMenuButton && mobileMenu) {
                mobileMenuButton.addEventListener('click', function() {
                    if (mobileMenu.classList.contains('hidden')) {
                        // Show mobile menu
                        mobileMenu.classList.remove('hidden');
                        mobileMenu.classList.add('flex', 'flex-col', 'absolute', 'top-16', 'right-0', 'bg-white', 'p-4', 'shadow-lg', 'rounded-lg', 'w-48', 'z-50');

                        // Switch to X icon
                        mobileMenuButton.innerHTML = '<i class="fas fa-times text-2xl"></i>';
                    } else {
                        // Hide mobile menu
                        mobileMenu.classList.add('hidden');
                        mobileMenu.classList.remove('flex', 'flex-col', 'absolute', 'top-16', 'right-0', 'bg-white', 'p-4', 'shadow-lg', 'rounded-lg', 'w-48', 'z-50');

                        // Switch back to bars icon
                        mobileMenuButton.innerHTML = '<i class="fas fa-bars text-2xl"></i>';
                    }
                });
            }
        });
    </script>
</head>
<body class="bg-gray-50 font-sans">
<!-- Navbar -->
<nav class="bg-white shadow-md py-4 sticky top-0 z-50">
    <div class="container mx-auto px-6 flex justify-between items-center">
        <a href="index.jsp" class="flex items-center space-x-3">
            <i class="fas fa-car-side text-indigo-600 text-3xl"></i>
            <h1 class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-blue-500">Phoenix Rentals</h1>
        </a>
        <div class="hidden md:flex space-x-8">
            <a href="index.jsp" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                <i class="fas fa-home mr-2"></i>Home
            </a>
            <a href="vehicles?action=list" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                <i class="fas fa-car mr-2"></i>Vehicles
            </a>
            <c:if test="${sessionScope.isAdmin}">
                <a href="add-vehicle.jsp" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                    <i class="fas fa-plus-circle mr-2"></i>Add Vehicle
                </a>
                <a href="add-addon.jsp" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                    <i class="fas fa-puzzle-piece mr-2"></i>Add Add-on
                </a>
                <a href="vehicles?action=rentals" class="nav-link text-gray-700 hover:text-indigo-600 font-medium font-bold">
                    <i class="fas fa-clipboard-list mr-2"></i>Rentals
                </a>
            </c:if>
            <a href="vehicles?action=reviews" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                <i class="fas fa-star mr-2"></i>Reviews
            </a>
            <a href="vehicles?action=logout" class="nav-link text-red-600 hover:text-red-700 font-medium">
                <i class="fas fa-sign-out-alt mr-2"></i>Logout
            </a>
        </div>
        <button class="md:hidden text-gray-700 focus:outline-none">
            <i class="fas fa-bars text-2xl"></i>
        </button>
    </div>
</nav>
<div class="container mx-auto p-6 fade-in">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-blue-500">Rental Records</h1>
        <div class="flex space-x-2">
            <a href="index.jsp" class="nav-link text-indigo-600 hover:text-indigo-800 flex items-center">
                <i class="fas fa-chevron-left mr-2"></i> Back to Home
            </a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-lg shadow-sm">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                <p class="text-red-700">${error}</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded-lg shadow-sm">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <p class="text-green-700">${success}</p>
            </div>
        </div>
    </c:if>

    <form action="vehicles" method="post">
        <input type="hidden" name="action" value="deleteRentals">
        <div class="mb-4">
            <c:if test="${sessionScope.isAdmin}">
                <button type="submit" class="btn-action bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 shadow-md flex items-center">
                    <i class="fas fa-trash-alt mr-2"></i> Delete Selected
                </button>
            </c:if>
        </div>
        <div class="bg-white shadow-lg rounded-lg overflow-hidden table-card">
            <table class="w-full">
                <thead class="bg-gradient-to-r from-indigo-600 to-blue-500 text-white">
                <tr>
                    <c:if test="${sessionScope.isAdmin}">
                        <th class="p-4 text-left">
                            <div class="flex items-center">
                                <input type="checkbox" class="mr-2" onchange="document.querySelectorAll('input[name=selectedRentals]').forEach(cb => cb.checked = this.checked)">
                                <span>Select</span>
                            </div>
                        </th>
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