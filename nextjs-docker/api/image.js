import axios from 'axios';

const url = process.env.NEXT_PUBLIC_DOMAIN_URL
const ipfsGateway = `https://ipfs.${url}/ipfs`;

export default async function image(req, res) {
  const { hash } = req.query;

  try {
    const image = await axios.get(`${ipfsGateway}/${hash}`, { responseType: 'arraybuffer' })
      .then(response => Buffer.from(response.data, 'binary').toString('base64'));

    res.status(200).json(image);
  } catch (error) {
    console.error(error);
    res.status(500).end();
  }
}
