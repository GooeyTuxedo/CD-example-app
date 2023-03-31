import styles from '../styles/Video.module.css'

export default function Video({ url }) {
  const url = process.env.NEXT_PUBLIC_DOMAIN_URL
  const videoHash = process.env.NEXT_PUBLIC_VIDEO_HASH
  const videoUrl = `https://ipfs.${url}/ipfs/${videoHash}`

  return (
    <div className={styles.videoWrapper}>
      <video className={styles.video} controls>
        <source src={videoUrl} type="video/mp4" />
      </video>
    </div>
  )
}
