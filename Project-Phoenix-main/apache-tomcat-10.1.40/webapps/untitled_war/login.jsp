<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Phoenix Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background-image: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
      background-attachment: fixed;
    }
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(50px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .slide-up { animation: slideUp 0.8s ease-out; }
    .input-field { 
      transition: all 0.3s ease;
      border-left: 4px solid transparent;
    }
    .input-field:focus { 
      border-color: #4f46e5; 
      box-shadow: 0 0 15px rgba(79, 70, 229, 0.15);
      border-left: 4px solid #4f46e5;
    }
    .login-btn { 
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
      z-index: 1;
    }
    .login-btn::before {
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
    .login-btn:hover::before {
      transform: translateX(100%) skewX(-15deg);
    }
    .login-card {
      backdrop-filter: blur(10px);
      background: rgba(255, 255, 255, 0.9);
    }
    .brand-gradient {
      background: linear-gradient(to right, #4f46e5, #3b82f6);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }
  </style>
</head>
<body class="flex items-center justify-center min-h-screen py-12 px-4 sm:px-6 lg:px-8">
  <div class="login-card max-w-md w-full p-8 rounded-xl shadow-2xl slide-up">
    <div class="flex justify-center mb-8">
      <div class="text-center">
        <i class="fas fa-car-side text-indigo-600 text-5xl mb-4"></i>
        <h1 class="text-4xl font-bold brand-gradient">Phoenix Rentals</h1>
        <p class="text-gray-500 mt-2">Login to your account</p>
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
    
    <c:if test="${not empty success}">
      <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded">
        <div class="flex">
          <div class="flex-shrink-0">
            <i class="fas fa-check-circle text-green-500"></i>
          </div>
          <div class="ml-3">
            <p class="text-sm text-green-700">${success}</p>
          </div>
        </div>
      </div>
    </c:if>

    <form action="vehicles" method="post" class="space-y-6">
      <input type="hidden" name="action" value="login">
      <div>
        <div class="relative">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <i class="fas fa-user text-gray-400"></i>
          </div>
          <input type="text" name="username" placeholder="Username" 
                class="input-field w-full pl-10 pr-3 py-4 border border-gray-200 rounded-lg focus:outline-none" required>
        </div>
      </div>
      
      <div>
        <div class="relative">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <i class="fas fa-lock text-gray-400"></i>
          </div>
          <input type="password" name="password" placeholder="Password" 
                class="input-field w-full pl-10 pr-3 py-4 border border-gray-200 rounded-lg focus:outline-none" required>
        </div>
      </div>
      
      <div>
        <button type="submit" 
                class="login-btn w-full bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-4 px-4 rounded-lg font-semibold hover:shadow-lg transform hover:-translate-y-1">
          Sign In
        </button>
      </div>
    </form>
    
    <div class="mt-8 text-center">
      <p class="text-gray-600">Don't have an account? 
        <a href="register.jsp" class="text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
          Create Account
        </a>
      </p>
    </div>
    
    <div class="mt-6 text-center">
      <a href="index.jsp" class="inline-flex items-center text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
        <i class="fas fa-arrow-left mr-2"></i> Back to Home
      </a>
    </div>
  </div>
</body>
</html>