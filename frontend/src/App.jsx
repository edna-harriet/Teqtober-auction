const App = () => {
    return (
      <div className="App">
        <form className="form" onSubmit={handleSubmit}>
          <input type="file" name="data" onChange={retrieveFile} />
          <button type="submit" className="btn">Upload file</button>
        </form>
      </div>
    )
  }