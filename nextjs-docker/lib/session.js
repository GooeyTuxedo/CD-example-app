import { withIronSession } from "iron-session";

export default function withSession(handler) {
  return withIronSession(handler, {
    password: process.env.SECRET_COOKIE_PASSWORD,
    cookieName: "my-app-cookie",
    cookieOptions: {
      secure: process.env.NODE_ENV === "production",
    },
  });
}