function Image({ url }) {
  const [imageSrc, setImageSrc] = useState('');

  useEffect(() => {
    fetchImage(url).then((data) => {
      setImageSrc(`data:image/png;base64,${data}`);
    });
  }, [url]);

  return (
    <img src={imageSrc} />
  );
}

async function fetchImage(url) {
  const imgData = await fetch(url);
  return imgData;
}