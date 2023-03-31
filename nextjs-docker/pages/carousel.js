import { useState } from 'react'
import styles from '../styles/Carousel.module.css'

function Carousel({ carouselObjects }) {
  const [activeIndex, setActiveIndex] = useState(0)

  const handlePrevClick = () => {
    setActiveIndex(prevIndex => {
      const newIndex = prevIndex - 1
      return newIndex < 0 ? items.length - 1 : newIndex
    })
  }

  const handleNextClick = () => {
    setActiveIndex(prevIndex => {
      const newIndex = prevIndex + 1
      return newIndex >= items.length ? 0 : newIndex
    })
  }

  return (
    <div className={styles.carousel}>
      {carouselObjects.map((obj, index) => {
        if (obj.type === 'video') {
          return <Video key={index} url={obj.url} />;
        } else if (obj.type === 'image') {
          return <Image key={index} url={obj.url} />;
        }
      })}
      <div className={styles.carouselButtonPrev} onClick={handlePrevClick}>Prev</div>
      <div className={styles.carouselButtonNext} onClick={handleNextClick}>Next</div>
    </div>
  )
}

export default Carousel