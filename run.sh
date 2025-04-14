#!/bin/bash

echo "🚀 Iniciando el backend..."
cd backend
node server.js &
BACK_PID=$!

cd ../frontend
echo "⚛️ Iniciando el frontend..."
npm run dev &
FRONT_PID=$!

echo ""
echo "✅ Ambos servicios están corriendo:"
echo "🔙 Backend → http://localhost:5000"
echo "🔜 Frontend → http://localhost:5173"
echo "Presiona Ctrl + C para detenerlos"
echo ""

wait $BACK_PID $FRONT_PID
