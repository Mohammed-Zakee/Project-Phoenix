<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Vehicle - Phoenix Rentals</title>
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
    @keyframes slideUp { 
      from { opacity: 0; transform: translateY(50px); } 
      to { opacity: 1; transform: translateY(0); } 
    }
    .slide-up { animation: slideUp 0.8s ease-out; }
    .input-field, .select-field { 
      transition: all 0.3s ease;
      border-left: 4px solid transparent;
    }
    .input-field:focus, .select-field:focus { 
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
    .brand-gradient {
      background: linear-gradient(to right, #4f46e5, #3b82f6);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }
    .form-card {
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }
    .card-header {
      background: linear-gradient(135deg, #4f46e5, #3b82f6);
      padding: 1.5rem;
      color: white;
    }
  </style>
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
          <a href="vehicles?action=rentals" class="nav-link text-gray-700 hover:text-indigo-600 font-medium">
            <i class="fas fa-clipboard-list mr-2"></i>Rentals
          </a>
        </c:if>
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

  <div class="container mx-auto p-6 flex justify-center">
    <c:if test="${sessionScope.user == null || !sessionScope.isAdmin}">
      <c:redirect url="vehicles?action=list"/>
    </c:if>
    
    <div class="form-card bg-white max-w-md w-full slide-up">
      <div class="card-header">
        <h1 class="text-2xl font-bold">Add New Vehicle</h1>
        <p class="text-indigo-100 mt-1">Enter vehicle details below</p>
      </div>
      
      <div class="p-8">
        <form action="vehicles" method="post" class="space-y-6">
          <input type="hidden" name="action" value="add">
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Vehicle ID</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <i class="fas fa-hashtag text-gray-400"></i>
              </div>
              <input 
                type="text" 
                name="id" 
                placeholder="Enter vehicle ID" 
                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none" 
                required>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Model</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <i class="fas fa-car text-gray-400"></i>
              </div>
              <input 
                type="text" 
                name="model" 
                placeholder="Enter vehicle model" 
                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none" 
                required>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Rental Price</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <i class="fas fa-dollar-sign text-gray-400"></i>
              </div>
              <input 
                type="number" 
                name="price" 
                placeholder="Enter price per day" 
                class="input-field w-full pl-10 pr-3 py-3 border border-gray-200 rounded-lg focus:outline-none" 
                required 
                min="0">
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <i class="fas fa-tag text-gray-400"></i>
              </div>
              <select 
                name="category" 
                class="select-field w-full pl-10 pr-10 py-3 border border-gray-200 rounded-lg focus:outline-none appearance-none" 
                required>
                <option value="">Select a category</option>
                <option value="Economy">Economy</option>
                <option value="Sedan">Sedan</option>
                <option value="SUV">SUV</option>
                <option value="Luxury">Luxury</option>
                <option value="Sports">Sports</option>
                <option value="Truck">Truck</option>
                <option value="Van">Van</option>
              </select>
              <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                <i class="fas fa-chevron-down text-gray-400"></i>
              </div>
            </div>
          </div>
          
          <button 
            type="submit" 
            class="btn-submit w-full bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-3 px-4 rounded-lg font-medium hover:shadow-lg flex justify-center items-center space-x-2">
            <i class="fas fa-plus-circle"></i>
            <span>Add Vehicle</span>
          </button>
        </form>
        
        <div class="mt-6 text-center">
          <a href="vehicles?action=list" class="inline-flex items-center text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
            <i class="fas fa-arrow-left mr-2"></i> Back to Vehicles
          </a>
        </div>
      </div>
    </div>
  </div>

  <!-- Simple JavaScript for mobile menu toggle -->
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