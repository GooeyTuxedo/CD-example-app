export default function Video() {
  const url = process.env.NEXT_PUBLIC_DOMAIN_URL
  const videoHash = process.env.NEXT_PUBLIC_VIDEO_HASH
  const videoUrl = `https://${url}/ipfs/${videoHash}`

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', width: '100%' }}>
      <video controls>
        <source src={videoUrl} type="video/mp4" />
      </video>
    </div>
  )
}
