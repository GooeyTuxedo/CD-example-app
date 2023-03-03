import { useState, useEffect } from 'react'

const url = process.env.NEXT_PUBLIC_DOMAIN_URL
const videoHash = process.env.NEXT_PUBLIC_VIDEO_HASH

export default function Video() {
  const videoUrl = `https://ipfs.${url}/ipfs/${videoHash}`

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
      <video controls>
        <source src={videoUrl} type="video/mp4" />
      </video>
    </div>
  )
}
