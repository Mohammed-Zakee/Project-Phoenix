<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Phoenix Vehicle Rental</title>
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
        .register-btn { 
          transition: all 0.3s ease;
          position: relative;
          overflow: hidden;
          z-index: 1;
        }
        .register-btn::before {
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
        .register-btn:hover::before {
          transform: translateX(100%) skewX(-15deg);
        }
        .register-card {
          backdrop-filter: blur(10px);
          background: rgba(255, 255, 255, 0.9);
        }
        .brand-gradient {
          background: linear-gradient(to right, #4f46e5, #3b82f6);
          -webkit-background-clip: text;
          background-clip: text;
          color: transparent;
        }
        .bg-pattern {
          background-color: #f9fafb;
          background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cg fill-rule='evenodd'%3E%3Cg fill='%23e2e8f0' fill-opacity='0.4'%3E%3Cpath opacity='.5' d='M96 95h4v1h-4v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9zm-1 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9z'/%3E%3Cpath d='M6 5V0H5v5H0v1h5v94h1V6h94V5H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }
    </style>
</head>
<body class="bg-pattern flex items-center justify-center min-h-screen py-12 px-4 sm:px-6 lg:px-8">
    <div class="register-card max-w-md w-full p-8 rounded-xl shadow-2xl slide-up">
        <div class="flex justify-center mb-8">
            <div class="text-center">
                <i class="fas fa-user-plus text-indigo-600 text-5xl mb-4"></i>
                <h1 class="text-4xl font-bold brand-gradient">Create Account</h1>
                <p class="text-gray-500 mt-2">Join Phoenix Rentals today</p>
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

        <form action="vehicles" method="post" class="space-y-6">
            <input type="hidden" name="action" value="register">
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
                    class="register-btn w-full bg-gradient-to-r from-indigo-600 to-blue-500 text-white py-4 px-4 rounded-lg font-semibold hover:shadow-lg transform hover:-translate-y-1">
                    Create Account
                </button>
            </div>
        </form>
        
        <div class="mt-8 text-center">
            <p class="text-gray-600">Already have an account? 
                <a href="login.jsp" class="text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
                    Sign In
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