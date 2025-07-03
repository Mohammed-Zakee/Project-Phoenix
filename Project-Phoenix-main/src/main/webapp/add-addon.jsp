<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Add-on - Phoenix Rentals</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9fafb;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Animation Effects */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .slide-up { animation: slideUp 0.8s ease-out; }
        .fade-in { animation: fadeIn 0.5s ease-in; }

        /* Interactive Elements */
        .input-field {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
            background-color: #f9fafb;
        }
        .input-field:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 15px rgba(79, 70, 229, 0.15);
            border-left: 4px solid #4f46e5;
            background-color: white;
        }
        .input-field:hover {
            border-color: #4f46e5;
            background-color: white;
        }

        /* Button Effects */
        .btn-submit {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
            box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.2), 0 2px 4px -1px rgba(79, 70, 229, 0.1);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3), 0 4px 6px -2px rgba(79, 70, 229, 0.2);
        }
        .btn-submit:active {
            transform: translateY(0);
        }
        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transition: transform 0.6s;
            transform: skewX(-15deg);
            z-index: -1;
        }
        .btn-submit:hover::before {
            transform: translateX(200%) skewX(-15deg);
        }

        /* Navigation */
        .nav-link {
            transition: all 0.3s ease;
            position: relative;
            font-weight: 500;
        }
        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -3px;
            left: 50%;
            background: linear-gradient(to right, #4f46e5, #3b82f6);
            transition: width 0.3s ease, left 0.3s ease;
        }
        .nav-link:hover::after {
            width: 100%;
            left: 0;
        }
        .nav-link:hover {
            color: #4f46e5;
        }
        .nav-link:active {
            transform: scale(0.97);
        }
        .nav-link.active {
            color: #4f46e5;
            font-weight: 600;
        }
        .nav-link.active::after {
            width: 100%;
            left: 0;
        }

        /* Brand and UI Elements */
        .brand-gradient {
            background: linear-gradient(to right, #4f46e5, #3b82f6);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        .gradient-bg {
            background: linear-gradient(135deg, #4f46e5, #3b82f6);
        }

        /* Card Styling */
        .form-card {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            background-color: white;
            border: 1px solid rgba(229, 231, 235, 0.5);
        }
        .form-card:hover {
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.05);
            transform: translateY(-5px);
        }
        .card-header {
            background: linear-gradient(135deg, #4f46e5, #3b82f6);
            padding: 1.75rem;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .card-header::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            z-index: 1;
        }
        .card-header::after {
            content: '';
            position: absolute;
            bottom: -60px;
            left: -60px;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            z-index: 1;
        }

        /* Icon Effects */
        .addon-icon {
            transition: all 0.5s ease;
            position: relative;
            z-index: 2;
        }
        .form-card:hover .addon-icon {
            transform: rotate(15deg) scale(1.1);
        }
        .input-icon {
            transition: all 0.3s ease;
        }
        input:focus + div .input-icon {
            color: #4f46e5;
        }

        /* Mobile Menu */
        .mobile-menu {
            transform: translateY(-10px);
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        .mobile-menu.active {
            transform: translateY(0);
            opacity: 1;
            visibility: visible;
        }

        /* Error Message */
        .error-message {
            border-left: 4px solid #ef4444;
            background-color: #fee2e2;
            transition: all 0.3s ease;
        }
        .error-message:hover {
            transform: translateX(5px);
        }

        /* Back Button */
        .back-button {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .back-button:hover {
            transform: translateX(-5px);
        }
        .back-button::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: #4f46e5;
            transition: width 0.3s ease;
        }
        .back-button:hover::after {
            width: 100%;
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="bg-white shadow-md py-4 sticky top-0 z-50">
    <div class="container mx-auto px-6 flex justify-between items-center">
        <a href="index.jsp" class="flex items-center space-x-3 group">
            <i class="fas fa-car-side text-indigo-600 text-3xl transition-transform duration-300 group-hover:scale-110"></i>
            <h1 class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-blue-500">Phoenix Rentals</h1>
        </a>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex space-x-8">
            <a href="vehicles?action=list" class="nav-link text-gray-700 hover:text-indigo-600">
                <i class="fas fa-car mr-2"></i>Vehicles
            </a>
            <c:if test="${sessionScope.isAdmin}">
                <a href="add-vehicle.jsp" class="nav-link text-gray-700 hover:text-indigo-600">
                    <i class="fas fa-plus-circle mr-2"></i>Add Vehicle
                </a>
                <a href="add-addon.jsp" class="nav-link active text-indigo-600">
                    <i class="fas fa-puzzle-piece mr-2"></i>Add Add-on
                </a>
                <a href="vehicles?action=rentals" class="nav-link text-gray-700 hover:text-indigo-600">
                    <i class="fas fa-clipboard-list mr-2"></i>Rentals
                </a>
            </c:if>
            <a href="vehicles?action=reviews" class="nav-link text-gray-700 hover:text-indigo-600">
                <i class="fas fa-star mr-2"></i>Reviews
            </a>
            <a href="vehicles?action=logout" class="nav-link text-red-600 hover:text-red-700">
                <i class="fas fa-sign-out-alt mr-2"></i>Log Out
            </a>
        </div>

        <!-- Mobile Menu Button -->
        <button id="mobileMenuButton" class="md:hidden text-gray-700 focus:outline-none">
            <i class="fas fa-bars text-2xl"></i>
        </button>
    </div>

    <!-- Mobile Navigation -->
    <div id="mobileMenu" class="mobile-menu md:hidden absolute w-full bg-white shadow-lg rounded-b-lg">
        <div class="container mx-auto px-6 py-3 flex flex-col space-y-3">
            <a href="vehicles?action=list" class="nav-link text-gray-700 hover:text-indigo-600 py-2">
                <i class="fas fa-car mr-2"></i>Vehicles
            </a>
            <c:if test="${sessionScope.isAdmin}">
                <a href="add-vehicle.jsp" class="nav-link text-gray-700 hover:text-indigo-600 py-2">
                    <i class="fas fa-plus-circle mr-2"></i>Add Vehicle
                </a>
                <a href="add-addon.jsp" class="nav-link active text-indigo-600 py-2">
                    <i class="fas fa-puzzle-piece mr-2"></i>Add Add-on
                </a>
                <a href="vehicles?action=rentals" class="nav-link text-gray-700 hover:text-indigo-600 py-2">
                    <i class="fas fa-clipboard-list mr-2"></i>Rentals
                </a>
            </c:if>
            <a href="vehicles?action=reviews" class="nav-link text-gray-700 hover:text-indigo-600 py-2">
                <i class="fas fa-star mr-2"></i>Reviews
            </a>
            <a href="vehicles?action=logout" class="nav-link text-red-600 hover:text-red-700 py-2">
                <i class="fas fa-sign-out-alt mr-2"></i>Log Out
            </a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container mx-auto p-6 flex justify-center flex-grow">
    <!-- Redirect non-admin users -->
    <c:if test="${sessionScope.user == null || !sessionScope.isAdmin}">
        <c:redirect url="vehicles?action=list"/>
    </c:if>

    <!-- Add-on Form Card -->
    <div class="form-card max-w-md w-full slide-up my-6">
        <div class="card-header flex items-start">
            <div class="mr-4 relative">
                <div class="absolute -top-1 -left-1 w-10 h-10 rounded-full bg-indigo-500 opacity-30 animate-pulse"></div>
                <i class="fas fa-puzzle-piece text-white text-4xl addon-icon"></i>
            </div>
            <div class="relative z-10">
                <h1 class="text-2xl font-bold">Add New Add-on</h1>
                <p class="text-indigo-100 mt-1">Enter add-on details below</p>
            </div>
        </div>

        <div class="p-8">
            <!-- Error Message Display -->
            <c:if test="${not empty error}">
                <div class="error-message bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r flex items-start">
                    <div class="flex-shrink-0 mr-3">
                        <i class="fas fa-exclamation-circle text-red-500 text-lg"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-medium text-red-800">Error</h3>
                        <p class="text-sm text-red-700 mt-1">${error}</p>
                    </div>
                </div>
            </c:if>

            <!-- Add-on Form -->
            <form action="vehicles" method="post" class="space-y-6">
                <input type="hidden" name="action" value="createAddon">

                <!-- Add-on ID Field -->
                <div class="space-y-2">
                    <label for="addonId" class="block text-sm font-medium text-gray-700">Add-on ID</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-hashtag text-gray-400 input-icon"></i>
                        </div>
                        <input
                                type="text"
                                id="addonId"
                                name="addonId"
                                placeholder="Enter add-on ID (e.g., A001)"
                                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none"
                                required>
                        <div class="absolute inset-y-0 right-3 flex items-center pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity">
                            <i class="fas fa-info-circle text-indigo-400 text-sm"></i>
                        </div>
                    </div>
                    <p class="text-xs text-gray-500">Unique identifier for the add-on</p>
                </div>

                <!-- Add-on Name Field -->
                <div class="space-y-2">
                    <label for="addonName" class="block text-sm font-medium text-gray-700">Add-on Name</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-tag text-gray-400 input-icon"></i>
                        </div>
                        <input
                                type="text"
                                id="addonName"
                                name="name"
                                placeholder="Enter add-on name (e.g., Child Seat)"
                                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none"
                                required>
                        <div class="absolute inset-y-0 right-3 flex items-center pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity">
                            <i class="fas fa-info-circle text-indigo-400 text-sm"></i>
                        </div>
                    </div>
                    <p class="text-xs text-gray-500">Descriptive name for the add-on item</p>
                </div>

                <!-- Price Field -->
                <div class="space-y-2">
                    <label for="addonPrice" class="block text-sm font-medium text-gray-700">Price</label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-dollar-sign text-gray-400 input-icon"></i>
                        </div>
                        <input
                                type="number"
                                id="addonPrice"
                                name="price"
                                placeholder="Enter price (e.g., 10.00)"
                                step="0.01"
                                min="0"
                                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none"
                                required>
                        <div class="absolute inset-y-0 right-3 flex items-center pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity">
                            <i class="fas fa-info-circle text-indigo-400 text-sm"></i>
                        </div>
                    </div>
                    <p class="text-xs text-gray-500">Price per rental period (in USD)</p>
                </div>

                <!-- Submit Button -->
                <button
                        type="submit"
                        class="btn-submit w-full bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-3 px-4 rounded-lg font-medium mt-8 flex justify-center items-center space-x-2">
                    <i class="fas fa-plus-circle"></i>
                    <span>Add Add-on</span>
                </button>
            </form>

            <!-- Back Button -->
            <div class="mt-8 text-center">
                <a href="vehicles?action=list" class="back-button inline-flex items-center text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Vehicles
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Footer (Simple Version) -->
<footer class="mt-auto py-6 bg-gray-50 border-t border-gray-200">
    <div class="container mx-auto px-6 text-center text-gray-500 text-sm">
        <p>© 2023 Phoenix Rentals. All rights reserved.</p>
    </div>
</footer>

<!-- JavaScript for Mobile Menu -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuButton = document.getElementById('mobileMenuButton');
        const mobileMenu = document.getElementById('mobileMenu');

        if (mobileMenuButton && mobileMenu) {
            mobileMenuButton.addEventListener('click', function() {
                mobileMenu.classList.toggle('active');
                if (mobileMenu.classList.contains('active')) {
                    mobileMenuButton.innerHTML = '<i class="fas fa-times text-2xl"></i>';
                } else {
                    mobileMenuButton.innerHTML = '<i class="fas fa-bars text-2xl"></i>';
                }
            });
        }

        // Form validation enhancement
        const form = document.querySelector('form');
        if (form) {
            form.addEventListener('submit', function(event) {
                const addonId = document.getElementById('addonId');
                const addonName = document.getElementById('addonName');
                const addonPrice = document.getElementById('addonPrice');

                let isValid = true;

                // Simple validation example - expand as needed
                if (addonId.value.trim() === '') {
                    highlightError(addonId);
                    isValid = false;
                } else {
                    removeError(addonId);
                }

                if (addonName.value.trim() === '') {
                    highlightError(addonName);
                    isValid = false;
                } else {
                    removeError(addonName);
                }

                if (addonPrice.value <= 0) {
                    highlightError(addonPrice);
                    isValid = false;
                } else {
                    removeError(addonPrice);
                }

                if (!isValid) {
                    event.preventDefault();
                }
            });
        }

        function highlightError(element) {
            element.classList.add('border-red-500');
            element.classList.add('bg-red-50');
        }

        function removeError(element) {
            element.classList.remove('border-red-500');
            element.classList.remove('bg-red-50');
        }
    });
</script>
</body>
</html>