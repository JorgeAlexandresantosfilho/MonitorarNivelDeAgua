const express = require('express');
const app = express();
const usuarioRoutes = require('./routes/usuarioroutes');
const registroRoutes = require('./routes/registroroutes');
const authRoutes = require('./routes/authroutes');
const logRoutes = require('./routes/logroutes');



app.use(express.json());
app.use('/monitoapi', usuarioRoutes);
app.use('/monitoapi', registroRoutes);
app.use('/auth', authRoutes);
app.use('/api', logRoutes);
module.exports = app;
