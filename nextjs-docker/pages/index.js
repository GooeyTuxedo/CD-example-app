import Head from 'next/head'
import styles from '../styles/Home.module.css'
import Carousel from './carousel'

export default function Home() {
  const [carouselObjects, setCarouselObjects] = useState([
    {
      type: 'video',
      url: 'https://ipfs.io/ipfs/QmewLtn4J19z6hi1cZUysQ6UmdFs6h5zJ94MvrG1fzL8XA'
    },
    {
      type: 'image',
      url: '/api/image/1'
    },
    {
      type: 'image',
      url: '/api/image/2'
    }
  ]);

  return (
    <div className={styles.container}>
      <Head>
        <title>JPG Gallery</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Carousel carouselObjects={carouselObjects} />

      <footer className={styles.footer}>
          Powered by a Chadded up dev
      </footer>
    </div>
  )
}
