import sha256 from 'crypto-js/sha256';
import Hex from 'crypto-js/enc-hex';

const plaintexts = [
 "This is a message to hash",
 "This is a very different message to hash",
 "Supercalifragilistic expialidocious"
];

export default function hashes(req, res) {
  const date = Date.now();
  const hashes = plaintexts
    .map(text => ({ date, text }).toString())
    .map(objText => sha256(objText).toString(Hex))
  res.status(200).json({ hashes })
}

