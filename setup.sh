#!/bin/bash

echo "🔍 Verificando que el directorio 'PROYECTOXX' existe..."

if [ ! -d "./PROYECTOXX" ]; then
  echo "❌ Error: No se encontró el directorio 'PROYECTOXX'."
  exit 1
fi

cd PROYECTOXX

echo "📁 Creando carpetas 'frontend' y 'backend'..."
mkdir -p frontend backend

# === BACKEND ===
cd backend

echo "📦 Inicializando backend..."
npm init -y > /dev/null
npm install express mongoose cors dotenv > /dev/null

echo "📁 Creando estructura de carpetas..."
mkdir -p routes models controllers

# .env
cat <<EOF > .env
PORT=5000
MONGO_URI=mongodb+srv://<usuario>:<password>@<cluster>.mongodb.net/<basededatos>?retryWrites=true&w=majority
EOF

# Modelo ejemplo: User
cat <<EOF > models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
});

module.exports = mongoose.model('User', userSchema);
EOF

# Ruta ejemplo
cat <<EOF > routes/userRoutes.js
const express = require('express');
const router = express.Router();
const User = require('../models/User');

router.get('/', async (req, res) => {
  const users = await User.find();
  res.json(users);
});

router.post('/', async (req, res) => {
  const { name, email } = req.body;
  try {
    const newUser = new User({ name, email });
    const savedUser = await newUser.save();
    res.status(201).json(savedUser);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
EOF

# server.js
cat <<EOF > server.js
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const userRoutes = require('./routes/userRoutes');

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('✅ Conectado a MongoDB Atlas'))
  .catch(err => console.error('❌ Error de conexión:', err));

app.use('/api/users', userRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`🚀 Servidor backend en puerto \${PORT}\`));
EOF

echo "✅ Backend listo con modelo y ruta ejemplo."

# === FRONTEND ===
cd ../frontend

echo "⚛️ Creando frontend con Vite..."
npm create vite@latest . -- --template react > /dev/null
npm install > /dev/null

echo "✅ Frontend listo."

cd ..

echo "🎉 Proyecto completo creado en ./PROYECTOXX"
echo "📂 Estructura creada:"
tree -L 2 PROYECTOXX

