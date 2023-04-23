import React from 'react';
import './App.css';
import AnimatedRoutes from './Components/AnimatedRoutes'
import {MemoryRouter as Router, Route, Routes } from 'react-router-dom';

function App() {
  return (
    <div className="App">
      <Router initialEntries={["/"]}>
        <AnimatedRoutes />
      </Router>
    </div>
  );
}

export default App;
