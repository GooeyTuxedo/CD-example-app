import { getSession } from "iron-session";
import { connectToDatabase } from "../../lib/db";

// interface Token {
//   userId: number;
//   hash: String;
// }

export default async function handler(req, res) {
  const session = await getSession({ req });
  if (!session) {
    res.status(401).json({ message: "Unauthorized" });
    return;
  }

  const { method, query: { id } } = req;
  const userId = session.get("user").id;
  const db = await connectToDatabase();

  switch (method) {
    case "GET":
      // Get the user's inventory
      const userInventory = await db.collection("tokens").find({ userId }).toArray();
      res.status(200).json(userInventory);
      break;
    case "POST":
      // Add a new token to the user's inventory
      const { hash } = req.body;
      await db.collection("tokens").insertOne({ userId, hash });
      res.status(201).json({ message: "Token added to inventory" });
      break;
    case "PUT":
      // Update a token hash
      const { newHash } = req.body;
      await db.collection("tokens").updateOne({ userId, _id: id }, { $set: { hash: newHash }}, { upsert: true });
      res.status(200).json({ message: "Token hash updated" });
      break;
    case "DELETE":
      // Remove a token from the user's inventory
      await db.collection("tokens").deleteOne({ userId, _id: id });
      res.status(200).json({ message: "Token removed from inventory" });
      break;
    default:
      res.setHeader("Allow", ["GET", "POST", "DELETE"]);
      res.status(405).json({ message: `Method ${method} Not Allowed` });
  }

  db.close();
}