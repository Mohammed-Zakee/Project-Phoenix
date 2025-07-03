<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phoenix Vehicle Rental Service</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            scroll-behavior: smooth;
        }
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(20px); } 
            to { opacity: 1; transform: translateY(0); } 
        }
        @keyframes slideIn { 
            from { transform: translateX(-20px); opacity: 0; } 
            to { transform: translateX(0); opacity: 1; } 
        }
        .fade-in { animation: fadeIn 1s ease-in-out; }
        .slide-in { animation: slideIn 0.5s ease-out; }
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
        .hero-bg { 
            background: linear-gradient(135deg, #4f46e5, #3b82f6);
            position: relative;
            overflow: hidden;
        }
        .hero-bg::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80') no-repeat center center/cover;
            opacity: 0.2;
            z-index: 0;
        }
        .hero-content {
            position: relative;
            z-index: 1;
        }
        .btn {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .btn::before {
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
        .btn:hover::before {
            transform: translateX(100%) skewX(-15deg);
        }
        .feature-card {
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-10px);
        }
        .car-icon {
            transition: all 0.5s ease;
        }
        .feature-card:hover .car-icon {
            transform: scale(1.2);
        }
    </style>
</head>
<body class="bg-gray-50 font-sans">
    <!-- Navbar -->
    <nav class="bg-white shadow-md py-4 sticky top-0 z-50">
        <div class="container mx-auto px-6 flex justify-between items-center">
            <a href="#" class="flex items-center space-x-3">
                <i class="fas fa-car-side text-indigo-600 text-3xl"></i>
                <h1 class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-blue-500">Phoenix Rentals</h1>
            </a>            <div class="hidden md:flex space-x-8">
                <a href="index.jsp" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                    <i class="fas fa-home mr-2"></i>Home
                </a>
                <c:if test="${sessionScope.user != null}">
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
                    <a href="vehicles?action=logout" class="nav-link text-red-600 hover:text-red-700 font-medium">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </a>
                </c:if>
                <c:if test="${sessionScope.user == null}">
                    <a href="login.jsp" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                        <i class="fas fa-sign-in-alt mr-2"></i>Login
                    </a>
                    <a href="register.jsp" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
                        <i class="fas fa-user-plus mr-2"></i>Register
                    </a>
                </c:if>
            </div>
            <button class="md:hidden text-gray-700 focus:outline-none">
                <i class="fas fa-bars text-2xl"></i>
            </button>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-bg text-white py-28 fade-in">
        <div class="container mx-auto px-6 hero-content">
            <div class="md:flex items-center">
                <div class="md:w-1/2 text-left md:pr-16">
                    <h1 class="text-4xl md:text-6xl font-bold mb-6 leading-tight">Drive Your <span class="text-yellow-300">Dreams</span> Today</h1>
                    <p class="text-lg md:text-xl mb-8 text-gray-100">Experience premium vehicles with our hassle-free rental service. Anywhere, anytime, at your convenience.</p>
                    <div class="flex flex-wrap gap-4">
                        <c:if test="${sessionScope.user == null}">
                            <a href="login.jsp" class="btn bg-white text-indigo-700 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 shadow-lg">
                                <i class="fas fa-sign-in-alt mr-2"></i>Login
                            </a>
                            <a href="register.jsp" class="btn bg-transparent border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white hover:text-indigo-700 transition-colors">
                                <i class="fas fa-user-plus mr-2"></i>Register
                            </a>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <a href="vehicles?action=list" class="btn bg-white text-indigo-700 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 shadow-lg">
                                <i class="fas fa-car mr-2"></i>Explore Vehicles
                            </a>
                        </c:if>
                    </div>
                </div>
                <div class="md:w-1/2 mt-10 md:mt-0">
                    <img src="https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" alt="Luxury Car" class="rounded-lg shadow-2xl" style="opacity: 0.9;">
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <div class="py-16 bg-white">
        <div class="container mx-auto px-6">
            <h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Why Choose <span class="text-indigo-600">Phoenix Rentals</span>?</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Feature 1 -->
                <div class="feature-card bg-gradient-to-br from-indigo-50 to-blue-50 p-8 rounded-xl shadow-lg">
                    <div class="text-indigo-600 mb-4">
                        <i class="fas fa-car-side car-icon text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-3 text-gray-800">Premium Vehicles</h3>
                    <p class="text-gray-600">Choose from our wide range of well-maintained premium vehicles for your journey.</p>
                </div>
                
                <!-- Feature 2 -->
                <div class="feature-card bg-gradient-to-br from-indigo-50 to-blue-50 p-8 rounded-xl shadow-lg">
                    <div class="text-indigo-600 mb-4">
                        <i class="fas fa-money-bill-wave car-icon text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-3 text-gray-800">Affordable Rates</h3>
                    <p class="text-gray-600">Enjoy competitive pricing with no hidden fees. Get the best value for your money.</p>
                </div>
                
                <!-- Feature 3 -->
                <div class="feature-card bg-gradient-to-br from-indigo-50 to-blue-50 p-8 rounded-xl shadow-lg">
                    <div class="text-indigo-600 mb-4">
                        <i class="fas fa-headset car-icon text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-3 text-gray-800">24/7 Support</h3>
                    <p class="text-gray-600">Our customer support team is available round the clock to assist you with any queries.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Call to Action -->
    <div class="bg-gradient-to-r from-indigo-600 to-blue-500 py-12 slide-in">
        <div class="container mx-auto px-6 text-center">
            <h2 class="text-3xl font-bold text-white mb-4">Ready to hit the road?</h2>
            <p class="text-xl text-indigo-100 mb-8">Join thousands of satisfied customers who trust Phoenix for their vehicle rental needs.</p>
            <c:if test="${sessionScope.user == null}">
                <a href="register.jsp" class="btn bg-white text-indigo-700 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 shadow-lg inline-block">
                    <i class="fas fa-user-plus mr-2"></i>Create an Account
                </a>
            </c:if>
            <c:if test="${sessionScope.user != null}">
                <a href="vehicles?action=list" class="btn bg-white text-indigo-700 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 shadow-lg inline-block">
                    <i class="fas fa-car mr-2"></i>Browse Available Vehicles
                </a>            </c:if>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-12">
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
    </footer>    <!-- Simple JavaScript for interactions -->
    <script>
        // Mobile navigation toggle
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuButton = document.querySelector('.md\\:hidden');
            const mobileMenu = document.querySelector('.md\\:flex');
            
            if (mobileMenuButton && mobileMenu) {
                // Create mobile menu content
                mobileMenuButton.addEventListener('click', function() {
                    if (mobileMenu.classList.contains('hidden')) {
                        // Show mobile menu
                        mobileMenu.classList.remove('hidden');
                        mobileMenu.classList.add('flex', 'flex-col', 'absolute', 'top-16', 'right-0', 'bg-white', 'p-4', 'shadow-lg', 'rounded-lg', 'w-48', 'z-50');
                        
                        // Add a Home link if it doesn't exist
                        const hasHomeLink = Array.from(mobileMenu.children).some(child => 
                            child.textContent.includes('Home'));
                            
                        if (!hasHomeLink) {
                            const homeLink = document.createElement('a');
                            homeLink.href = 'index.jsp';
                            homeLink.className = 'nav-link text-gray-700 hover:text-indigo-600 font-medium py-2';
                            homeLink.innerHTML = '<i class="fas fa-home mr-2"></i>Home';
                            mobileMenu.insertBefore(homeLink, mobileMenu.firstChild);
                        }
                        
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
</body>
</html>