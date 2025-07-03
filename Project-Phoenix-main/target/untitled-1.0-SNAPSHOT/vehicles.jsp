<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phoenix Vehicle Rental</title>
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
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .vehicle-card {
            animation: fadeIn 0.5s ease-in;
            transition: all 0.3s ease;
            border-radius: 16px;
            border: 1px solid rgba(229, 231, 235, 0.5);
            overflow: hidden;
        }
        .vehicle-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
        .btn-action {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
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
        .input-field, .select-field {
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }
        .input-field:focus, .select-field:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 15px rgba(79, 70, 229, 0.1);
            border-left: 3px solid #4f46e5;
        }
        .error-text {
            color: #ef4444;
            font-size: 0.875rem;
            display: none;
            margin-top: 0.25rem;
        }
        .input-error {
            border-color: #ef4444;
        }
        .total-cost {
            font-weight: bold;
            color: #1f2937;
            font-size: 1.125rem;
        }
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
            background-color: #4f46e5;
            transition: width 0.3s ease;
        }
        .nav-link:hover::after {
            width: 100%;
        }
        .nav-link:hover {
            color: #4f46e5;
        }
        .card-header {
            background: linear-gradient(135deg, #4f46e5, #3b82f6);
            border-radius: 16px 16px 0 0;
            color: white;
            padding: 1rem;
        }
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .status-available {
            background-color: #d1fae5;
            color: #065f46;
        }
        .status-rented {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .checkbox-container {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        .custom-checkbox {
            appearance: none;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #d1d5db;
            border-radius: 0.25rem;
            margin-right: 0.5rem;
            position: relative;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .custom-checkbox:checked {
            background-color: #4f46e5;
            border-color: #4f46e5;
        }
        .custom-checkbox:checked::after {
            content: '✓';
            position: absolute;
            color: white;
            font-size: 0.875rem;
            top: -1px;
            left: 2px;
        }
        .brand-gradient {
            background: linear-gradient(to right, #4f46e5, #3b82f6);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
    </style>
    <script>
        function toggleCardNumberInput(selectElement, formId) {
            const form = document.getElementById(formId);
            const cardNumberInput = form.querySelector('input[name="cardNumber"]');
            const cvnInput = form.querySelector('input[name="cvn"]');
            const isCard = selectElement.value === 'Card';
            cardNumberInput.style.display = isCard ? 'block' : 'none';
            cvnInput.style.display = isCard ? 'block' : 'none';
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
            const daysInput = form.querySelector('input[name="days"]');
            if (!daysInput.value || parseInt(daysInput.value) < 1) {
                daysInput.classList.add('input-error');
                form.querySelector('#daysError').style.display = 'block';
                isValid = false;
            } else {
                daysInput.classList.remove('input-error');
                form.querySelector('#daysError').style.display = 'none';
            }
            return isValid;
        }

        function calculateTotalCost(form) {
            const vehiclePrice = parseFloat(form.dataset.vehiclePrice);
            const daysInput = form.querySelector('input[name="days"]');
            const addonCheckboxes = form.querySelectorAll('input[name="addons"]:checked');
            const totalCostElement = form.querySelector('#totalCost');

            let days = parseInt(daysInput.value) || 0;
            if (days < 0) days = 0;

            let addonTotal = 0;
            addonCheckboxes.forEach(checkbox => {
                addonTotal += parseFloat(checkbox.dataset.price);
            });

            const totalCost = (vehiclePrice * days) + addonTotal;
            totalCostElement.textContent = totalCost.toFixed(2);
        }
    </script>
</head>
<body>
<!-- Navbar -->
<nav class="bg-white shadow-md py-4 sticky top-0 z-50">
    <div class="container mx-auto px-6 flex justify-between items-center">
        <a href="index.jsp" class="flex items-center space-x-3">
            <i class="fas fa-car-side text-indigo-600 text-3xl"></i>
            <h1 class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-blue-500">Phoenix Rentals</h1>
        </a>
        <div class="hidden md:flex space-x-8">
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
            </c:if>
            <a href="vehicles?action=rentals" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                <i class="fas fa-clipboard-list mr-2"></i>Rentals
            </a>
            <a href="vehicles?action=reviews" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                <i class="fas fa-star mr-2"></i>Reviews
            </a>
            <a href="vehicles?action=logout" class="nav-link text-red-600 hover:text-red-700 font-medium">
                <i class="fas fa-sign-out-alt mr-2"></i>Log Out
            </a>
        </div>
        <button class="md:hidden text-gray-700 focus:outline-none">
            <i class="fas fa-bars text-2xl"></i>
        </button>
    </div>
</nav>

<div class="container mx-auto px-6 py-8">
    <div class="flex flex-col md:flex-row justify-between items-center mb-8">
        <h1 class="text-3xl font-bold brand-gradient mb-4 md:mb-0">Available Vehicles</h1>
        <div class="flex space-x-4">
            <a href="index.jsp" class="btn-action flex items-center space-x-2 text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
                <i class="fas fa-home"></i>
                <span>Home</span>
            </a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
            <div class="flex">
                <div class="flex-shrink-0">
                    <i class="fas fa-exclamation-circle text-red-500"></i>
                </div>
                <div class="ml-3">
                    <p class="text-sm text-red-700">${error}</p>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Search Form -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
        <h2 class="text-xl font-semibold text-gray-800 mb-4"><i class="fas fa-search mr-2 text-indigo-600"></i>Search Vehicles</h2>
        <form class="space-y-4 md:space-y-0">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-search text-gray-400"></i>
                        </div>
                        <input
                                type="text"
                                name="search"
                                placeholder="ID or Model"
                                value="${param.search}"
                                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Availability</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-check-circle text-gray-400"></i>
                        </div>
                        <select name="availability" class="select-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none appearance-none">
                            <option value="">All Availability</option>
                            <option value="true" ${param.availability == 'true' ? 'selected' : ''}>Available</option>
                            <option value="false" ${param.availability == 'false' ? 'selected' : ''}>Rented</option>
                        </select>
                        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                            <i class="fas fa-chevron-down text-gray-400"></i>
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-tag text-gray-400"></i>
                        </div>
                        <select name="category" class="select-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none appearance-none">
                            <option value="">All Categories</option>
                            <option value="Economy" ${param.category == 'Economy' ? 'selected' : ''}>Economy</option>
                            <option value="Luxury" ${param.category == 'Luxury' ? 'selected' : ''}>Luxury</option>
                            <option value="SUV" ${param.category == 'SUV' ? 'selected' : ''}>SUV</option>
                            <option value="Van" ${param.category == 'Van' ? 'selected' : ''}>Van</option>
                        </select>
                        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                            <i class="fas fa-chevron-down text-gray-400"></i>
                        </div>
                    </div>
                </div>

                <div class="flex items-end">
                    <button type="submit" class="btn-action bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-3 px-6 rounded-lg font-medium hover:shadow-lg w-full">
                        <i class="fas fa-search mr-2"></i>Search
                    </button>
                </div>
            </div>
            <input type="hidden" name="action" value="list">
        </form>
    </div>

    <!-- Vehicle Listings -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <c:forEach items="${vehicles}" var="vehicle">
            <div class="vehicle-card bg-white shadow-md overflow-hidden">
                <div class="card-header">
                    <div class="flex justify-between items-center">
                        <h2 class="text-xl font-semibold">${vehicle.model}</h2>
                        <span class="status-badge ${vehicle.available ? 'status-available' : 'status-rented'}">
                                ${vehicle.available ? 'Available' : 'Rented'}
                        </span>
                    </div>
                </div>

                <div class="p-6">
                    <div class="flex items-center space-x-2 mb-1 text-gray-700">
                        <i class="fas fa-hashtag text-indigo-500"></i>
                        <span>ID: ${vehicle.id}</span>
                    </div>
                    <div class="flex items-center space-x-2 mb-1 text-gray-700">
                        <i class="fas fa-dollar-sign text-indigo-500"></i>
                        <span>Price: $${vehicle.rentPrice}/day</span>
                    </div>
                    <div class="flex items-center space-x-2 mb-4 text-gray-700">
                        <i class="fas fa-tag text-indigo-500"></i>
                        <span>Category: ${vehicle.category}</span>
                    </div>

                    <c:if test="${vehicle.available}">
                        <form
                                action="vehicles"
                                method="post"
                                id="rentForm_${vehicle.id}"
                                class="mt-4 p-4 bg-gray-50 rounded-lg"
                                onsubmit="return validateForm(this)"
                                data-vehicle-price="${vehicle.rentPrice}"
                                oninput="calculateTotalCost(this)">

                            <h3 class="text-lg font-semibold text-gray-800 mb-3">Rent This Vehicle</h3>

                            <input type="hidden" name="action" value="rent">
                            <input type="hidden" name="id" value="${vehicle.id}">

                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Your Name</label>
                                    <div class="relative">
                                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-user text-gray-400"></i>
                                        </div>
                                        <input
                                                type="text"
                                                name="customerName"
                                                placeholder="Enter your name"
                                                value="${sessionScope.user.username}"
                                                class="input-field w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none"
                                                required>
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">ID Card Number</label>
                                    <div class="relative">
                                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-id-card text-gray-400"></i>
                                        </div>
                                        <input
                                                type="text"
                                                name="idCardNumber"
                                                placeholder="ID Card Number"
                                                class="input-field w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none"
                                                required>
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Rental Days</label>
                                    <div class="relative">
                                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-calendar-alt text-gray-400"></i>
                                        </div>
                                        <input
                                                type="number"
                                                name="days"
                                                placeholder="Number of days"
                                                min="1"
                                                class="input-field w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none"
                                                required>
                                    </div>
                                    <span id="daysError" class="error-text">Please enter a positive number of days.</span>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Payment Method</label>
                                    <div class="relative">
                                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-credit-card text-gray-400"></i>
                                        </div>
                                        <select
                                                name="paymentMethod"
                                                class="select-field w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none appearance-none"
                                                onchange="toggleCardNumberInput(this, 'rentForm_${vehicle.id}')"
                                                required>
                                            <option value="Cash">Cash</option>
                                            <option value="Card">Card</option>
                                        </select>
                                        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                            <i class="fas fa-chevron-down text-gray-400"></i>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <input
                                            type="text"
                                            name="cardNumber"
                                            placeholder="Card Number (16 digits)"
                                            class="input-field w-full pl-3 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none"
                                            style="display: none;"
                                            oninput="validateCardNumber(this)">
                                    <span id="cardNumberError" class="error-text">Please enter a valid 16-digit card number.</span>
                                </div>

                                <div>
                                    <input
                                            type="text"
                                            name="cvn"
                                            placeholder="CVN (3-4 digits)"
                                            class="input-field w-full pl-3 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none"
                                            style="display: none;"
                                            oninput="validateCvn(this)">
                                    <span id="cvnError" class="error-text">Please enter a valid CVN (3-4 digits).</span>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Add-ons:</label>
                                    <div class="space-y-1 max-h-40 overflow-y-auto pr-2">
                                        <c:forEach items="${addons}" var="addon">
                                            <div class="checkbox-container">
                                                <input
                                                        type="checkbox"
                                                        name="addons"
                                                        value="${addon.name}"
                                                        data-price="${addon.price}"
                                                        class="custom-checkbox"
                                                        id="addon_${vehicle.id}_${addon.name}">
                                                <label for="addon_${vehicle.id}_${addon.name}" class="text-sm">${addon.name} ($${addon.price})</label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="bg-indigo-50 p-3 rounded-lg">
                  <span class="total-cost flex items-center justify-between">
                    <span>Total Cost:</span>
                    <span class="text-xl text-indigo-700">$<span id="totalCost">0.00</span></span>
                  </span>
                                </div>

                                <button
                                        type="submit"
                                        class="btn-action w-full bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-2 px-4 rounded-lg hover:shadow-lg">
                                    <i class="fas fa-clipboard-check mr-2"></i>Complete Rental
                                </button>
                            </div>
                        </form>
                    </c:if>

                    <!-- Admin Options -->
                    <c:if test="${sessionScope.isAdmin}">
                        <div class="mt-4 flex gap-2">
                            <form action="vehicles" method="get" class="flex-1">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" value="${vehicle.id}">
                                <button type="submit" class="btn-action w-full bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700">
                                    <i class="fas fa-edit mr-1"></i> Edit
                                </button>
                            </form>
                            <form action="vehicles" method="post" class="flex-1">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${vehicle.id}">
                                <button type="submit" class="btn-action w-full bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700">
                                    <i class="fas fa-trash-alt mr-1"></i> Delete
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Footer -->
<footer class="bg-gray-900 text-white py-12 mt-16">
    <div class="container mx-auto px-6">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div class="mb-6">
                <div class="flex items-center space-x-3 mb-4">
                    <i class="fas fa-car-side text-indigo-400 text-2xl"></i>
                    <h3 class="text-xl font-bold text-white">Phoenix Rentals</h3>
                </div>
                <p class="text-gray-400">Premium vehicle rental services tailored to your needs. Luxury at affordable prices.</p>
                <div class="flex mt-4 space-x-4">
                    <a href="#" class="text-gray-400 hover:text-white transition-colors">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white transition-colors">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white transition-colors">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white transition-colors">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                </div>
            </div>

            <div>
                <h4 class="text-lg font-semibold mb-4 text-indigo-300">Quick Links</h4>
                <ul class="space-y-2">
                    <li><a href="index.jsp" class="text-gray-400 hover:text-white transition-colors">Home</a></li>
                    <li><a href="vehicles?action=list" class="text-gray-400 hover:text-white transition-colors">Vehicles</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-white transition-colors">About Us</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Contact</a></li>
                </ul>
            </div>

            <div>
                <h4 class="text-lg font-semibold mb-4 text-indigo-300">Support</h4>
                <ul class="space-y-2">
                    <li><a href="#" class="text-gray-400 hover:text-white transition-colors">FAQ</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Terms & Conditions</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Privacy Policy</a></li>
                    <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Help Center</a></li>
                </ul>
            </div>

            <div>
                <h4 class="text-lg font-semibold mb-4 text-indigo-300">Contact Us</h4>
                <ul class="space-y-2 text-gray-400">
                    <li class="flex items-start space-x-2">
                        <i class="fas fa-map-marker-alt mt-1"></i>
                        <span>SLIIT Malabe Campus, New Kandy Rd, Malabe 10115</span>
                    </li>
                    <li class="flex items-center space-x-2">
                        <i class="fas fa-phone"></i>
                        <span>+9476 603 55 65</span>
                    </li>
                    <li class="flex items-center space-x-2">
                        <i class="fas fa-envelope"></i>
                        <span>info@sliit.lk</span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="border-t border-gray-800 mt-10 pt-6 text-center text-gray-400">
            <p>© 2025 Phoenix Vehicle Rental. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Mobile Menu JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuButton = document.querySelector('.md\\:hidden');
        const mobileMenu = document.querySelector('.md\\:flex');

        if (mobileMenuButton && mobileMenu) {
            mobileMenuButton.addEventListener('click', function() {
                mobileMenu.classList.toggle('hidden');
                mobileMenu.classList.toggle('flex');
                mobileMenu.classList.toggle('flex-col');
                mobileMenu.classList.toggle('absolute');
                mobileMenu.classList.toggle('top-16');
                mobileMenu.classList.toggle('right-0');
                mobileMenu.classList.toggle('bg-white');
                mobileMenu.classList.toggle('p-4');
                mobileMenu.classList.toggle('shadow-lg');
                mobileMenu.classList.toggle('rounded-lg');
                mobileMenu.classList.toggle('w-48');
            });
        }
    });
</script>
</body>
</html>
