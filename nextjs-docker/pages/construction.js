import Head from 'next/head';

const ConstructionPage = () => {
  return (
    <>
      <Head>
        <title>Under Construction</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>
      <div className="container">
        <h1>Under Construction</h1>
        <p>We're currently working on something awesome. Please check back later!</p>
      </div>
      <style jsx>{`
        .container {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          height: 100vh;
          text-align: center;
        }
        
        h1 {
          font-size: 2.5rem;
          margin-bottom: 1rem;
        }
        
        p {
          font-size: 1.2rem;
          margin-bottom: 2rem;
        }
      `}</style>
    </>
  );
};

export default ConstructionPage;