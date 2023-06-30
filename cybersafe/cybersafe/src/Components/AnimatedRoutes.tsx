import React from 'react';
import LoginPage from '../Pages/Login/LoginPage';
import AccountDetailPage from '../Pages/AccountDetailPage/AccountDetailsPage';
import { Route, Routes, useLocation } from 'react-router-dom';
import {AnimatePresence} from 'framer-motion'


function AnimatedRoutes() {
  const location = useLocation()
  return (
    <AnimatePresence>
        <Routes location={location} key={location.pathname}>
            <Route path="/" index element={<AccountDetailPage />} />
            <Route path="/login" element={<LoginPage />} />
        </Routes>
    </AnimatePresence>
    );
}

export default AnimatedRoutes;
