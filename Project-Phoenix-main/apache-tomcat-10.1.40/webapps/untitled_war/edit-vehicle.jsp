<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Edit Vehicle - Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    @keyframes slideUp { from { opacity: 0; transform: translateY(50px); } to { opacity: 1; transform: translateY(0); } }
    .slide-up { animation: slideUp 0.8s ease-out; }
    .input-field, .select-field { transition: all 0.3s ease; }
    .input-field:focus, .select-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    .btn-submit { transition: all 0.3s ease; }
    .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
  </style>
</head>
<body class="bg-gray-100 font-sans">
<nav class="bg-white shadow-lg p-4">
  <div class="container mx-auto flex justify-between items-center">
    <h1 class="text-2xl font-bold text-blue-700">Vehicle Rental</h1>
    <div class="space-x-4">
      <a href="vehicles?action=list" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Vehicles</a>
      <c:if test="${sessionScope.isAdmin}">
        <a href="vehicles?action=rentals" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Rentals</a>
      </c:if>
      <a href="vehicles?action=logout" class="text-red-600 hover:text-red-800 transition-all duration-300">Logout</a>
    </div>
  </div>
</nav>
<div class="container mx-auto p-6 flex justify-center">
  <div class="bg-white p-8 rounded-lg shadow-lg max-w-md w-full slide-up">
    <c:if test="${sessionScope.user == null || !sessionScope.isAdmin}">
      <c:redirect url="vehicles?action=list"/>
    </c:if>
    <h1 class="text-3xl font-bold text-blue-700 mb-6">Edit Vehicle</h1>
    <form action="vehicles" method="post">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" value="${vehicle.id}">
      <div class="mb-4">
        <input type="text" name="model" value="${vehicle.model}" class="input-field w-full p-3 border rounded-lg focus:outline-none">
      </div>
      <div class="mb-4">
        <input type="number" name="price" value="${vehicle.rentPrice}" class="input-field w-full p-3 border rounded-lg focus:outline-none">
      </div>
      <div class="mb-4">
        <select name="available" class="select-field w-full p-3 border rounded-lg focus:outline-none">
          <option value="true" ${vehicle.available ? 'selected' : ''}>Available</option>
          <option value="false" ${!vehicle.available ? 'selected' : ''}>Not Available</option>
        </select>
      </div>
      <div class="mb-6">
        <select name="category" class="select-field w-full p-3 border rounded-lg focus:outline-none">
          <option value="Sedan" ${vehicle.category == 'Sedan' ? 'selected' : ''}>Sedan</option>
          <option value="SUV" ${vehicle.category == 'SUV' ? 'selected' : ''}>SUV</option>
          <option value="Sports" ${vehicle.category == 'Sports' ? 'selected' : ''}>Sports</option>
          <option value="Truck" ${vehicle.category == 'Truck' ? 'selected' : ''}>Truck</option>
        </select>
      </div>
      <button type="submit" class="btn-submit w-full bg-blue-600 text-white p-3 rounded-lg font-semibold hover:bg-blue-700">Update Vehicle</button>
    </form>
  </div>
</div>
</body>
</html>