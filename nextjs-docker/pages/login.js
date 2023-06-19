import { useState } from 'react';
import Router from 'next/router';
import axios from 'axios';

const Login = () => {
  // Define state for the login form fields
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  // Define the login function
  const handleLogin = async (event) => {
    event.preventDefault();

    // Send a request to the login endpoint with the form data
    const response = await axios.post('/api/login', { username, password });

    // If the login was successful, redirect to the inventory page
    if (response.status === 200) {
      Router.push('/inventory');
    }
  };

  return (
    <div>
      <form onSubmit={handleLogin}>
        <label htmlFor="username">Username:</label>
        <input
          type="text"
          id="username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
        <br />
        <label htmlFor="password">Password:</label>
        <input
          type="password"
          id="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <br />
        <button type="submit">Log In</button>
      </form>
    </div>
  );
};

export default Login;
