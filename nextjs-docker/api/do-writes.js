import { MongoClient } from 'mongodb';

const uri = 'mongodb://localhost:27017/mydatabase'; // replace with your MongoDB URI
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

export default async function doWrites(req, res) {
  const { method } = req;
  const makeHash = () => Math.random().toString(36).slice(2, 10); // generate a random hash

  switch (method) {
    case 'POST':
      try {
        await client.connect();
        const db = client.db('mydatabase');
        const collection = db.collection('hashes');
        const hashes = Array.from({length: 3}, makeHash);
        hashes.forEach(async (hash) => {
          await collection.insertOne({ hash });
        });
        res.status(200).json({ message: `Hashes ${hashes} saved to database` });
      } catch (err) {
        console.error(err);
        res.status(500).send('Error saving hash to database');
      } finally {
        await client.close();
      }
      break;
    default:
      res.setHeader('Allow', ['POST']);
      res.status(405).send(`Method ${method} Not Allowed`);
  }
}
