import React, { useState, ChangeEvent, FormEvent } from 'react';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import { styled } from '@mui/system';
import './login.css'

const LoginTextField = styled(TextField)({
  padding: '10px',
});

const LoginPage: React.FC = () => {
  const [email, setEmail] = useState<string>('');
  const [password, setPassword] = useState<string>('');

  const handleEmailChange = (event: ChangeEvent<HTMLInputElement>) => {
    setEmail(event.target.value);
  };

  const handlePasswordChange = (event: ChangeEvent<HTMLInputElement>) => {
    setPassword(event.target.value);
  };

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    // Perform login logic here (e.g., call an API)
    console.log('Email:', email, 'Password:', password);
  };

  return (
    <div>
      <h1>Login</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <LoginTextField
            type="email"
            id="email"
            name="email"
            placeholder='Email'
            value={email}
            onChange={handleEmailChange}
            required
          />
        </div>
        <div>
          <LoginTextField
            type="password"
            id="password"
            name="password"
            placeholder='Password'
            value={password}
            onChange={handlePasswordChange}
            required
          />
        </div>
        <Button variant="text" type="submit">Login</Button>
      </form>
    </div>
  );
};

export default LoginPage;
