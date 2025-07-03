<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews - Phoenix Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9fafb;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideIn { from { transform: translateX(-20px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        .fade-in { animation: fadeIn 1s ease-in-out; }
        .slide-in { animation: slideIn 0.5s ease-out; }
        .table-row { animation: fadeIn 0.5s ease-out; }

        .btn-action {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .btn-action:hover { transform: scale(1.05); }

        .input-field, .select-field, .textarea-field {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }
        .input-field:focus, .select-field:focus, .textarea-field:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 15px rgba(79, 70, 229, 0.15);
            border-left: 4px solid #4f46e5;
        }

        .btn-submit {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transition: transform 0.6s;
            transform: skewX(-15deg);
            z-index: -1;
        }
        .btn-submit:hover::before {
            transform: translateX(100%) skewX(-15deg);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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

        .star-rating { color: #f59e0b; }

        .brand-gradient {
            background: linear-gradient(to right, #4f46e5, #3b82f6);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .review-card {
            transition: all 0.3s ease;
            border-radius: 16px;
            overflow: hidden;
        }
        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
    </style>
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
                <a href="vehicles?action=rentals" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                    <i class="fas fa-clipboard-list mr-2"></i>Rentals
                </a>
            </c:if>
            <a href="vehicles?action=reviews" class="nav-link text-indigo-600 font-medium">
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
<div class="container mx-auto px-6 py-8 fade-in">
    <div class="flex flex-col md:flex-row justify-between items-center mb-8">
        <h1 class="text-3xl font-bold brand-gradient mb-4 md:mb-0">Vehicle Reviews</h1>
        <div class="flex space-x-4">
            <a href="index.jsp" class="btn-action flex items-center space-x-2 text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
                <i class="fas fa-home"></i>
                <span>Home</span>
            </a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded slide-in">
            <div class="flex">
                <div class="flex-shrink-0">
                    <i class="fas fa-exclamation-circle text-red-500"></i>
                </div>
                <div class="ml-3">
                    <p class="text-sm text-red-700">${error}</p>
                </div>
            </div>
        </div>
    </c:if>  <!-- Main Content -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Add Review Form (Only for Customers) -->
        <c:if test="${!sessionScope.isAdmin}">
            <div class="lg:col-span-1">
                <div class="review-card bg-white p-8 rounded-xl shadow-lg">
                    <div class="card-header mb-6">
                        <div class="flex items-center mb-4">
                            <i class="fas fa-comment-dots text-2xl text-indigo-600 mr-3"></i>
                            <h2 class="text-2xl font-semibold brand-gradient">Add a Review</h2>
                        </div>
                        <p class="text-gray-600 text-sm">Share your experience with our vehicles</p>
                    </div>

                    <form action="vehicles" method="post" class="space-y-5">
                        <input type="hidden" name="action" value="addReview">

                        <div>
                            <label for="vehicleId" class="block text-sm font-medium text-gray-700 mb-1">Select Vehicle</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-car-side text-gray-400"></i>
                                </div>
                                <select id="vehicleId" name="vehicleId"
                                        class="select-field w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg focus:outline-none appearance-none" required>
                                    <option value="">Select Vehicle</option>
                                    <c:forEach items="${vehicles}" var="vehicle">
                                        <option value="${vehicle.id}">${vehicle.model} (${vehicle.id})</option>
                                    </c:forEach>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                            </div>
                        </div>

                        <div>
                            <label for="rating" class="block text-sm font-medium text-gray-700 mb-1">Your Rating</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-star text-yellow-400"></i>
                                </div>
                                <input id="rating" type="number" name="rating" placeholder="Rating (1-5)" min="1" max="5"
                                       class="input-field w-full pl-10 py-3 border border-gray-300 rounded-lg focus:outline-none" required>
                            </div>
                        </div>

                        <div>
                            <label for="comment" class="block text-sm font-medium text-gray-700 mb-1">Your Review</label>
                            <div class="relative">
                <textarea id="comment" name="comment" placeholder="Tell us about your experience with this vehicle..."
                          class="textarea-field w-full p-3 border border-gray-300 rounded-lg focus:outline-none" rows="4" required></textarea>
                            </div>
                        </div>

                        <button type="submit"
                                class="btn-submit w-full bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-3 px-4 rounded-lg font-semibold hover:shadow-lg">
                            <i class="fas fa-paper-plane mr-2"></i> Submit Review
                        </button>
                    </form>
                </div>
            </div>
        </c:if>    <!-- Reviews Table -->
        <div class="lg:col-span-2">
            <div class="review-card bg-white shadow-lg rounded-xl overflow-hidden">
                <div class="card-header bg-gradient-to-r from-indigo-600 to-blue-500 p-6 relative">
                    <h3 class="text-xl font-semibold text-white flex items-center">
                        <i class="fas fa-star mr-3"></i> Customer Reviews
                    </h3>
                    <p class="text-indigo-100 mt-1 text-sm">See what our customers think about our vehicles</p>
                    <div class="absolute right-0 bottom-0 opacity-10">
                        <i class="fas fa-comments text-5xl"></i>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center">
                                    <i class="fas fa-car-side text-indigo-500 mr-2"></i>Vehicle
                                </div>
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center">
                                    <i class="fas fa-user text-indigo-500 mr-2"></i>User
                                </div>
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center">
                                    <i class="fas fa-star text-indigo-500 mr-2"></i>Rating
                                </div>
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center">
                                    <i class="fas fa-comment text-indigo-500 mr-2"></i>Comment
                                </div>
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center">
                                    <i class="fas fa-calendar-alt text-indigo-500 mr-2"></i>Date
                                </div>
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center">
                                    <i class="fas fa-cog text-indigo-500 mr-2"></i>Actions
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                        <c:forEach items="${reviews}" var="review">
                            <tr class="table-row hover:bg-gray-50 transition duration-150">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:forEach items="${vehicles}" var="vehicle">
                                        <c:if test="${vehicle.id == review.vehicleId}">
                                            <div class="flex items-center">
                                                <i class="fas fa-car-side text-indigo-500 mr-2"></i>
                                                <span class="font-medium text-gray-900">${vehicle.model}</span>
                                                <span class="text-gray-500 ml-1 text-xs">(${vehicle.id})</span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <i class="fas fa-user-circle text-gray-500 mr-2"></i>
                                        <span class="text-gray-900">${review.username}</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="star-rating flex items-center">
                                        <c:forEach begin="1" end="${review.rating}">
                                            <i class="fas fa-star"></i>
                                        </c:forEach>
                                        <c:forEach begin="${review.rating + 1}" end="5">
                                            <i class="far fa-star"></i>
                                        </c:forEach>
                                        <span class="ml-1 text-gray-700">${review.rating}/5</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-gray-700 max-w-sm truncate">
                                            ${review.comment}
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="text-gray-600 flex items-center">
                                        <i class="far fa-clock mr-1"></i>${review.reviewDate}
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:if test="${sessionScope.user.username == review.username && !sessionScope.isAdmin}">
                                        <form action="vehicles" method="post" class="inline">
                                            <input type="hidden" name="action" value="deleteReview">
                                            <input type="hidden" name="reviewId" value="${review.reviewId}">
                                            <button type="submit" class="btn-action text-red-600 hover:text-red-800 font-medium flex items-center">
                                                <i class="fas fa-trash-alt mr-1"></i> Delete
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
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

<!-- Simple JavaScript for interactions -->
<script>
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

                    // Switch back to menu icon
                    mobileMenuButton.innerHTML = '<i class="fas fa-bars text-2xl"></i>';
                }
            });
        }
    });
</script>
</body>
</html>