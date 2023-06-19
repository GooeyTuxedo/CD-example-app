import { MongoClient } from 'mongodb';
import bcrypt from 'bcrypt';

export default async function handler(req, res) {
  const client = new MongoClient('<mongo_connection_string>');
  
  try {
    await client.connect();

    const db = client.db('<database_name>');
    const collection = db.collection('<collection_name>');

    const { username, password } = req.body;

    // Check if user with given username exists in the database
    const user = await collection.findOne({ username });
    if (!user) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    // Check if the password matches
    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    // Create a session for the user
    req.session.user = {
      id: user._id,
      username: user.username,
    };

    return res.status(200).json({ message: 'Logged in successfully' });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    await client.close();
  }
}