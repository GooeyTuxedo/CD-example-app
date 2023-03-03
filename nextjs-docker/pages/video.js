import { useState, useEffect } from 'react'
import { create } from 'ipfs-http-client'

const url = process.env.NEXT_PUBLIC_DOMAIN_URL
const videoHash = process.env.NEXT_PUBLIC_VIDEO_HASH

const client = create({ host: `ipfs.${url}`, port: 8080, protocol: 'https' })

export default function Video() {
  const [videoUrl, setVideoUrl] = useState(null)

  useEffect(() => {
    async function getVideoFromIPFS() {
      try {
        const { cid } = await client.resolve(`/ipfs/${videoHash}`)
        const videoUrl = `https://ipfs.${url}/ipfs/${cid.toString()}`

        setVideoUrl(videoUrl)
      } catch (e) {
        console.error(e)
      }
    }

    getVideoFromIPFS()
  }, [])

  if (!videoUrl) {
    return <div>Loading...</div>
  }

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
      <video controls>
        <source src={videoUrl} type="video/mp4" />
      </video>
    </div>
  )
}
