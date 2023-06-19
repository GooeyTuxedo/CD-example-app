import { MongoClient } from 'mongodb'

const uri = process.env.MONGODB_URI || 'mongo://localhost:27017'; // pretty sure thats the default uri, might be wrong

export async function createUser(username, password) {
  const client = await MongoClient.connect(uri)
  const db = client.db("nextjs-test")

  // Check if user already exists
  const existingUser = await db.collection('users').findOne({ username })
  if (existingUser) {
    throw new Error('Username already taken')
  }

  // Hash the password using bcrypt
  const saltRounds = 10
  const hash = await bcrypt.hash(password, saltRounds)

  // Insert the new user into the database
  const result = await db.collection('users').insertOne({
    username,
    password: hash,
  })

  return result.insertedId
}

export async function connectToDatabase() {
  const client = new MongoClient(uri, { useUnifiedTopology: true });

  try {
    await client.connect();
    console.log('Connected to the database');

    const database = client.db('inventory');
    return database;
  } catch (error) {
    console.error('Error connecting to the database', error);
    throw new Error('Could not connect to database');
  }
}
