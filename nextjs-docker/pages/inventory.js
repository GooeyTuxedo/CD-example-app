import React from 'react';
import { withIronSession } from 'next-iron-session';

const Inventory = ({ user }) => {
  // Render the inventory page with the user's information
  return (
    <div>
      <h1>Welcome, {user.username}!</h1>
      <p>Here is a list of your tokens:</p>
      {/* TODO: Render the list of tokens here */}
      <button>Add Token</button>
      <button>Delete Tokens</button>
    </div>
  );
};

export const getServerSideProps = withIronSession(
  async ({ req, res }) => {
    // Get the user from the session
    const user = req.session.get('user');

    // If the user is not logged in, redirect to the login page
    if (!user) {
      res.statusCode = 302;
      res.setHeader('Location', '/login');
      return { props: {} };
    }

    // Otherwise, render the inventory page with the user's information
    return {
      props: { user },
    };
  },
  {
    password: process.env.SECRET_COOKIE_PASSWORD,
    cookieName: 'inventory-session',
    cookieOptions: {
      secure: process.env.NODE_ENV === 'production',
    },
  }
);

export default Inventory;