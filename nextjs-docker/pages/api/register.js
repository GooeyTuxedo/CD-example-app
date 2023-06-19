import { createUser } from '../../lib/db'

export default async function register(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).end() // Method Not Allowed
  }

  const { username, password } = req.body

  try {
    const userId = await createUser(username, password)
    res.status(201).json({ message: 'User created', userId })
  } catch (error) {
    res.status(400).json(error.message)
  }
}